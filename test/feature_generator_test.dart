import 'dart:io';

import 'package:vortex_forge/src/generators/feature_generator.dart';
import 'package:vortex_forge/src/services/file_system_service.dart';
import 'package:vortex_forge/src/templates/template_renderer.dart';
import 'package:test/test.dart';

void main() {
  test('generates feature files and wires route markers', () {
    final temp = Directory.systemTemp.createTempSync('forge_test_');
    addTearDown(() => temp.deleteSync(recursive: true));

    final routesDir = Directory('${temp.path}/lib/app/routes')
      ..createSync(recursive: true);
    File('${routesDir.path}/app_routes.dart').writeAsStringSync('''
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const home = _Paths.home;
  // PUBLIC_ROUTE_DEFINITIONS
}

abstract class _Paths {
  _Paths._();
  static const home = '/';
  // ROUTE_PATH_DEFINITIONS
}
''');

    File('${routesDir.path}/app_pages.dart').writeAsStringSync('''
import 'package:get/get.dart';
// ROUTE_IMPORTS

part 'app_routes.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    // ROUTE_PAGES
  ];
}
''');

    final generator = FeatureGenerator(
      fileSystem: FileSystemService(),
      templateRenderer: TemplateRenderer(),
    );

    generator.generate(
      FeatureOptions(
        featureName: 'profile',
        projectRoot: temp.path,
        targetDirectory: 'lib/modules',
        withTests: true,
        routePrefix: '/',
      ),
    );

    expect(
        File('${temp.path}/lib/modules/profile/controllers/profile_controller.dart')
            .existsSync(),
        isTrue);
    expect(File('${temp.path}/test/profile_controller_test.dart').existsSync(),
        isTrue);

    final routesContent =
        File('${routesDir.path}/app_routes.dart').readAsStringSync();
    final pagesContent =
        File('${routesDir.path}/app_pages.dart').readAsStringSync();

    expect(routesContent.contains('static const profile = _Paths.profile;'),
        isTrue);
    expect(
        routesContent.contains("static const profile = '/profile';"), isTrue);
    expect(pagesContent.contains('ProfileBinding'), isTrue);
    expect(pagesContent.contains('ProfileView'), isTrue);
  });
}
