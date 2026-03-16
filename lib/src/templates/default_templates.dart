class DefaultTemplates {
  static const forgeConfig = '''organization: {{org_name}}
routePrefix: /
''';

  static const analysisOptions = '''include: package:flutter_lints/flutter.yaml
''';

  static const pubspec = '''name: {{project_name}}
description: {{project_description}}
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  get: ^4.6.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
''';

  static const projectReadme = '''# {{project_name}}

Generated with flutter_forge (GetX + MVC).

## Run

1. flutter pub get
2. flutter run

## Generate Feature

flutter_forge make feature profile

## Generate Artifacts

flutter_forge make screen profile
flutter_forge make service profile
flutter_forge make repository profile
flutter_forge make model profile
''';

  static const mainDart = '''import 'package:flutter/material.dart';

import 'app/app.dart';

void main() {
  runApp(const {{app_class_name}}());
}
''';

  static const appDart = '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';

class {{app_class_name}} extends StatelessWidget {
  const {{app_class_name}}({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '{{project_name}}',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
''';

  static const appRoutes = '''part of 'app_pages.dart';

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
''';

  static const appPages = '''import 'package:get/get.dart';

import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
// ROUTE_IMPORTS

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = <GetPage<dynamic>>[
    GetPage(name: _Paths.home, page: () => const HomeView(), binding: HomeBinding()),
    // ROUTE_PAGES
  ];
}
''';

  static const appTheme = '''import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );
  }
}
''';

  static const apiClient = '''import 'package:get/get.dart';

class ApiClient extends GetConnect {
  ApiClient({required String baseUrl}) {
    httpClient.baseUrl = baseUrl;
    timeout = const Duration(seconds: 20);
  }
}
''';

  static const appConfig = '''class AppConfig {
  static const appName = '{{project_name}}';
  static const baseUrl = 'https://api.example.com';
}
''';

  static const baseController = '''import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
''';

  static const featureBinding = '''import 'package:get/get.dart';

import '../controllers/{{feature_name}}_controller.dart';

class {{feature_pascal}}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<{{feature_pascal}}Controller>(() => {{feature_pascal}}Controller());
  }
}
''';

  static const featureController = '''import 'package:get/get.dart';

class {{feature_pascal}}Controller extends GetxController {
  final count = 0.obs;

  void increment() {
    count.value++;
  }
}
''';

  static const featureService = '''import 'package:get/get.dart';

class {{feature_pascal}}Service extends GetxService {
  Future<void> init() async {}
}
''';

  static const featureRepository =
      '''import '../models/{{feature_name}}_model.dart';

class {{feature_pascal}}Repository {
  Future<List<{{feature_pascal}}Model>> fetchAll() async {
    return <{{feature_pascal}}Model>[];
  }
}
''';

  static const featureModel = '''class {{feature_pascal}}Model {
  const {{feature_pascal}}Model({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  factory {{feature_pascal}}Model.fromJson(Map<String, dynamic> json) {
    return {{feature_pascal}}Model(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
''';

  static const featureView = '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/{{feature_name}}_controller.dart';

class {{feature_pascal}}View extends GetView<{{feature_pascal}}Controller> {
  const {{feature_pascal}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{feature_pascal}}')),
      body: Center(
        child: Obx(() => Text('Count: \${controller.count.value}', style: Theme.of(context).textTheme.headlineMedium)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';

  static const featureControllerTest =
      '''import 'package:flutter_test/flutter_test.dart';

void main() {
  test('{{feature_pascal}}Controller smoke test placeholder', () {
    expect(1 + 1, 2);
  });
}
''';
}
