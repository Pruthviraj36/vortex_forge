import 'dart:io';

import 'package:vortex_forge/vortex_forge.dart';

Future<void> main(List<String> arguments) async {
  final exitCode = await FlutterForgeCli().run(arguments);
  if (exitCode != 0) {
    stderr.writeln('Command failed with exit code $exitCode.');
  }
  exit(exitCode);
}
