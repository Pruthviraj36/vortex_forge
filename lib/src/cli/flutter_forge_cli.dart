import 'dart:io';

import 'package:args/args.dart';

import '../config/forge_config.dart';
import '../generators/artifact_generator.dart';
import '../generators/feature_generator.dart';
import '../generators/project_generator.dart';
import '../services/file_system_service.dart';
import '../templates/template_renderer.dart';
import '../utils/name_utils.dart';

class FlutterForgeCli {
  FlutterForgeCli({
    FileSystemService? fileSystem,
    TemplateRenderer? templateRenderer,
  })  : _fileSystem = fileSystem ?? FileSystemService(),
        _templateRenderer = templateRenderer ?? TemplateRenderer();

  final FileSystemService _fileSystem;
  final TemplateRenderer _templateRenderer;

  Future<int> run(List<String> arguments) async {
    final parser = _buildParser();
    ArgResults results;

    try {
      results = parser.parse(arguments);
    } on FormatException catch (error) {
      stderr.writeln(error.message);
      _printUsage(parser);
      return 64;
    }

    if (results['help'] as bool || results.command == null) {
      _printUsage(parser);
      return 0;
    }

    final config = await ForgeConfig.load(Directory.current.path, _fileSystem);

    switch (results.command!.name) {
      case 'create':
        return _runCreate(results.command!, config);
      case 'make':
      case 'generate':
      case 'g':
        return _runMake(results.command!, config);
      default:
        stderr.writeln('Unknown command: ${results.command!.name}');
        _printUsage(parser);
        return 64;
    }
  }

  ArgParser _buildParser() {
    final parser = ArgParser();
    parser.addFlag('help', abbr: 'h', negatable: false, help: 'Show help.');

    final create = ArgParser()
      ..addOption('org', help: 'Organization id. Example: com.example')
      ..addOption(
        'output',
        abbr: 'o',
        defaultsTo: '.',
        help: 'Output directory root.',
      )
      ..addOption('description', defaultsTo: 'A new Flutter project.');
    parser.addCommand('create', create);

    final make = ArgParser();
    final feature = ArgParser()
      ..addOption(
        'target',
        defaultsTo: 'lib/modules',
        help: 'Feature parent directory.',
      )
      ..addFlag('with-test', defaultsTo: true, help: 'Generate test files.');
    final screen = ArgParser()
      ..addOption(
        'target',
        defaultsTo: 'lib/modules',
        help: 'Feature parent directory.',
      );
    final service = ArgParser()
      ..addOption(
        'target',
        defaultsTo: 'lib/modules',
        help: 'Feature parent directory.',
      );
    final repository = ArgParser()
      ..addOption(
        'target',
        defaultsTo: 'lib/modules',
        help: 'Feature parent directory.',
      );
    final model = ArgParser()
      ..addOption(
        'target',
        defaultsTo: 'lib/modules',
        help: 'Feature parent directory.',
      );
    make.addCommand('feature', feature);
    make.addCommand('module', feature);
    make.addCommand('screen', screen);
    make.addCommand('service', service);
    make.addCommand('repository', repository);
    make.addCommand('model', model);
    parser.addCommand('make', make);

    final generate = ArgParser();
    generate.addCommand('feature', feature);
    generate.addCommand('module', feature);
    generate.addCommand('screen', screen);
    generate.addCommand('service', service);
    generate.addCommand('repository', repository);
    generate.addCommand('model', model);
    parser.addCommand('generate', generate);

    final shortGenerate = ArgParser();
    shortGenerate.addCommand('feature', feature);
    shortGenerate.addCommand('module', feature);
    shortGenerate.addCommand('screen', screen);
    shortGenerate.addCommand('service', service);
    shortGenerate.addCommand('repository', repository);
    shortGenerate.addCommand('model', model);
    parser.addCommand('g', shortGenerate);

    return parser;
  }

  int _runCreate(ArgResults command, ForgeConfig config) {
    if (command.rest.isEmpty) {
      stderr.writeln('Missing project name.');
      return 64;
    }

    final projectName = NameUtils.toSnakeCase(command.rest.first);
    final generator = ProjectGenerator(
      fileSystem: _fileSystem,
      templateRenderer: _templateRenderer,
    );

    final options = ProjectOptions(
      projectName: projectName,
      organization: (command['org'] as String?) ?? config.organization,
      outputPath: command['output'] as String,
      description: command['description'] as String,
    );

    generator.generate(options);
    stdout.writeln('Project generated at ${options.outputPath}/$projectName');
    return 0;
  }

  int _runMake(ArgResults command, ForgeConfig config) {
    final name = command.command?.name;
    if (name == null) {
      stderr.writeln(
          'Unknown generate subcommand. Use: feature|module|screen|service|repository|model <name>');
      return 64;
    }

    final makeCommand = command.command!;
    if (makeCommand.rest.isEmpty) {
      stderr.writeln('Missing artifact name.');
      return 64;
    }

    final artifactName = NameUtils.toSnakeCase(makeCommand.rest.first);

    if (name == 'feature' || name == 'module') {
      final generator = FeatureGenerator(
        fileSystem: _fileSystem,
        templateRenderer: _templateRenderer,
      );

      final options = FeatureOptions(
        featureName: artifactName,
        projectRoot: Directory.current.path,
        targetDirectory: makeCommand['target'] as String,
        withTests: makeCommand['with-test'] as bool,
        routePrefix: config.routePrefix,
      );

      generator.generate(options);
      stdout.writeln('Feature generated: $artifactName');
      return 0;
    }

    final artifactType = _parseArtifactType(name);
    if (artifactType == null) {
      stderr.writeln('Unknown make subcommand: $name');
      return 64;
    }

    final generator = ArtifactGenerator(
      fileSystem: _fileSystem,
      templateRenderer: _templateRenderer,
    );

    final options = ArtifactOptions(
      type: artifactType,
      name: artifactName,
      projectRoot: Directory.current.path,
      targetDirectory: makeCommand['target'] as String,
    );

    generator.generate(options);
    stdout.writeln('Generated $name: $artifactName');
    return 0;
  }

  ArtifactType? _parseArtifactType(String name) {
    switch (name) {
      case 'screen':
        return ArtifactType.screen;
      case 'service':
        return ArtifactType.service;
      case 'repository':
        return ArtifactType.repository;
      case 'model':
        return ArtifactType.model;
      default:
        return null;
    }
  }

  void _printUsage(ArgParser parser) {
    stdout.writeln('vortex_forge <command> [arguments]');
    stdout.writeln('Commands:');
    stdout.writeln(
      '  create <project_name>   Create a Flutter GetX + MVC project boilerplate.',
    );
    stdout.writeln(
      '  make feature <name>     Generate feature module files and wire routes.',
    );
    stdout.writeln(
      '  generate module <name>  Nest-style alias for feature generation.',
    );
    stdout.writeln(
      '  g module <name>         Short alias for generate module.',
    );
    stdout.writeln('  make screen <name>      Generate a feature view.');
    stdout.writeln('  make service <name>     Generate a feature service.');
    stdout.writeln('  make repository <name>  Generate a feature repository.');
    stdout.writeln('  make model <name>       Generate a feature model.');
    stdout.writeln('');
    stdout.writeln(parser.usage);
  }
}
