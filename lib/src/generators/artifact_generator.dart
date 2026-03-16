import 'package:path/path.dart' as p;

import '../services/file_system_service.dart';
import '../templates/default_templates.dart';
import '../templates/template_renderer.dart';
import '../utils/name_utils.dart';

enum ArtifactType { screen, service, repository, model }

class ArtifactOptions {
  ArtifactOptions({
    required this.type,
    required this.name,
    required this.projectRoot,
    required this.targetDirectory,
  });

  final ArtifactType type;
  final String name;
  final String projectRoot;
  final String targetDirectory;
}

class ArtifactGenerator {
  ArtifactGenerator({
    required FileSystemService fileSystem,
    required TemplateRenderer templateRenderer,
  })  : _fileSystem = fileSystem,
        _templateRenderer = templateRenderer;

  final FileSystemService _fileSystem;
  final TemplateRenderer _templateRenderer;

  void generate(ArtifactOptions options) {
    final featureName = NameUtils.toSnakeCase(options.name);
    final pascal = NameUtils.toPascalCase(options.name);

    final vars = {
      'feature_name': featureName,
      'feature_pascal': pascal,
      'feature_camel': NameUtils.toCamelCase(options.name),
    };

    final featureRoot = p.join(options.projectRoot, options.targetDirectory, featureName);

    final fileMap = _resolveArtifactFiles(options.type, featureRoot, featureName, vars);
    for (final entry in fileMap.entries) {
      _fileSystem.writeFile(entry.key, entry.value);
    }
  }

  Map<String, String> _resolveArtifactFiles(
    ArtifactType type,
    String featureRoot,
    String featureName,
    Map<String, String> vars,
  ) {
    switch (type) {
      case ArtifactType.screen:
        return {
          p.join(featureRoot, 'views/${featureName}_view.dart'):
              _templateRenderer.render(DefaultTemplates.featureView, vars),
        };
      case ArtifactType.service:
        return {
          p.join(featureRoot, 'services/${featureName}_service.dart'):
              _templateRenderer.render(DefaultTemplates.featureService, vars),
        };
      case ArtifactType.repository:
        return {
          p.join(featureRoot, 'repositories/${featureName}_repository.dart'):
              _templateRenderer.render(DefaultTemplates.featureRepository, vars),
        };
      case ArtifactType.model:
        return {
          p.join(featureRoot, 'models/${featureName}_model.dart'):
              _templateRenderer.render(DefaultTemplates.featureModel, vars),
        };
    }
  }
}
