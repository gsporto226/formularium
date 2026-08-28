import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_interfaces/form_entity_interface.dart';
import 'package:formularium/features/localization/localizable_interface.dart';

enum TestValidation implements ILocalizable {
  reason,
  warn,
  other;

  @override
  String localize() => name;
}

/// Shared test: verifies the enabled getter/setter on any IFormEntity.
void testFieldEnabledToggle(IFormEntity<dynamic> Function() createField) {
  test('should be able to modify enabled', () {
    final field = createField();
    expect(field.enabled, true);
    field.enabled = false;
    expect(field.enabled, false);
    field.enabled = true;
    expect(field.enabled, true);
  });
}
