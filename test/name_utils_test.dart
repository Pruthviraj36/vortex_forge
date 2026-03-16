import 'package:vortex_forge/src/utils/name_utils.dart';
import 'package:test/test.dart';

void main() {
  group('NameUtils', () {
    test('toSnakeCase converts from mixed case', () {
      expect(NameUtils.toSnakeCase('UserProfileScreen'), 'user_profile_screen');
    });

    test('toPascalCase converts snake case', () {
      expect(NameUtils.toPascalCase('order_history'), 'OrderHistory');
    });

    test('toCamelCase converts snake case', () {
      expect(NameUtils.toCamelCase('order_history'), 'orderHistory');
    });
  });
}
