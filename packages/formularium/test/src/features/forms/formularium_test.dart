import 'dart:async';

import 'package:flutter/cupertino.dart' hide FormFieldState, FormFieldValidator;
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';
import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/notifier_form_field.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/forms/_utils/form_field_validators.dart';
import '../../helpers/test_utils.dart';

void main() {
  (
    Formularium<int>,
    FormulariumFormField<String, String>,
    FormulariumFormField<String, String>,
  )
  builder<Transformed>({
    FormFieldValidatorBundle<String, String>? validatorFirst,
    FormFieldValidatorBundle<String, String>? validatorSecond,
    bool? enabled,
    bool? enabledFirst,
    bool? enabledSecond,
  }) {
    final first = FormulariumFormField(
      initialValue: 'first',
      validator: validatorFirst ?? FormFieldValidators.instance.identityValidator<String>().error(),
      enabled: enabledFirst ?? true,
      autovalidateMode: AutovalidateMode.disabled,
      focusNode: null,
    );
    final second = FormulariumFormField(
      initialValue: 'second',
      validator: validatorSecond ?? FormFieldValidators.instance.identityValidator<String>().error(),
      enabled: enabledSecond ?? true,
      autovalidateMode: AutovalidateMode.disabled,
      focusNode: null,
    );

    final formularium = Formularium.form2(
      first: first,
      second: second,
      valueCombiner: (String first, String second) => first.length + second.length,
    );
    return (formularium, first, second);
  }

  group('FormulariumFormField', () {
    group('enabled', () {
      testFieldEnabledToggle(() {
        final (field, _, _) = builder<String>(enabled: true);
        return field;
      });

      test(
        'form enabled can be toggled independently of field enabled',
        () {
          final (form, first, second) = builder<String>(enabled: true);
          expect(first.enabled, true);
          expect(second.enabled, true);
          form.enabled = false;
          expect(form.enabled, false);
          expect(first.enabled, true);
          expect(second.enabled, true);
          form.enabled = true;
          expect(form.enabled, true);
          expect(first.enabled, true);
          expect(second.enabled, true);
        },
      );

      test(
        'field level enabled is preserved independently of form enabled',
        () {
          final (form, first, second) = builder<String>(enabled: true, enabledFirst: false);
          expect(form.enabled, true);
          expect(first.enabled, false);
          expect(second.enabled, true);
          form.enabled = false;
          expect(first.enabled, false);
          expect(second.enabled, true);
          form.enabled = true;
          expect(first.enabled, false);
          expect(second.enabled, true);
          second.enabled = false;
          expect(second.enabled, false);
          first.enabled = true;
          expect(first.enabled, true);
        },
      );
    });

    group('state', () {
      test(
        'should initialize with pure state',
        () {
          final (field, first, second) = builder<String>(enabled: true);
          expect(field.state, FormFieldState.pure);
        },
      );

      group('when any field value changes, state should change to dirty', () {
        test(
          'first field',
          () {
            final (field, first, second) = builder<String>(enabled: true);
            expect(field.state, FormFieldState.pure);
            first.value = 'a';
            expect(field.state, FormFieldState.dirty);
            first.value = 'b';
            expect(field.state, FormFieldState.dirty);
          },
        );
        test(
          'second field',
          () {
            final (field, first, second) = builder<String>(enabled: true);
            expect(field.state, FormFieldState.pure);
            second.value = 'a';
            expect(field.state, FormFieldState.dirty);
            second.value = 'b';
            expect(field.state, FormFieldState.dirty);
          },
        );
      });
    });

    group('status', () {
      test('should initialize with pending status', () {
        final (field, first, second) = builder<String>(
          enabled: true,
          validatorFirst: CategorizedFormFieldValidators.instance.error(
            (v) => Validation(transformed: v, validation: null),
          ),
        );
        expect(field.status, isA<Pending<int>>());
      });

      test(
        'should not change status until validate() is called',
        () {
          final (field, first, second) = builder<String>(
            enabled: true,
            validatorFirst: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
          );
          expect(field.status, isA<Pending<int>>());
          first.value = 'a';
          expect(field.status, isA<Pending<int>>());
          expect(field.validate(), isA<Valid<int>>());
        },
      );

      test(
        'when validate is called without a validator, should always return valid',
        () {
          final (field, first, second) = builder<String>(enabled: true);
          expect(field.status, isA<Pending<int>>());
          first.value = 'a';
          expect(field.status, isA<Pending<int>>());
          expect(field.validate(), const Valid<int>(transformed: 7));
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later - valid',
        () {
          final (field, first, second) = builder<String>(
            enabled: true,
            validatorFirst: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: null),
            ),
          );
          expect(field.status, isA<Pending<int>>());
          expect(
            field.validate(),
            const Valid<int>(transformed: 11),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later - valid warning',
        () {
          final (field, first, second) = builder<String>(
            enabled: true,
            validatorFirst: CategorizedFormFieldValidators.instance.warning(
              (v) => Validation(transformed: v, validation: TestValidation.reason),
            ),
          );
          expect(field.status, isA<Pending<int>>());
          expect(
            field.validate(),
            const Valid<int>(
              transformed: 11,
              validation: ValidationBundle(type: 'warning', validation: TestValidation.reason),
            ),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later - invalid error',
        () {
          final (field, first, second) = builder<String>(
            enabled: true,
            validatorFirst: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: TestValidation.reason),
            ),
          );
          expect(field.status, isA<Pending<int>>());
          expect(
            field.validate(),
            const Invalid<int>(
              transformed: 11,
              validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
            ),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later with transformed values - valid',
        () {
          final (field, first, second) = builder<int>(
            enabled: true,
            validatorFirst: CategorizedFormFieldValidators.instance.error<String, String>(
              (_) => Validation(transformed: 'ab', validation: null),
            ),
          );
          expect(field.status, isA<Pending<int>>());
          expect(
            field.validate(),
            const Valid<int>(transformed: 8),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later with transformed values - valid warning',
        () {
          final (field, first, second) = builder<int>(
            enabled: true,
            validatorFirst: CategorizedFormFieldValidators.instance.warning<String, String>(
              (_) => Validation(transformed: 'ab', validation: TestValidation.reason),
            ),
          );
          expect(field.status, isA<Pending<int>>());
          expect(
            field.validate(),
            const Valid<int>(
              transformed: 8,
              validation: ValidationBundle(type: 'warning', validation: TestValidation.reason),
            ),
          );
        },
      );

      test(
        'when validate is called, should return new status synchronously and emit later with transformed values - invalid',
        () {
          final (field, first, second) = builder<int>(
            enabled: true,
            validatorFirst: CategorizedFormFieldValidators.instance.error<String, String>(
              (_) => Validation(transformed: 'ab', validation: TestValidation.reason),
            ),
          );
          expect(field.status, isA<Pending<int>>());
          expect(
            field.validate(),
            const Invalid<int>(
              transformed: 8,
              validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
            ),
          );
        },
      );
    });

    group('status with autovalidateMode.always', () {
      (
        Formularium<int>,
        FormulariumFormField<String, String>,
        FormulariumFormField<String, String>,
      )
      builderAlways({
        FormFieldValidatorBundle<String, String>? validatorFirst,
        FormFieldValidatorBundle<String, String>? validatorSecond,
        bool? enabled,
        bool? enabledFirst,
        bool? enabledSecond,
      }) {
        final first = FormulariumFormField(
          initialValue: 'first',
          validator: validatorFirst ?? FormFieldValidators.instance.identityValidator<String>().error(),
          enabled: enabledFirst ?? true,
          autovalidateMode: AutovalidateMode.always,
          focusNode: null,
        );
        final second = FormulariumFormField(
          initialValue: 'second',
          validator: validatorSecond ?? FormFieldValidators.instance.identityValidator<String>().error(),
          enabled: enabledSecond ?? true,
          autovalidateMode: AutovalidateMode.always,
          focusNode: null,
        );

        final formularium = Formularium.form2(
          first: first,
          second: second,
          valueCombiner: (String first, String second) => first.length + second.length,
        );
        return (formularium, first, second);
      }

      test(
        'should initialize with Valid status (not Pending) when all fields are valid',
        () {
          final (field, _, _) = builderAlways();
          expect(field.status, isA<Valid<int>>());
        },
      );

      test(
        'should initialize with Invalid status when any field is invalid',
        () {
          final (field, _, _) = builderAlways(
            validatorFirst: CategorizedFormFieldValidators.instance.error(
              (v) => Validation(transformed: v, validation: TestValidation.reason),
            ),
          );
          expect(field.status, isA<Invalid<int>>());
          expect(
            (field.status as Invalid<int>).validation,
            const ValidationBundle(type: 'error', validation: TestValidation.reason),
          );
        },
      );

      test(
        'should re-validate when modifying a field value',
        () {
          final (field, first, _) = builderAlways();
          expect(field.status, isA<Valid<int>>());
          first.value = 'modified first';
          expect(field.status, isA<Valid<int>>());
        },
      );

      test(
        'should correct status when modifying a previously invalid field',
        () {
          final (field, first, _) = builderAlways(
            validatorFirst: CategorizedFormFieldValidators.instance.error(
              (v) => v == 'bad'
                  ? Validation(transformed: v, validation: TestValidation.reason)
                  : Validation(transformed: v, validation: null),
            ),
          );
          first
            ..valueRaw('bad')
            ..validate();
          expect(field.status, isA<Invalid<int>>());
          first.value = 'fixed';
          expect(field.status, isA<Valid<int>>());
        },
      );

      group('async', () {
        test(
          'should initialize with Validating status and then Valid when async completes',
          () async {
            final completer = Completer<Validation<String>>();
            final first = FormulariumFormField(
              initialValue: 'first',
              validator: CategorizedFormFieldValidators.instance.error(
                (_) => completer.future,
              ),
              enabled: true,
              autovalidateMode: AutovalidateMode.always,
              focusNode: null,
            );
            final second = FormulariumFormField(
              initialValue: 'second',
              validator: FormFieldValidators.instance.identityValidator<String>().error(),
              enabled: true,
              autovalidateMode: AutovalidateMode.always,
              focusNode: null,
            );
            final formularium = Formularium.form2(
              first: first,
              second: second,
              valueCombiner: (String a, String b) => a.length + b.length,
            );

            expect(formularium.status, isA<Validating<int>>());

            final done = Completer<void>();
            formularium.$status.addListener(() {
              if (!done.isCompleted) done.complete();
            });
            completer.complete(Validation(transformed: 'async_result', validation: null));
            await done.future;

            expect(formularium.status, isA<Valid<int>>());
            expect(
              (formularium.status as Valid<int>).transformed,
              18,
            );
          },
        );

        test(
          'should ignore stale previous generation result',
          () async {
            final staleCompleter = Completer<Validation<String>>();
            final currentCompleter = Completer<Validation<String>>();
            final first = FormulariumFormField(
              initialValue: 'first',
              validator: CategorizedFormFieldValidators.instance.error(
                (_) {
                  if (!staleCompleter.isCompleted) {
                    return staleCompleter.future;
                  }
                  return currentCompleter.future;
                },
              ),
              enabled: true,
              autovalidateMode: AutovalidateMode.always,
              focusNode: null,
            );
            final second = FormulariumFormField(
              initialValue: 'second',
              validator: FormFieldValidators.instance.identityValidator<String>().error(),
              enabled: true,
              autovalidateMode: AutovalidateMode.always,
              focusNode: null,
            );
            final formularium = Formularium.form2(
              first: first,
              second: second,
              valueCombiner: (String a, String b) => a.length + b.length,
            );

            expect(formularium.status, isA<Validating<int>>());

            staleCompleter.complete(Validation(transformed: 'stale', validation: null));

            first.value = 'new first';
            expect(formularium.status, isA<Validating<int>>());

            // Wait for the stale microtask to be processed (it will be ignored)
            await null;
            expect(formularium.status, isA<Validating<int>>());

            final done = Completer<void>();
            formularium.$status.addListener(() {
              if (!done.isCompleted) done.complete();
            });
            currentCompleter.complete(Validation(transformed: 'current', validation: null));
            await done.future;

            expect(formularium.status, isA<Valid<int>>());
            expect(
              (formularium.status as Valid<int>).transformed,
              13,
            );
          },
        );
      });
    });

    test(
      'NotifierFormulariumField inside form3 combines and propagates value changes',
      () {
        final date1 = DateTime(2024);
        final date2 = DateTime(2024, 1, 2);

        final notifier = ValueNotifier('value');
        final notifier2 = ValueNotifier(1);
        final notifier3 = ValueNotifier(date1);

        final notifierFormField = NotifierFormulariumField<String, String>(
          controller: notifier,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: null,
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => Validation(transformed: v, validation: null),
          ),
        );

        final notifier2FormField = NotifierFormulariumField<int, int>(
          controller: notifier2,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: null,
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => Validation(transformed: v, validation: null),
          ),
        );

        final notifier3FormField = NotifierFormulariumField<DateTime, DateTime>(
          controller: notifier3,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: null,
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => Validation(transformed: v, validation: null),
          ),
        );

        final formularium = Formularium.form3(
          first: notifierFormField,
          second: notifier2FormField,
          third: notifier3FormField,
          valueCombiner: (first, second, third) => third,
        );

        expect(
          formularium.validate(),
          Valid<DateTime>(transformed: date1),
        );

        notifier3.value = date2;

        expect(
          notifier3FormField.validate(),
          Valid<DateTime>(transformed: date2),
        );

        expect(
          formularium.validate(),
          Valid<DateTime>(transformed: date2),
        );
      },
    );
  });
}
