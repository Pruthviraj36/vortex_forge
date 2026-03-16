import 'dart:io';

import 'package:vortex_forge/src/generators/artifact_generator.dart';
import 'package:vortex_forge/src/services/file_system_service.dart';
import 'package:vortex_forge/src/templates/template_renderer.dart';
import 'package:test/test.dart';

void main() {
  test('creates model artifact under modules path', () {
    final temp = Directory.systemTemp.createTempSync('forge_artifact_');
    addTearDown(() => temp.deleteSync(recursive: true));

    final generator = ArtifactGenerator(
      fileSystem: FileSystemService(),
      templateRenderer: TemplateRenderer(),
    );

    generator.generate(
      ArtifactOptions(
        type: ArtifactType.model,
        name: 'profile',
        projectRoot: temp.path,
        targetDirectory: 'lib/modules',
      ),
    );

    expect(
      File('${temp.path}/lib/modules/profile/models/profile_model.dart')
          .existsSync(),
      isTrue,
    );
  });
}
