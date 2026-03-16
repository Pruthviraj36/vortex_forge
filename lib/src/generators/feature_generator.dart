import 'package:path/path.dart' as p;

import '../services/file_system_service.dart';
import '../templates/default_templates.dart';
import '../templates/template_renderer.dart';
import '../utils/name_utils.dart';

class FeatureOptions {
  FeatureOptions({
    required this.featureName,
    required this.projectRoot,
    required this.targetDirectory,
    required this.withTests,
    required this.routePrefix,
  });

  final String featureName;
  final String projectRoot;
  final String targetDirectory;
  final bool withTests;
  final String routePrefix;
}

class FeatureGenerator {
  FeatureGenerator({
    required FileSystemService fileSystem,
    required TemplateRenderer templateRenderer,
  })  : _fileSystem = fileSystem,
        _templateRenderer = templateRenderer;

  final FileSystemService _fileSystem;
  final TemplateRenderer _templateRenderer;

  void generate(FeatureOptions options) {
    final pascal = NameUtils.toPascalCase(options.featureName);
    final camel = NameUtils.toCamelCase(options.featureName);
    final featureRoot = p.join(
        options.projectRoot, options.targetDirectory, options.featureName);

    final vars = {
      'feature_name': options.featureName,
      'feature_pascal': pascal,
      'feature_camel': camel,
      'route_path': _buildRoutePath(options.routePrefix, options.featureName),
    };

    final files = <String, String>{
      p.join(featureRoot, 'bindings/${options.featureName}_binding.dart'):
          _templateRenderer.render(DefaultTemplates.featureBinding, vars),
      p.join(featureRoot, 'controllers/${options.featureName}_controller.dart'):
          _templateRenderer.render(DefaultTemplates.featureController, vars),
      p.join(featureRoot, 'models/${options.featureName}_model.dart'):
          _templateRenderer.render(DefaultTemplates.featureModel, vars),
      p.join(featureRoot,
              'repositories/${options.featureName}_repository.dart'):
          _templateRenderer.render(DefaultTemplates.featureRepository, vars),
      p.join(featureRoot, 'services/${options.featureName}_service.dart'):
          _templateRenderer.render(DefaultTemplates.featureService, vars),
      p.join(featureRoot, 'views/${options.featureName}_view.dart'):
          _templateRenderer.render(DefaultTemplates.featureView, vars),
    };

    for (final entry in files.entries) {
      _fileSystem.writeFile(entry.key, entry.value);
    }

    if (options.withTests) {
      final testPath = p.join(options.projectRoot, 'test',
          '${options.featureName}_controller_test.dart');
      _fileSystem.writeFile(
          testPath,
          _templateRenderer.render(
              DefaultTemplates.featureControllerTest, vars));
    }

    _wireRoute(options, vars);
  }

  String _buildRoutePath(String prefix, String featureName) {
    final cleanPrefix = prefix.trim();
    if (cleanPrefix.isEmpty || cleanPrefix == '/') {
      return '/$featureName';
    }

    final normalizedPrefix =
        cleanPrefix.startsWith('/') ? cleanPrefix : '/$cleanPrefix';
    return '$normalizedPrefix/$featureName';
  }

  void _wireRoute(FeatureOptions options, Map<String, String> vars) {
    final routesPath =
        p.join(options.projectRoot, 'lib/app/routes/app_routes.dart');
    final pagesPath =
        p.join(options.projectRoot, 'lib/app/routes/app_pages.dart');

    if (_fileSystem.exists(routesPath)) {
      var routesContent = _fileSystem.readFile(routesPath);
      final publicConst =
          "  static const ${vars['feature_camel']} = _Paths.${vars['feature_camel']};";
      final pathConst =
          "  static const ${vars['feature_camel']} = '${vars['route_path']}';";

      if (!routesContent.contains(publicConst)) {
        routesContent = routesContent.replaceFirst(
          '// PUBLIC_ROUTE_DEFINITIONS',
          '// PUBLIC_ROUTE_DEFINITIONS\n$publicConst',
        );
      }

      if (!routesContent.contains(pathConst)) {
        routesContent = routesContent.replaceFirst(
          '// ROUTE_PATH_DEFINITIONS',
          '// ROUTE_PATH_DEFINITIONS\n$pathConst',
        );
      }

      _fileSystem.writeFile(routesPath, routesContent);
    }

    if (_fileSystem.exists(pagesPath)) {
      var pagesContent = _fileSystem.readFile(pagesPath);
      final importLine =
          "import '../../modules/${vars['feature_name']}/bindings/${vars['feature_name']}_binding.dart';\n"
          "import '../../modules/${vars['feature_name']}/views/${vars['feature_name']}_view.dart';";

      final pageLine =
          '    GetPage(name: _Paths.${vars['feature_camel']}, page: () => const ${vars['feature_pascal']}View(), binding: ${vars['feature_pascal']}Binding()),';

      if (!pagesContent.contains(importLine.split('\n').first)) {
        pagesContent = pagesContent.replaceFirst(
          '// ROUTE_IMPORTS',
          '// ROUTE_IMPORTS\n$importLine',
        );
      }

      if (!pagesContent.contains(pageLine)) {
        pagesContent = pagesContent.replaceFirst(
          '// ROUTE_PAGES',
          '// ROUTE_PAGES\n$pageLine',
        );
      }

      _fileSystem.writeFile(pagesPath, pagesContent);
    }
  }
}
