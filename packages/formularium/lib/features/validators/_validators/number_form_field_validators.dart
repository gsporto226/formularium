import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/number_validation.dart';

/// Validadores para campos de formulário baseados em números.
class NumberFormFieldValidators {
  const NumberFormFieldValidators._();

  /// Instância singleton de [NumberFormFieldValidators].
  static NumberFormFieldValidators instance = const NumberFormFieldValidators._();

  /// Retorna um validador que limita o valor em [maxValue].
  IUncategorizedFormFieldValidator<num, num> max(num maxValue) => (num value) {
    if (value > maxValue) {
      return Validation(transformed: maxValue, validation: NumberValidation.max(maxValue));
    }
    return Validation(transformed: value, validation: null);
  };

  /// Retorna um validador que limita o valor em [minValue].
  IUncategorizedFormFieldValidator<num, num> min(num minValue) => (num value) {
    if (value < minValue) {
      return Validation(transformed: minValue, validation: NumberValidation.min(minValue));
    }
    return Validation(transformed: value, validation: null);
  };

  /// Retorna um validador que falha se a entrada não for maior que [value].
  IUncategorizedFormFieldValidator<num, num> greaterThan(num value) => (num input) {
    if (input > value) {
      return Validation(transformed: input, validation: null);
    }
    return Validation(transformed: input, validation: NumberValidation.min(value));
  };

  /// Retorna um validador que falha se a entrada não for menor que [value].
  IUncategorizedFormFieldValidator<num, num> lessThan(num value) => (num input) {
    if (input < value) {
      return Validation(transformed: input, validation: null);
    }
    return Validation(transformed: input, validation: NumberValidation.max(value));
  };

  /// Retorna um validador que limita o valor entre [minValue] e [maxValue].
  IUncategorizedFormFieldValidator<num, num> range(num minValue, num maxValue) => (num value) {
    if (value < minValue) {
      return Validation(transformed: minValue, validation: NumberValidation.min(minValue));
    }
    if (value > maxValue) {
      return Validation(transformed: maxValue, validation: NumberValidation.max(maxValue));
    }
    return Validation(transformed: value, validation: null);
  };

  /// Retorna um validador que falha se a entrada não for divisível por [divisor].
  IUncategorizedFormFieldValidator<num, num> divisibleBy(num divisor) => (num value) {
    if (value % divisor != 0) {
      return Validation(
        transformed: value,
        validation: NumberValidation.notDivisible(divisor),
      );
    }
    return Validation(transformed: value, validation: null);
  };

  /// Retorna um validador que aceita apenas valores positivos (>0).
  IUncategorizedFormFieldValidator<num, num> positive() => greaterThan(0);

  /// Retorna um validador que aceita apenas valores negativos (<0).
  IUncategorizedFormFieldValidator<num, num> negative() => lessThan(0);
}
