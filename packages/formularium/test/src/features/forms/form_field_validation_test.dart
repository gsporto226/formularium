import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_validation.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('FormFieldValidation', () {
    group('cast()', () {
      test('Warning cast should preserve Warning type', () {
        final warning = FormFieldValidation.warning<String, String>(
          validation: TestValidation.reason,
          transformed: 'value',
        );
        final casted = warning.cast<String>();
        expect(casted, isA<Warning<String, String>>());
      });

      test('Warning cast should work when mapped', () {
        final warning = FormFieldValidation.warning<String, String>(
          validation: TestValidation.reason,
          transformed: 'value',
        );
        final mapped = warning.mapTransformed<String>((v) => '${v}_mapped');
        expect(mapped, isA<Warning<String, String>>());
        expect((mapped as Warning).transformed, 'value_mapped');
      });

      test('Error cast should preserve Error type', () {
        final error = FormFieldValidation.error<String, String>(TestValidation.reason);
        final casted = error.cast<String>();
        expect(casted, isA<Error<String, String>>());
      });

      test('Error mapTransformed should keep Error type', () {
        final error = FormFieldValidation.error<String, String>(TestValidation.reason);
        final mapped = error.mapTransformed<String>((v) => '${v}_mapped');
        expect(mapped, isA<Error<String, String>>());
        // Error doesn't have transformed - it should still be Error
        expect((mapped as Error).validation, TestValidation.reason);
      });
    });
  });
}
