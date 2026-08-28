import 'package:flutter/widgets.dart' hide FormFieldState;
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import '../../helpers/test_utils.dart';

FormulariumFormField<String, String> makeField({
  String initialValue = '',
  bool enabled = true,
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
}) => FormulariumFormField(
  initialValue: initialValue,
  validator: CategorizedFormFieldValidators.instance.error(
    (v) => Validation(transformed: v, validation: null),
  ),
  enabled: enabled,
  autovalidateMode: autovalidateMode,
  focusNode: null,
);

void main() {
  group('Formularium.list', () {
    test('should create with fields and combine values', () {
      final f1 = makeField(initialValue: 'a');
      final f2 = makeField(initialValue: 'b');
      final form = Formularium.list(
        fields: [f1, f2],
        valueTransformer: (values) => '${values[0]}-${values[1]}',
      );
      expect(form.state, FormFieldState.pure);
      expect(form.status, isA<Pending<String>>());
      form.validate();
      expect(form.status, isA<Valid<String>>());
      expect((form.status as Valid<String>).transformed, 'a-b');
    });

    test('should return Invalid when field is invalid', () {
      final f = FormulariumFormField<String, String>(
        initialValue: 'bad',
        validator: CategorizedFormFieldValidators.instance.error<String, String>(
          (_) => Validation(transformed: '', validation: TestValidation.reason),
        ),
        enabled: true,
        autovalidateMode: AutovalidateMode.disabled,
        focusNode: null,
      );
      final form = Formularium.form1(
        first: f,
        valueCombiner: (v) => v,
      );
      expect((form..validate()).status, isA<Invalid<String>>());
    });

    test('should return Validating when any field is async', () {
      final f1 = makeField(initialValue: 'a');
      final f2 = FormulariumFormField<String, String>(
        initialValue: 'b',
        validator: CategorizedFormFieldValidators.instance.error(
          (_) => Future.value(Validation(transformed: 'b', validation: null)),
        ),
        enabled: true,
        autovalidateMode: AutovalidateMode.disabled,
        focusNode: null,
      );
      final form = Formularium.list(
        fields: [f1, f2],
        valueTransformer: (values) => '${values[0]}-${values[1]}',
      );
      expect((form..validate()).status, isA<Validating<String>>());
    });
  });

  group('Formularium.form1', () {
    test('should combine 1 field', () {
      final f = makeField(initialValue: 'x');
      final form = Formularium.form1(
        first: f,
        valueCombiner: (v) => 'result: $v',
      );
      expect(((form..validate()).status as Valid<String>).transformed, 'result: x');
    });
  });

  group('Formularium.form2', () {
    test('should combine 2 fields', () {
      final f1 = makeField(initialValue: 'a');
      final f2 = makeField(initialValue: 'b');
      final form = Formularium.form2(
        first: f1,
        second: f2,
        valueCombiner: (a, b) => '$a-$b',
      );
      expect(((form..validate()).status as Valid<String>).transformed, 'a-b');
    });

    test('disabled group propagates to fields', () {
      final f1 = makeField(initialValue: 'a');
      final f2 = makeField(initialValue: 'b');
      final form = Formularium.form2(
        first: f1,
        second: f2,
        valueCombiner: (a, b) => '$a-$b',
        enabled: false,
      );
      expect(form.enabled, false);
    });
  });

  group('Formularium lifecycle', () {
    test('reset should reset all fields', () {
      final f1 = makeField(initialValue: 'x');
      final f2 = makeField(initialValue: 'y');
      final form = Formularium.form2(
        first: f1,
        second: f2,
        valueCombiner: (a, b) => '$a-$b',
      );
      f1.value = 'modified';
      expect(form.state, FormFieldState.dirty);
      form.reset();
      expect(form.state, FormFieldState.pure);
    });

    test('clear should clear all fields', () {
      final f1 = makeField(initialValue: 'x');
      final f2 = makeField(initialValue: 'y');
      final form = Formularium.form2(
        first: f1,
        second: f2,
        valueCombiner: (a, b) => '$a-$b',
      );
      f1.value = 'modified';
      expect(form.state, FormFieldState.dirty);
      form.clear();
      expect(form.state, FormFieldState.pure);
    });

    test('dispose should not throw', () {
      final f1 = makeField(initialValue: 'x');
      final f2 = makeField(initialValue: 'y');
      final form = Formularium.form2(
        first: f1,
        second: f2,
        valueCombiner: (a, b) => '$a-$b',
      );
      expect(form.dispose, returnsNormally);
    });
  });

  group('FormulariumFormField enabled', () {
    test('field starts enabled', () {
      final field = makeField(initialValue: 'x');
      expect(field.enabled, true);
    });

    test('can disable field individually', () {
      final field = makeField(initialValue: 'x');
      field.enabled = false;
      expect(field.enabled, false);
    });

    test('can disable and re-enable field', () {
      final field = makeField(initialValue: 'x');
      field.enabled = false;
      expect(field.enabled, false);
      field.enabled = true;
      expect(field.enabled, true);
    });

    test('dispose should not throw', () {
      final field = makeField(initialValue: 'x');
      Formularium.form1(
        first: field,
        valueCombiner: (v) => v,
      );
      expect(field.dispose, returnsNormally);
    });
  });

  group('Formularium enabled', () {
    test('form starts enabled', () {
      final field = makeField(initialValue: 'x');
      final form = Formularium.form1(
        first: field,
        valueCombiner: (v) => v,
      );
      expect(form.enabled, true);
    });

    test('can disable form', () {
      final field = makeField(initialValue: 'x');
      final form = Formularium.form1(
        first: field,
        valueCombiner: (v) => v,
        enabled: false,
      );
      expect(form.enabled, false);
    });

    test(r'form $enabled listenable reflects form state', () {
      final field = makeField(initialValue: 'x');
      final form = Formularium.form1(
        first: field,
        valueCombiner: (v) => v,
      );
      expect(form.$enabled.value, true);
      form.enabled = false;
      expect(form.$enabled.value, false);
    });
  });
}
