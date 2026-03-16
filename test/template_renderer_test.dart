import 'package:vortex_forge/src/templates/template_renderer.dart';
import 'package:test/test.dart';

void main() {
  test('replaces all placeholders', () {
    final renderer = TemplateRenderer();
    final result = renderer.render('Hello {{name}} from {{city}}', {
      'name': 'Ava',
      'city': 'Hanoi',
    });

    expect(result, 'Hello Ava from Hanoi');
  });
}
