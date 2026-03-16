import 'dart:io';

import 'package:path/path.dart' as p;

class FileSystemService {
  void ensureDirectory(String path) {
    Directory(path).createSync(recursive: true);
  }

  void writeFile(String path, String content) {
    final dir = p.dirname(path);
    ensureDirectory(dir);
    File(path).writeAsStringSync(content);
  }

  bool exists(String path) => File(path).existsSync();

  String readFile(String path) => File(path).readAsStringSync();

  void appendFile(String path, String content) {
    final file = File(path);
    file.writeAsStringSync(content, mode: FileMode.append);
  }
}
