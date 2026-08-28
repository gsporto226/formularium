import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';
import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_implementations/raw_formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import '../../helpers/test_utils.dart';

void main() {
  RawFormulariumFormField<String, Transformed> builder<Transformed>({
    required FormFieldValidatorBundle<String, Transformed> validator,
    String? initialValue,
    bool? enabled,
  }) => RawFormulariumFormField(
    validator: validator,
    enabled: enabled ?? true,
    initialValue: initialValue ?? '',
  );

  group('RawFormulariumFormField', () {
    testFieldEnabledToggle(
      () => builder<String>(
        enabled: true,
        validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
      ),
    );

    group('state', () {
      test(
        'should initialize with pure state',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
          );
          expect(field.state, FormFieldState.pure);
        },
      );

      test(
        'changing value should change state to dirty',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
          );
          expect(field.state, FormFieldState.pure);
          field.value = 'a';
          expect(field.state, FormFieldState.dirty);
          field.value = 'b';
          expect(field.state, FormFieldState.dirty);
        },
      );

      test(
        'valueRaw should not change state',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
          );
          expect(field.state, FormFieldState.pure);
          field.valueRaw('new value');
          expect(field.state, FormFieldState.pure);
        },
      );

      test(
        'reset should restore state to pure',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
            initialValue: 'initial',
          );
          expect((field..value = 'modified').state, FormFieldState.dirty);
          expect((field..reset()).state, FormFieldState.pure);
        },
      );
    });

    group('status', () {
      test('should initialize with pending status', () {
        final field = builder<String>(
          enabled: true,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
        );
        expect(field.status, isA<Pending<String>>());
      });

      test(
        'should not change status until validate() is called',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
          );
          expect(field.status, isA<Pending<String>>());
          field.value = 'a';
          expect(field.status, isA<Pending<String>>());
          expect(field.validate(), isA<Valid<String>>());
        },
      );

      test(
        'when validate is called, should return new status synchronously - valid',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
            initialValue: 'value',
          );
          expect(field.status, isA<Pending<String>>());
          expect(
            field.validate(),
            const Valid<String>(transformed: 'value'),
          );
          expect(
            field.status,
            const Valid<String>(transformed: 'value'),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously - valid warning',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.warning(
              (v) => Validation(transformed: v, validation: TestValidation.reason),
            ),
            initialValue: 'value',
          );
          expect(field.status, isA<Pending<String>>());
          expect(
            field.validate(),
            const Valid<String>(
              transformed: 'value',
              validation: ValidationBundle(type: 'warning', validation: TestValidation.reason),
            ),
          );
          expect(
            field.status,
            const Valid<String>(
              transformed: 'value',
              validation: ValidationBundle(type: 'warning', validation: TestValidation.reason),
            ),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously - invalid error',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: TestValidation.reason),
            ),
            initialValue: 'value',
          );
          expect(field.status, isA<Pending<String>>());
          expect(
            field.validate(),
            const Invalid<String>(
              transformed: 'value',
              validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
            ),
          );
          expect(
            field.status,
            const Invalid<String>(
              transformed: 'value',
              validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
            ),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously with transformed values - valid',
        () {
          final field = builder<int>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error<String, int>(
              (v) => Validation(transformed: 3, validation: null),
            ),
            initialValue: 'value',
          );
          expect(field.status, isA<Pending<int>>());
          expect(
            field.validate(),
            const Valid<int>(transformed: 3),
          );
          expect(
            field.status,
            const Valid<int>(transformed: 3),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously with transformed values - valid warning',
        () {
          final field = builder<int>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.warning<String, int>(
              (v) => Validation(transformed: 3, validation: TestValidation.reason),
            ),
            initialValue: 'value',
          );
          expect(field.status, isA<Pending<int>>());
          expect(
            field.validate(),
            const Valid<int>(
              transformed: 3,
              validation: ValidationBundle(type: 'warning', validation: TestValidation.reason),
            ),
          );
          expect(
            field.status,
            const Valid<int>(
              transformed: 3,
              validation: ValidationBundle(type: 'warning', validation: TestValidation.reason),
            ),
          );
        },
      );

      test(
        'valueRaw should reset status to Pending without validating',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
            initialValue: 'initial',
          );
          expect((field..validate()).status, isA<Valid<String>>());

          expect((field..valueRaw('silent update')).status, isA<Pending<String>>());
        },
      );

      test(
        'setting value after validate should reset status to Pending',
        () {
          final field = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
            initialValue: 'initial',
          );
          expect((field..validate()).status, isA<Valid<String>>());

          expect((field..value = 'new value').status, isA<Pending<String>>());
        },
      );
    });

    group(r'$enabled listenable', () {
      test('should notify listeners when enabled changes', () {
        final field = builder<String>(
          enabled: true,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
        );
        bool? notifiedValue;
        field.$enabled.addListener(() {
          notifiedValue = field.$enabled.value;
        });
        field.enabled = false;
        expect(notifiedValue, false);
        field.enabled = true;
        expect(notifiedValue, true);
      });
    });

    group('dispose', () {
      test('dispose should not throw', () {
        final field = builder<String>(
          enabled: true,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
        );
        expect(field.dispose, returnsNormally);
      });
    });
  });
}
