import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';
import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('CategorizedFormFieldValidators', () {
    group('error', () {
      test('should wrap a valid uncategorized result into ValidationDone', () {
        final bundle = CategorizedFormFieldValidators.instance.error<String, String>(
          (v) => Validation(transformed: '${v}_ok', validation: null),
        );
        final validator = FormFieldValidator<String, String>(
          fn: bundle.validator,
          type: bundle.type,
          invalidates: bundle.invalidates,
        );
        final result = (validator..value('input')).result;
        expect(result, isA<ValidationDone<String>>());
        expect((result as ValidationDone).transformed, 'input_ok');
        expect((result as ValidationDone).validation, isNull);
      });

      test('should wrap a failure uncategorized result into ValidationDone with error', () {
        final bundle = CategorizedFormFieldValidators.instance.error<String, String>(
          (_) => Validation(transformed: 'fail', validation: TestValidation.reason),
        );
        final validator = FormFieldValidator<String, String>(
          fn: bundle.validator,
          type: bundle.type,
          invalidates: bundle.invalidates,
        );
        final result = (validator..value('input')).result;
        expect(result, isA<ValidationDone<String>>());
        expect((result as ValidationDone).transformed, 'fail');
        expect((result as ValidationDone).validation, isA<ValidationBundle>());
        expect((result as ValidationDone).validation!.validation, TestValidation.reason);
      });
    });

    group('warning', () {
      test('should wrap a valid uncategorized result into ValidationDone without bundle', () {
        final bundle = CategorizedFormFieldValidators.instance.warning<String, String>(
          (v) => Validation(transformed: '${v}_ok', validation: null),
        );
        final validator = FormFieldValidator<String, String>(
          fn: bundle.validator,
          type: bundle.type,
          invalidates: bundle.invalidates,
        );
        final result = (validator..value('input')).result;
        expect(result, isA<ValidationDone<String>>());
        expect((result as ValidationDone).transformed, 'input_ok');
        expect((result as ValidationDone).validation, isNull);
      });

      test('should wrap a failure uncategorized result into ValidationDone with warning', () {
        final bundle = CategorizedFormFieldValidators.instance.warning<String, String>(
          (_) => Validation(transformed: 'with_warning', validation: TestValidation.reason),
        );
        final validator = FormFieldValidator<String, String>(
          fn: bundle.validator,
          type: bundle.type,
          invalidates: bundle.invalidates,
        );
        final result = (validator..value('input')).result;
        expect(result, isA<ValidationDone<String>>());
        expect((result as ValidationDone).transformed, 'with_warning');
        expect((result as ValidationDone).validation, isA<ValidationBundle>());
        expect((result as ValidationDone).validation!.type, 'warning');
        expect((result as ValidationDone).validation!.validation, TestValidation.reason);
      });
    });
  });

  group('CategorizeFormFieldValidator extension', () {
    test('error() should wrap into categorized error validator', () {
      final IUncategorizedFormFieldValidator<String, String> uncategorized = (v) =>
          Validation(transformed: '${v}_ok', validation: null);
      final bundle = uncategorized.error();
      final validator = FormFieldValidator<String, String>(
        fn: bundle.validator,
        type: bundle.type,
        invalidates: bundle.invalidates,
      );
      final result = (validator..value('input')).result;
      expect(result, isA<ValidationDone<String>>());
      expect((result as ValidationDone).transformed, 'input_ok');
    });

    test('warning() should wrap into categorized warning validator', () {
      final IUncategorizedFormFieldValidator<String, String> uncategorized = (v) =>
          Validation(transformed: 'warn_val', validation: TestValidation.reason);
      final bundle = uncategorized.warning();
      final validator = FormFieldValidator<String, String>(
        fn: bundle.validator,
        type: bundle.type,
        invalidates: bundle.invalidates,
      );
      final result = (validator..value('input')).result;
      expect(result, isA<ValidationDone<String>>());
      expect((result as ValidationDone).transformed, 'warn_val');
      expect((result as ValidationDone).validation!.validation, TestValidation.reason);
    });
  });
}
