import 'package:flutter/widgets.dart' hide FormFieldState;
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_implementations/notifier_form_field.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';

void main() {
  group('NotifierFormulariumField - clear', () {
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

    test('clear should reset field state to pure', () {
      final controller = ValueNotifier<String>('initial');
      _controllers.add(controller);
      final field = NotifierFormulariumField<String, String>(
        controller: controller,
        autovalidateMode: AutovalidateMode.disabled,
        focusNode: null,
        validator: CategorizedFormFieldValidators.instance.error(
          (v) => Validation(transformed: v, validation: null),
        ),
      );
      _fields.add(field);
      field.value = 'modified';
      expect(field.state, FormFieldState.dirty);
      field.clear();
      expect(field.state, FormFieldState.pure);
    });

    test('clear should reset controller value to initial', () {
      final controller = ValueNotifier<String>('initial');
      _controllers.add(controller);
      final field = NotifierFormulariumField<String, String>(
        controller: controller,
        autovalidateMode: AutovalidateMode.disabled,
        focusNode: null,
        validator: CategorizedFormFieldValidators.instance.error(
          (v) => Validation(transformed: v, validation: null),
        ),
      );
      _fields.add(field);
      field.value = 'modified';
      expect(controller.value, 'modified');
      field.clear();
      expect(controller.value, 'initial');
    });

    test('clear reattaches listener', () {
      final controller = ValueNotifier<String>('initial');
      _controllers.add(controller);
      final field = NotifierFormulariumField<String, String>(
        controller: controller,
        autovalidateMode: AutovalidateMode.disabled,
        focusNode: null,
        validator: CategorizedFormFieldValidators.instance.error(
          (v) => Validation(transformed: v, validation: null),
        ),
      );
      _fields.add(field);
      field.clear();
      controller.value = 'after_clear';
      expect(
        field.validate(),
        const Valid<String>(transformed: 'after_clear'),
      );
    });
  });
}
