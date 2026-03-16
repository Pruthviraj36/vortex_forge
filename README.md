# vortex_forge

Dart-first Flutter boilerplate generator inspired by Nest-style DX, focused on GetX + MVC.

## Why this package

- No Mason dependency
- No Get CLI dependency
- Generates Flutter-ready GetX MVC structure
- Creates project shell and feature modules with route auto-wiring

## Install (local)

```bash
dart pub get
dart run bin/flutter_forge.dart --help
```

## Install once (global command)

From this package root, run once:

```bash
dart pub global activate --source path .
```

Then use directly from anywhere:

```bash
vortex_forge --help
vx --help
```

If published, activate by package name:

```bash
dart pub global activate vortex_forge
```

## Commands

### Create project shell

```bash
dart run bin/flutter_forge.dart create my_app --org com.acme --output .
```

### Generate feature

Run inside generated project root.

```bash
vortex_forge make feature profile
vortex_forge generate module profile
vortex_forge g module profile
```

### Generate standalone artifacts

```bash
vortex_forge make screen profile
vortex_forge make service profile
vortex_forge make repository profile
vortex_forge make model profile
```

### Optional config

Create `.forge.yaml` in your target project root:

```yaml
organization: com.example
routePrefix: /
```

## Generated Architecture

```text
lib/
  app/
    app.dart
    theme/
    routes/
      app_pages.dart
      app_routes.dart
  core/
    base/
    config/
    network/
  modules/
    <feature>/
      bindings/
      controllers/
      models/
      repositories/
      services/
      views/
```

## Notes

- Project generation focuses on app-layer boilerplate and route wiring.
- Platform folders (`android`, `ios`, `web`, etc.) are not created by this package.
- To create full Flutter platform folders, run `flutter create .` in the generated project directory.
