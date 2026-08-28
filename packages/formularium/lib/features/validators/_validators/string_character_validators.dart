import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Retorna um validador que verifica se uma string contém apenas caracteres alfanuméricos.
///
/// Caracteres em [ignore] são removidos antes da validação.
IUncategorizedFormFieldValidator<String, String> isAlphanumericValidator({String? ignore}) => (string) {
  final chars = ignore != null ? string.replaceAll(RegExp(RegExp.escape(ignore)), '') : string;
  if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(chars)) {
    return Validation(validation: StringValidation.notAlphanumeric(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string contém apenas caracteres alfabéticos.
///
/// Caracteres em [ignore] são removidos antes da validação.
IUncategorizedFormFieldValidator<String, String> isAlphaValidator({String? ignore}) => (string) {
  final chars = ignore != null ? string.replaceAll(RegExp(RegExp.escape(ignore)), '') : string;
  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(chars)) {
    return Validation(validation: StringValidation.notAlpha(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string contém apenas caracteres ASCII.
IUncategorizedFormFieldValidator<String, String> isAsciiValidator() => (string) {
  if (!string.codeUnits.every((c) => c < 128)) {
    return Validation(validation: StringValidation.notAscii(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string representa um valor numérico.
///
/// Quando [noSymbols] é `true`, apenas dígitos são permitidos (sem +, -, e, E ou .).
IUncategorizedFormFieldValidator<String, String> isNumericValidator({bool noSymbols = false}) => (string) {
  final pattern = noSymbols ? RegExp(r'^\d+$') : RegExp(r'^[\d.+\-eE]+$');
  if (!pattern.hasMatch(string)) {
    return Validation(
      validation: StringValidation.notNumeric(noSymbols: noSymbols),
      transformed: '',
    );
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string contém apenas dígitos hexadecimais (0-9, a-f, A-F).
IUncategorizedFormFieldValidator<String, String> isHexadecimalValidator() => (string) {
  if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(string)) {
    return Validation(validation: StringValidation.notHexadecimal(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string está toda em minúsculas.
IUncategorizedFormFieldValidator<String, String> isLowercaseValidator() => (string) {
  if (string != string.toLowerCase()) {
    return Validation(validation: StringValidation.notLowercase(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string está toda em maiúsculas.
IUncategorizedFormFieldValidator<String, String> isUppercaseValidator() => (string) {
  if (string != string.toUpperCase()) {
    return Validation(validation: StringValidation.notUppercase(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};
