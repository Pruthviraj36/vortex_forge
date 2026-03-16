class TemplateRenderer {
  String render(String template, Map<String, String> values) {
    var output = template;
    for (final entry in values.entries) {
      output = output.replaceAll('{{${entry.key}}}', entry.value);
    }
    return output;
  }
}
