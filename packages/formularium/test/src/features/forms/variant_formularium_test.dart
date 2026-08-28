import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_implementations/raw_formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/forms/_implementations/variant_formularium.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('VariantFormularium', () {
    late ValueNotifier<bool> selector;
    late RawFormulariumFormField<String, String> first;
    late RawFormulariumFormField<String, String> second;
    late VariantFormularium<bool, String> variant;

    // ignore: no_leading_underscores_for_local_identifiers - mixed types in collection
    final _disposables = <dynamic>[];

    setUp(() {
      selector = ValueNotifier(true);
      first = RawFormulariumFormField(
        validator: CategorizedFormFieldValidators.instance.error(
          (v) => Validation(transformed: v, validation: null),
        ),
        initialValue: 'first',
        enabled: true,
      );
      second = RawFormulariumFormField(
        validator: CategorizedFormFieldValidators.instance.error(
          (v) => Validation(transformed: v, validation: null),
        ),
        initialValue: 'second',
        enabled: true,
      );
      variant = VariantFormularium(
        variants: {true: first, false: second},
        selector: selector,
      );
      _disposables.addAll([selector, first, second, variant]);
    });

    tearDown(() {
      for (final d in _disposables.reversed) {
        if (d is ValueNotifier) d.dispose();
        if (d is RawFormulariumFormField) d.dispose();
        if (d is VariantFormularium) d.dispose();
      }
      _disposables.clear();
    });

    test('should delegate to first when selector is true', () {
      expect(variant.enabled, first.enabled);
    });

    test('should delegate to second when selector is false', () {
      selector.value = false;
      expect(variant.enabled, second.enabled);
    });

    test('enabled setter should delegate to active field when selector is true', () {
      expect(first.enabled, true);
      variant.enabled = false;
      expect(first.enabled, false);
      expect(variant.enabled, false);
    });

    test('enabled setter should delegate to active field when selector is false', () {
      selector.value = false;
      expect(second.enabled, true);
      variant.enabled = false;
      expect(second.enabled, false);
      expect(variant.enabled, false);
    });

    test('state should reflect active field', () {
      expect(variant.state, first.state);
      first.value = 'modified';
      expect(variant.state, FormFieldState.dirty);
    });

    test('state should reflect second field when selected', () {
      selector.value = false;
      expect(variant.state, second.state);
      second.value = 'modified';
      expect(variant.state, FormFieldState.dirty);
    });

    test('status should reflect active field', () {
      expect(variant.status, isA<Pending<String>>());
      variant.validate();
      expect(variant.status, isA<Valid<String>>());
      expect(
        (variant.status as Valid<String>).transformed,
        'first',
      );
    });

    test('status should switch to second when selector changes', () {
      variant.validate();
      selector.value = false;
      expect(variant.status, isA<Pending<String>>());
    });

    test('validateDirty on dirty field', () {
      first.value = 'modified';
      variant.validateDirty();
      expect(variant.status, isA<Valid<String>>());
      expect(
        (variant.status as Valid<String>).transformed,
        'modified',
      );
    });

    test('validate should delegate to active field', () {
      final result = variant.validate();
      expect(result, isA<Valid<String>>());
      expect((result as Valid<String>).transformed, 'first');
    });

    test('validate with warning should work', () {
      final warningField = RawFormulariumFormField<String, String>(
        validator: CategorizedFormFieldValidators.instance.warning(
          (v) => Validation(transformed: v, validation: TestValidation.warn),
        ),
        initialValue: 'warn',
        enabled: true,
      );
      variant = VariantFormularium(
        variants: {true: warningField, false: second},
        selector: selector,
      );
      _disposables.addAll([warningField, variant]);
      final result = variant.validate();
      expect(result, isA<Valid<String>>());
      expect((result as Valid<String>).validation, isNotNull);
    });

    test('validate with error should work', () {
      first = RawFormulariumFormField<String, String>(
        validator: CategorizedFormFieldValidators.instance.error(
          (v) => Validation(transformed: v, validation: TestValidation.reason),
        ),
        initialValue: 'err',
        enabled: true,
      );
      _disposables.add(first);
      variant = VariantFormularium(
        variants: {true: first, false: second},
        selector: selector,
      );
      _disposables.add(variant);
      final result = variant.validate();
      expect(result, isA<Invalid<String>>());
    });

    test('reset should delegate to active field', () {
      first.value = 'modified';
      expect(first.state, FormFieldState.dirty);
      variant.reset();
      expect(first.state, FormFieldState.pure);
    });

    test('clear should delegate to active field', () {
      first.value = 'modified';
      variant.clear();
      expect(first.state, FormFieldState.pure);
    });

    test('dispose should not throw', () {
      expect(() => variant.dispose(), returnsNormally);
      _disposables.remove(variant);
    });

    test('enabled listenable should emit correct values', () {
      final captured = <bool>[];
      variant.$enabled.addListener(() {
        captured.add(variant.$enabled.value);
      });
      variant.enabled = false;
      expect(captured, [false]);
    });

    test(r'$state listenable should return correct value', () {
      expect(variant.$state.value, FormFieldState.pure);
    });

    test(r'$status listenable should return correct value', () {
      expect(variant.$status.value, isA<Pending<String>>());
    });
  });
}
