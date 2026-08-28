import 'package:decimal/decimal.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium_decimal/src/decimal_validation.dart';

/// Fornece validadores de campo de formulário para valores [Decimal].
class DecimalFormFieldValidators {
  const DecimalFormFieldValidators._();

  /// A instância singleton de [DecimalFormFieldValidators].
  static DecimalFormFieldValidators instance = const DecimalFormFieldValidators._();

  /// Retorna um validador que limita o valor ao máximo de [maxValue].
  IUncategorizedFormFieldValidator<Decimal, Decimal> max(Decimal maxValue) => (Decimal value) {
    if (value > maxValue) {
      return Validation(transformed: maxValue, validation: DecimalValidation.max(maxValue));
    }
    return Validation(transformed: value, validation: null);
  };

  /// Retorna um validador que limita o valor ao mínimo de [minValue].
  IUncategorizedFormFieldValidator<Decimal, Decimal> min(Decimal minValue) => (Decimal value) {
    if (value < minValue) {
      return Validation(transformed: minValue, validation: DecimalValidation.min(minValue));
    }
    return Validation(transformed: value, validation: null);
  };
}
