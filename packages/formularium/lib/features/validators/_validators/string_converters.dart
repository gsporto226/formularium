import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/not_null_validation.dart';
import 'package:formularium/features/validators/_data_types/number_validation.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Retorna um validador que falha se a string estiver vazia.
IUncategorizedFormFieldValidator<String, String> notEmptyValidator() => (string) {
  if (string.isEmpty) {
    return Validation(validation: const RequiredValidation(), transformed: string);
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que converte uma string para um [int].
IUncategorizedFormFieldValidator<String, int> asIntValidator() => (string) {
  final number = int.tryParse(string);
  if (number == null) {
    return Validation(validation: NotANumber(value: string), transformed: 0);
  }
  return Validation(transformed: number, validation: null);
};

/// Retorna um validador que converte uma string para um [double].
IUncategorizedFormFieldValidator<String, double> asDoubleValidator() => (string) {
  final number = double.tryParse(string);
  if (number == null) {
    return Validation(validation: NotANumber(value: string), transformed: 0);
  }
  return Validation(transformed: number, validation: null);
};

/// Retorna um validador que converte uma string para um [bool].
///
/// Quando [loose] for `true`, aceita "true"/"false", "yes"/"no" e "1"/"0".
/// Quando [loose] for `false`, aceita apenas "true"/"false" e "1"/"0" com distinção exata de maiúsculas e minúsculas.
IUncategorizedFormFieldValidator<String, bool> asBoolValidator({bool loose = false}) => (string) {
  if (loose) {
    final lower = string.toLowerCase();
    if (lower == 'true' || lower == 'yes' || lower == '1') {
      return Validation(transformed: true, validation: null);
    }
    if (lower == 'false' || lower == 'no' || lower == '0') {
      return Validation(transformed: false, validation: null);
    }
    return Validation(validation: StringValidation.notABoolean(string), transformed: false);
  }
  if (string == 'true' || string == '1') {
    return Validation(transformed: true, validation: null);
  }
  if (string == 'false' || string == '0') {
    return Validation(transformed: false, validation: null);
  }
  return Validation(validation: StringValidation.notABoolean(string), transformed: false);
};

/// Retorna um validador que converte uma string para um número de porta válido (0-65535).
IUncategorizedFormFieldValidator<String, int> asPortValidator() => (string) {
  final number = int.tryParse(string);
  if (number == null || number < 0 || number > 65535) {
    return Validation(validation: StringValidation.invalidPort(string), transformed: 0);
  }
  return Validation(transformed: number, validation: null);
};
