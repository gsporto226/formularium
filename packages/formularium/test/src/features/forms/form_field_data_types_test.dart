import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_data_types/form_field_validation.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_utils.dart';

void main() {
  final context = MockContext();

  group('FormFieldStatus', () {
    group('Valid', () {
      test('should create Valid with transformed and validation', () {
        const valid = Valid<String>(transformed: 'result');
        expect(valid.transformed, 'result');
        expect(valid.validation, isNull);
        expect(valid.pending, false);
        expect(valid.validating, false);
      });

      test('should create Valid with validation', () {
        const valid = Valid<String>(
          transformed: 'result',
          validation: ValidationBundle(type: 'warning', validation: TestValidation.reason),
        );
        expect(valid.transformed, 'result');
        expect(valid.validation?.validation, TestValidation.reason);
      });

      test('equality', () {
        const a = Valid<String>(transformed: 'x');
        const b = Valid<String>(transformed: 'x');
        const c = Valid<String>(transformed: 'y');
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });

      test('hashCode', () {
        const a = Valid<String>(transformed: 'x');
        const b = Valid<String>(transformed: 'x');
        expect(a.hashCode, equals(b.hashCode));
      });
    });

    group('Invalid', () {
      test('should create Invalid with validation', () {
        const invalid = Invalid<String?>(
          transformed: null,
          validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
        );
        expect(invalid.validation.validation, TestValidation.reason);
        expect(invalid.transformed, isNull);
        expect(invalid.pending, false);
        expect(invalid.validating, false);
      });

      test('equality', () {
        const a = Invalid<String?>(
          transformed: null,
          validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
        );
        const b = Invalid<String?>(
          transformed: null,
          validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
        );
        const c = Invalid<String?>(
          transformed: null,
          validation: ValidationBundle(type: 'error', validation: TestValidation.other),
        );
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });

      test('hashCode', () {
        const a = Invalid<String?>(
          transformed: null,
          validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
        );
        const b = Invalid<String?>(
          transformed: null,
          validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
        );
        expect(a.hashCode, equals(b.hashCode));
      });
    });

    group('Pending', () {
      test('should create Pending', () {
        const pending = Pending<String>();
        expect(pending.validation, isNull);
        expect(pending.transformed, isNull);
        expect(pending.pending, true);
        expect(pending.validating, false);
      });

      test('equality', () {
        const a = Pending<String>();
        const b = Pending<String>();
        const c = Pending<int>();
        expect(a, equals(b));
        expect(a, equals(c));
      });

      test('hashCode', () {
        const a = Pending<String>();
        const b = Pending<String>();
        expect(a.hashCode, equals(b.hashCode));
      });
    });

    group('map()', () {
      test('should map Valid', () {
        const status = Valid<String>(transformed: 'result');
        final mapped = status.map(
          valid: (v) => 'valid: ${v.transformed}',
          invalid: (i) => 'invalid: ${i.validation}',
          pending: (p) => 'pending',
          validating: (v) => 'validating',
        );
        expect(mapped, 'valid: result');
      });

      test('should map Valid with warning', () {
        const status = Valid<String>(
          transformed: 'result',
          validation: ValidationBundle(type: 'warning', validation: TestValidation.reason),
        );
        final mapped = status.map(
          valid: (v) => 'warn: ${v.validation?.validation}',
          invalid: (i) => 'invalid',
          pending: (p) => 'pending',
          validating: (v) => 'validating',
        );
        expect(mapped, contains('reason'));
      });

      test('should map Invalid with null transformed', () {
        const status = Invalid<String?>(
          transformed: null,
          validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
        );
        final mapped = status.map(
          valid: (v) => 'valid: ${v.transformed}',
          invalid: (i) => 'invalid: ${i.validation.validation.localize(context)}',
          pending: (p) => 'pending',
          validating: (v) => 'validating',
        );
        expect(mapped, 'invalid: reason');
      });

      test('should map Invalid with value transformed', () {
        const status = Invalid<String>(
          transformed: 'val',
          validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
        );
        final mapped = status.map(
          valid: (v) => 'valid: ${v.transformed}',
          invalid: (i) => 'invalid: ${i.validation.validation.localize(context)}',
          pending: (p) => 'pending',
          validating: (v) => 'validating',
        );
        expect(mapped, 'invalid: reason');
      });

      test('should map Pending', () {
        const status = Pending<String>();
        final mapped = status.map(
          valid: (v) => 'valid: ${v.transformed}',
          invalid: (i) => 'invalid: ${i.validation}',
          pending: (p) => 'pending',
          validating: (v) => 'validating',
        );
        expect(mapped, 'pending');
      });

      test('should map Validating', () {
        const status = Validating<String>();
        final mapped = status.map(
          valid: (v) => 'valid',
          invalid: (i) => 'invalid',
          pending: (p) => 'pending',
          validating: (v) => 'validating',
        );
        expect(mapped, 'validating');
      });
    });

    group('Validating', () {
      test('should create Validating', () {
        const validating = Validating<String>();
        expect(validating.validation, isNull);
        expect(validating.transformed, isNull);
        expect(validating.pending, false);
        expect(validating.validating, true);
      });

      test('equality', () {
        const a = Validating<String>();
        const b = Validating<String>();
        expect(a, equals(b));
      });

      test('hashCode', () {
        const a = Validating<String>();
        const b = Validating<String>();
        expect(a.hashCode, equals(b.hashCode));
      });
    });
  });

  group('FormFieldValidation', () {
    group('Warning', () {
      test('should create Warning with validation and transformed', () {
        final warning = FormFieldValidation.warning<String, String>(
          validation: TestValidation.reason,
          transformed: 'value',
        );
        expect(warning, isA<Warning<String, String>>());
        expect((warning as Warning).validation, TestValidation.reason);
        expect(warning.transformed, 'value');
      });

      test('cast should preserve Warning type', () {
        final warning = FormFieldValidation.warning<String, String>(
          validation: TestValidation.reason,
          transformed: 'value',
        );
        final casted = warning.cast<String>();
        expect(casted, isA<Warning<String, String>>());
      });

      test('mapTransformed should transform the transformed value', () {
        final warning = FormFieldValidation.warning<String, String>(
          validation: TestValidation.reason,
          transformed: 'hello',
        );
        final mapped = warning.mapTransformed<String>((v) => '${v}_world');
        expect(mapped, isA<Warning<String, String>>());
        expect((mapped as Warning).transformed, 'hello_world');
      });
    });

    group('Error', () {
      test('should create Error with validation', () {
        final error = FormFieldValidation.error<String, String>(TestValidation.reason);
        expect(error, isA<Error<String, String>>());
        expect((error as Error).validation, TestValidation.reason);
      });

      test('cast should preserve Error type', () {
        final error = FormFieldValidation.error<String, String>(TestValidation.reason);
        final casted = error.cast<String>();
        expect(casted, isA<Error<String, String>>());
      });
    });
  });
}
