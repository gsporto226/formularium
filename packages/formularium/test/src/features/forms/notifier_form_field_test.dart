import 'package:flutter/cupertino.dart' hide FormFieldState, FormFieldValidator;
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';
import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_implementations/notifier_form_field.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import '../../helpers/test_utils.dart';

void main() {
  // ignore: no_leading_underscores_for_local_identifiers - mixed types in collection
  final _fields = <NotifierFormulariumField<dynamic, dynamic>>[];
  // ignore: no_leading_underscores_for_local_identifiers - mixed types in collection
  final _controllers = <ValueNotifier<dynamic>>[];

  tearDown(() {
    for (final field in _fields) {
      field.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    _fields.clear();
    _controllers.clear();
  });

  ({
    ValueNotifier<String> controller,
    NotifierFormulariumField<String, Transformed> field,
  })
  builder<Transformed>({
    required FormFieldValidatorBundle<String, Transformed> validator,
    String? initialValue,
    bool? enabled,
  }) {
    final controller = ValueNotifier<String>(initialValue ?? '');

    final field = NotifierFormulariumField(
      validator: validator,
      enabled: enabled ?? true,
      controller: controller,
      autovalidateMode: AutovalidateMode.disabled,
      focusNode: null,
    );
    _fields.add(field);
    _controllers.add(controller);
    return (
      field: field,
      controller: controller,
    );
  }

  group('NotifierFormulariumField', () {
    testFieldEnabledToggle(() {
      final (:field, :controller) = builder<String>(
        enabled: true,
        validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
      );
      return field;
    });

    group('state', () {
      test(
        'should initialize with pure state',
        () {
          final (:field, :controller) = builder<String>(
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
          final (:field, :controller) = builder<String>(
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

      group('status', () {
        test('should initialize with pending status', () {
          final (:field, :controller) = builder<String>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
          );
          expect(field.status, isA<Pending<String>>());
        });

        test(
          'should not change status until validate() is called',
          () {
            final (:field, :controller) = builder<String>(
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
      });

      test(
        'when validate is called, should return new status synchronously and emit later - valid',
        () {
          final (:field, :controller) = builder<String>(
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
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later - valid warning',
        () {
          final (:field, :controller) = builder<String>(
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
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later - invalid error',
        () {
          final (:field, :controller) = builder<String>(
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
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later with transformed values - valid',
        () {
          final (:field, :controller) = builder<int>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.error<String, int>(
              (_) => Validation(transformed: 3, validation: null),
            ),
            initialValue: 'value',
          );
          expect(field.status, isA<Pending<int>>());
          expect(
            field.validate(),
            const Valid<int>(transformed: 3),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later with transformed values - valid warning',
        () {
          final (:field, :controller) = builder<int>(
            enabled: true,
            validator: CategorizedFormFieldValidators.instance.warning<String, int>(
              (_) => Validation(transformed: 3, validation: TestValidation.reason),
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
        },
      );
    });

    group('bidirectional sync', () {
      test('controller value change triggers field validate returns correct value', () {
        final (:field, :controller) = builder<String>(
          enabled: true,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          initialValue: 'initial',
        );
        controller.value = 'updated';
        expect(field.validate(), const Valid<String>(transformed: 'updated'));
      });

      test('field value change propagates to controller', () {
        final (:field, :controller) = builder<String>(
          enabled: true,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          initialValue: 'initial',
        );
        field.value = 'field_update';
        expect(controller.value, 'field_update');
      });

      test('field value change triggers controller listener', () {
        final (:field, :controller) = builder<String>(
          enabled: true,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          initialValue: 'initial',
        );
        String? captured;
        controller.addListener(() {
          captured = controller.value;
        });
        field.value = 'new_val';
        expect(captured, 'new_val');
      });

      test('controller value change triggers field value update visible on validate', () {
        final (:field, :controller) = builder<String>(
          enabled: true,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          initialValue: 'initial',
        );
        controller.value = 'via_controller';
        expect(
          field.validate(),
          const Valid<String>(transformed: 'via_controller'),
        );
      });
    });

    group('autovalidateMode.always', () {
      test('should auto-validate on create', () {
        final controller = ValueNotifier<String>('initial');
        _controllers.add(controller);
        final field = NotifierFormulariumField<String, String>(
          controller: controller,
          autovalidateMode: AutovalidateMode.always,
          focusNode: null,
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => Validation(transformed: v, validation: null),
          ),
        );
        _fields.add(field);
        expect(field.status, isA<Valid<String>>());
        expect(
          (field.status as Valid<String>).transformed,
          'initial',
        );
      });
    });

    group('reset', () {
      test('reset restores controller value and state to pure', () {
        final controller = ValueNotifier<String>('initial');
        _controllers.add(controller);
        final field = NotifierFormulariumField<String, String>(
          controller: controller,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: null,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
        );
        _fields.add(field);
        field.value = 'modified';
        expect(controller.value, 'modified');
        expect(field.state, FormFieldState.dirty);

        field.reset();
        expect(controller.value, 'initial');
        expect(field.state, FormFieldState.pure);
      });

      test('reset reattaches listener after restoring value', () {
        final controller = ValueNotifier<String>('initial');
        _controllers.add(controller);
        final field = NotifierFormulariumField<String, String>(
          controller: controller,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: null,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
        );
        _fields.add(field);
        field.reset();

        controller.value = 'after_reset';
        expect(
          field.validate(),
          const Valid<String>(transformed: 'after_reset'),
        );
      });
    });

    group('dispose', () {
      test('dispose removes listener from controller', () {
        final controller = ValueNotifier<String>('initial');
        _controllers.add(controller);
        NotifierFormulariumField<String, String>(
          controller: controller,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: null,
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
        ).dispose();
        // ignore: invalid_use_of_protected_member — ValueNotifier inherits from ChangeNotifier
        expect(controller.hasListeners, false);
      });
    });
  });
}
