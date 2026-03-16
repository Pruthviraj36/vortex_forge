import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../services/file_system_service.dart';

class ForgeConfig {
  ForgeConfig({
    required this.organization,
    required this.routePrefix,
  });

  final String organization;
  final String routePrefix;

  static ForgeConfig defaults() {
    return ForgeConfig(
      organization: 'com.example',
      routePrefix: '/',
    );
  }

  static Future<ForgeConfig> load(
      String root, FileSystemService fileSystem) async {
    final configPath = p.join(root, '.forge.yaml');
    if (!fileSystem.exists(configPath)) {
      return defaults();
    }

    final raw = fileSystem.readFile(configPath);
    final yaml = loadYaml(raw);
    if (yaml is! YamlMap) {
      return defaults();
    }

    return ForgeConfig(
      organization: (yaml['organization'] as String?) ?? 'com.example',
      routePrefix: (yaml['routePrefix'] as String?) ?? '/',
    );
  }
}
