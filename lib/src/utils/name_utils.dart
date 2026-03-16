class NameUtils {
  static String toSnakeCase(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }

    final withUnderscore = trimmed
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (m) => '${m[1]}_${m[2]}',
        )
        .replaceAll(RegExp(r'[\s-]+'), '_');

    return withUnderscore.toLowerCase();
  }

  static String toPascalCase(String input) {
    final parts = toSnakeCase(input).split('_').where((p) => p.isNotEmpty);
    return parts.map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }

  static String toCamelCase(String input) {
    final pascal = toPascalCase(input);
    if (pascal.isEmpty) {
      return pascal;
    }
    return pascal[0].toLowerCase() + pascal.substring(1);
  }
}
