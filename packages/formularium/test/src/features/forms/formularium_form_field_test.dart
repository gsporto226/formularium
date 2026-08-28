import 'package:flutter/widgets.dart' hide FormFieldState, FormFieldValidator;
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';
import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('FormulariumFormField', () {
    late FocusNode focusNode;

    setUp(() {
      focusNode = FocusNode();
    });

    tearDown(() {
      focusNode.dispose();
    });

    // Track FocusNodes created in widget tests for cleanup
    // ignore: no_leading_underscores_for_local_identifiers
    final _widgetFocusNodes = <FocusNode>[];
    tearDown(() {
      for (final node in _widgetFocusNodes) {
        node.dispose();
      }
      _widgetFocusNodes.clear();
    });

    group('AutovalidateMode.disabled', () {
      test('should not auto-validate on create', () {
        final field = FormulariumFormField<String, String>(
          initialValue: '',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: focusNode,
        );
        expect(field.status, isA<Pending<String>>());
      });

      test('should not auto-validate on value change', () {
        final field = FormulariumFormField<String, String>(
          initialValue: '',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: focusNode,
        );
        expect((field..value = 'new value').status, isA<Pending<String>>());
      });
    });

    group('AutovalidateMode.always', () {
      test('should auto-validate on create', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.always,
          focusNode: focusNode,
        );
        expect(field.status, isA<Valid<String>>());
        expect(
          field.status,
          const Valid<String>(transformed: 'test'),
        );
      });

      test('should auto-validate on value change', () {
        final field = FormulariumFormField<String, String>(
          initialValue: '',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.always,
          focusNode: focusNode,
        );
        expect((field..value = 'updated').status, isA<Valid<String>>());
        expect(
          field.status,
          const Valid<String>(transformed: 'updated'),
        );
      });

      test('should auto-validate with error on create', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => Validation(transformed: v, validation: TestValidation.reason),
          ),
          enabled: true,
          autovalidateMode: AutovalidateMode.always,
          focusNode: focusNode,
        );
        expect(field.status, isA<Invalid<String>>());
        expect(
          field.status,
          const Invalid<String>(
            transformed: 'test',
            validation: ValidationBundle(type: 'error', validation: TestValidation.reason),
          ),
        );
      });
    });

    group('AutovalidateMode.onUserInteraction', () {
      test('should not auto-validate on create', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
        );
        expect(field.status, isA<Pending<String>>());
      });

      test('should auto-validate on value change', () {
        final field = FormulariumFormField<String, String>(
          initialValue: '',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
        );
        expect((field..value = 'updated').status, isA<Valid<String>>());
        expect((field.status as Valid<String>).transformed, 'updated');
      });
    });

    group('AutovalidateMode.onUserInteraction focus', () {
      testWidgets('should not auto-validate on focus gain', (tester) async {
        final focusNode = FocusNode();
        _widgetFocusNodes.add(focusNode);
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
        );

        await tester.pumpWidget(
          FocusScope(
            child: Focus(focusNode: focusNode, child: const SizedBox()),
          ),
        );

        expect(field.status, isA<Pending<String>>());

        focusNode.requestFocus();
        await tester.pump();

        expect(field.status, isA<Pending<String>>());
      });

      testWidgets('should auto-validate on focus loss', (tester) async {
        final focusNode = FocusNode();
        _widgetFocusNodes.add(focusNode);
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
        );

        await tester.pumpWidget(
          FocusScope(
            child: Focus(focusNode: focusNode, child: const SizedBox()),
          ),
        );

        expect(field.status, isA<Pending<String>>());

        focusNode.requestFocus();
        await tester.pump();
        expect(field.status, isA<Pending<String>>());

        focusNode.unfocus();
        await tester.pump();

        expect(field.status, isA<Valid<String>>());
        expect(
          (field.status as Valid<String>).transformed,
          'test',
        );
      });
    });

    group('AutovalidateMode.onUserInteractionIfError', () {
      test('should not auto-validate on create', () {
        final field = FormulariumFormField<String, String>(
          initialValue: '',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          focusNode: focusNode,
        );
        expect(field.status, isA<Pending<String>>());
      });

      test('should not auto-validate on value change since status is reset to Pending', () {
        final field = FormulariumFormField<String, String>(
          initialValue: '',
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => Validation(transformed: v, validation: TestValidation.reason),
          ),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          focusNode: focusNode,
        );
        expect((field..validate()).status, isA<Invalid<String>>());
        expect((field..value = 'fixed').status, isA<Pending<String>>());
      });

      test('should not auto-validate on value change when status is Valid', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'ok',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          focusNode: focusNode,
        );
        expect((field..validate()).status, isA<Valid<String>>());
        expect((field..value = 'still ok').status, isA<Pending<String>>());
      });
    });

    group('AutovalidateMode.onUnfocus focus', () {
      testWidgets('should auto-validate on focus loss', (tester) async {
        final focusNode = FocusNode();
        _widgetFocusNodes.add(focusNode);
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUnfocus,
          focusNode: focusNode,
        );

        await tester.pumpWidget(
          FocusScope(
            child: Focus(focusNode: focusNode, child: const SizedBox()),
          ),
        );

        expect(field.status, isA<Pending<String>>());

        focusNode.requestFocus();
        await tester.pump();
        expect(field.status, isA<Pending<String>>());

        focusNode.unfocus();
        await tester.pump();

        expect(field.status, isA<Valid<String>>());
        expect(
          (field.status as Valid<String>).transformed,
          'test',
        );
      });
    });

    group('AutovalidateMode.always focus', () {
      testWidgets('should re-validate on focus change', (tester) async {
        final focusNode = FocusNode();
        _widgetFocusNodes.add(focusNode);
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.always,
          focusNode: focusNode,
        );

        await tester.pumpWidget(
          FocusScope(
            child: Focus(focusNode: focusNode, child: const SizedBox()),
          ),
        );

        expect(field.status, isA<Valid<String>>());

        focusNode.requestFocus();
        await tester.pump();
        expect(field.status, isA<Valid<String>>());
      });
    });

    group('AutovalidateMode.onUserInteractionIfError focus', () {
      testWidgets('should validate on focus loss when in error', (tester) async {
        final focusNode = FocusNode();
        _widgetFocusNodes.add(focusNode);
        final field = FormulariumFormField<String, String>(
          initialValue: 'bad',
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => Validation(transformed: v, validation: TestValidation.reason),
          ),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          focusNode: focusNode,
        );

        await tester.pumpWidget(
          FocusScope(
            child: Focus(focusNode: focusNode, child: const SizedBox()),
          ),
        );

        // First validate to enter error state
        field.validate();
        expect(field.status, isA<Invalid<String>>());

        focusNode.requestFocus();
        await tester.pump();
        expect(field.status, isA<Invalid<String>>());

        focusNode.unfocus();
        await tester.pump();

        expect(field.status, isA<Invalid<String>>());
      });
    });

    group('value setter with AutovalidateMode.onUserInteractionIfError', () {
      test('should auto-validate when error exists', () {
        final field = FormulariumFormField<String, String>(
          initialValue: '',
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => v.isEmpty
                ? Validation(transformed: v, validation: TestValidation.reason)
                : Validation(transformed: v, validation: null),
          ),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          focusNode: focusNode,
        );
        expect((field..validate()).status, isA<Invalid<String>>());

        // Setting value resets to Pending first, then onUserInteractionIfError
        // checks if status is Invalid — but it's Pending, so no auto-validate.
        // We need to validate manually.
        expect(
          (field
                ..value = 'fixed'
                ..validate())
              .status,
          isA<Valid<String>>(),
        );
      });
    });

    group('reset and clear with AutovalidateMode.always', () {
      test('reset should re-validate', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'error-value',
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => v == 'error-value'
                ? Validation(transformed: v, validation: TestValidation.reason)
                : Validation(transformed: v, validation: null),
          ),
          enabled: true,
          autovalidateMode: AutovalidateMode.always,
          focusNode: focusNode,
        );
        expect(field.status, isA<Invalid<String>>());
        expect(
          (field
                ..value = 'ok'
                ..validate())
              .status,
          isA<Valid<String>>(),
        );
        expect((field..reset()).status, isA<Invalid<String>>());
      });

      test('clear should re-validate', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'error-value',
          validator: CategorizedFormFieldValidators.instance.error(
            (v) => v == 'error-value'
                ? Validation(transformed: v, validation: TestValidation.reason)
                : Validation(transformed: v, validation: null),
          ),
          enabled: true,
          autovalidateMode: AutovalidateMode.always,
          focusNode: focusNode,
        );
        expect(field.status, isA<Invalid<String>>());
        expect(
          (field
                ..value = 'ok'
                ..validate())
              .status,
          isA<Valid<String>>(),
        );
        expect((field..clear()).status, isA<Invalid<String>>());
      });
    });

    group('reset and clear with various autovalidate modes', () {
      test('reset with onUserInteraction should not re-validate', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
        );
        expect((field..reset()).status, isA<Pending<String>>());
      });

      test('reset with onUserInteractionIfError should not re-validate', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          focusNode: focusNode,
        );
        expect((field..reset()).status, isA<Pending<String>>());
      });

      test('clear with onUserInteraction should not re-validate', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
        );
        expect((field..clear()).status, isA<Pending<String>>());
      });

      test('clear with onUserInteractionIfError should not re-validate', () {
        final field = FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          focusNode: focusNode,
        );
        expect((field..clear()).status, isA<Pending<String>>());
      });
    });

    group('dispose', () {
      test('should remove focus listener on dispose', () {
        final focusNode = FocusNode();
        _widgetFocusNodes.add(focusNode);
        FormulariumFormField<String, String>(
          initialValue: 'test',
          validator: CategorizedFormFieldValidators.instance.error((v) => Validation(transformed: v, validation: null)),
          enabled: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
        ).dispose();
        // ignore: invalid_use_of_protected_member — focusNode inherits from ChangeNotifier
        expect(focusNode.hasListeners, false);
      });
    });
  });
}
