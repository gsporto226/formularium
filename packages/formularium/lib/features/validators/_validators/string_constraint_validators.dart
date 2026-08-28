import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Retorna um validador que verifica se o tamanho de uma string está entre [min] e [max] ou corresponde a um dos [discreteLengths].
IUncategorizedFormFieldValidator<String, String> lengthValidator({
  int min = 0,
  int? max,
  List<int>? discreteLengths,
}) => (string) {
  final len = string.length;
  if (discreteLengths != null && discreteLengths.isNotEmpty) {
    if (!discreteLengths.contains(len)) {
      return Validation(validation: StringValidation.stringLengthMismatch(discreteLengths), transformed: string);
    }
    return Validation(transformed: string, validation: null);
  }
  if (len < min || (max != null && len > max)) {
    return Validation(
      validation: StringValidation.stringLengthExceeded(min: min, max: max),
      transformed: string,
    );
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string corresponde ao [pattern] informado.
IUncategorizedFormFieldValidator<String, String> matchesValidator(Pattern pattern) => (string) {
  if (pattern is RegExp) {
    if (!pattern.hasMatch(string)) {
      return Validation(validation: StringValidation.patternMismatch(pattern.pattern), transformed: '');
    }
  } else {
    if (!string.contains(pattern)) {
      return Validation(validation: StringValidation.patternMismatch(pattern.toString()), transformed: '');
    }
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string é um dos [values] permitidos.
IUncategorizedFormFieldValidator<String, String> isInValidator(List<String> values) => (string) {
  if (!values.contains(string)) {
    return Validation(validation: StringValidation.notInList(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string contém [seed] pelo menos [minOccurrences] vezes.
///
/// Defina [ignoreCase] como `true` para busca sem distinção entre maiúsculas e minúsculas.
IUncategorizedFormFieldValidator<String, String> containsValidator(
  String seed, {
  bool ignoreCase = false,
  int minOccurrences = 1,
}) => (string) {
  final source = ignoreCase ? string.toLowerCase() : string;
  final search = ignoreCase ? seed.toLowerCase() : seed;
  var count = 0;
  var index = 0;
  while ((index = source.indexOf(search, index)) != -1) {
    count++;
    index++;
  }
  if (count < minOccurrences) {
    return Validation(validation: StringValidation.mustContain(seed), transformed: string);
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string é igual a [comparison].
IUncategorizedFormFieldValidator<String, String> equalsValidator(String comparison) => (string) {
  if (string != comparison) {
    return Validation(validation: StringValidation.mustEqual(comparison), transformed: string);
  }
  return Validation(transformed: string, validation: null);
};
