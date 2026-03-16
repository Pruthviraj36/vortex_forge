import 'package:path/path.dart' as p;

import '../services/file_system_service.dart';
import '../templates/default_templates.dart';
import '../templates/template_renderer.dart';
import '../utils/name_utils.dart';

class ProjectOptions {
  ProjectOptions({
    required this.projectName,
    required this.organization,
    required this.outputPath,
    required this.description,
  });

  final String projectName;
  final String organization;
  final String outputPath;
  final String description;
}

class ProjectGenerator {
  ProjectGenerator({
    required FileSystemService fileSystem,
    required TemplateRenderer templateRenderer,
  })  : _fileSystem = fileSystem,
        _templateRenderer = templateRenderer;

  final FileSystemService _fileSystem;
  final TemplateRenderer _templateRenderer;

  void generate(ProjectOptions options) {
    final root = p.join(options.outputPath, options.projectName);
    final appClassName = '${NameUtils.toPascalCase(options.projectName)}App';

    final vars = {
      'project_name': options.projectName,
      'project_description': options.description,
      'org_name': options.organization,
      'app_class_name': appClassName,
      'home_feature_name': 'home',
      'home_feature_pascal': 'Home',
      'home_feature_camel': 'home',
    };

    final files = <String, String>{
      p.join(root, '.forge.yaml'):
          _templateRenderer.render(DefaultTemplates.forgeConfig, vars),
      p.join(root, 'pubspec.yaml'):
          _templateRenderer.render(DefaultTemplates.pubspec, vars),
      p.join(root, 'analysis_options.yaml'):
          _templateRenderer.render(DefaultTemplates.analysisOptions, vars),
      p.join(root, 'README.md'):
          _templateRenderer.render(DefaultTemplates.projectReadme, vars),
      p.join(root, 'lib/main.dart'):
          _templateRenderer.render(DefaultTemplates.mainDart, vars),
      p.join(root, 'lib/app/app.dart'):
          _templateRenderer.render(DefaultTemplates.appDart, vars),
      p.join(root, 'lib/app/theme/app_theme.dart'):
          _templateRenderer.render(DefaultTemplates.appTheme, vars),
      p.join(root, 'lib/app/routes/app_routes.dart'):
          _templateRenderer.render(DefaultTemplates.appRoutes, vars),
      p.join(root, 'lib/app/routes/app_pages.dart'):
          _templateRenderer.render(DefaultTemplates.appPages, vars),
      p.join(root, 'lib/core/config/app_config.dart'):
          _templateRenderer.render(DefaultTemplates.appConfig, vars),
      p.join(root, 'lib/core/network/api_client.dart'):
          _templateRenderer.render(DefaultTemplates.apiClient, vars),
      p.join(root, 'lib/core/base/base_controller.dart'):
          _templateRenderer.render(DefaultTemplates.baseController, vars),
      p.join(root, 'lib/modules/home/bindings/home_binding.dart'):
          _templateRenderer.render(DefaultTemplates.featureBinding, vars),
      p.join(root, 'lib/modules/home/controllers/home_controller.dart'):
          _templateRenderer.render(DefaultTemplates.featureController, vars),
      p.join(root, 'lib/modules/home/models/home_model.dart'):
          _templateRenderer.render(DefaultTemplates.featureModel, vars),
      p.join(root, 'lib/modules/home/repositories/home_repository.dart'):
          _templateRenderer.render(DefaultTemplates.featureRepository, vars),
      p.join(root, 'lib/modules/home/services/home_service.dart'):
          _templateRenderer.render(DefaultTemplates.featureService, vars),
      p.join(root, 'lib/modules/home/views/home_view.dart'):
          _templateRenderer.render(DefaultTemplates.featureView, vars),
      p.join(root, 'test/home_controller_test.dart'): _templateRenderer.render(
          DefaultTemplates.featureControllerTest, vars),
    };

    for (final entry in files.entries) {
      _fileSystem.writeFile(entry.key, entry.value);
    }
  }
}
