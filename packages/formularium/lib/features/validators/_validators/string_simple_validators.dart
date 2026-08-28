import 'dart:convert';

import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Retorna um validador que verifica se uma string é um JSON válido.
IUncategorizedFormFieldValidator<String, String> isJsonValidator() => (string) {
  try {
    jsonDecode(string);
    return Validation(transformed: string, validation: null);
  } on Object catch (_) {
    return Validation(validation: StringValidation.invalidJson(string), transformed: '');
  }
};

/// Retorna um validador que verifica se uma string é um endereço MAC válido.
///
/// Defina [noColons] como `true` para o formato hexadecimal de 12 dígitos sem dois-pontos.
IUncategorizedFormFieldValidator<String, String> isMacAddressValidator({
  bool noColons = false,
}) => (string) {
  final pattern = noColons ? RegExp(r'^[0-9a-fA-F]{12}$') : RegExp(r'^([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}$');
  if (!pattern.hasMatch(string.trim())) {
    return Validation(validation: StringValidation.invalidMacAddress(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string contém apenas dígitos octais (0-7).
IUncategorizedFormFieldValidator<String, String> isOctalValidator() => (string) {
  if (!RegExp(r'^[0-7]+$').hasMatch(string)) {
    return Validation(validation: StringValidation.notOctal(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se o comprimento em bytes UTF-8 de uma string está
/// dentro de [min] e [max].
IUncategorizedFormFieldValidator<String, String> isByteLengthValidator({
  int min = 0,
  int? max,
}) => (string) {
  final len = utf8.encode(string).length;
  if (len < min || (max != null && len > max)) {
    return Validation(
      validation: StringValidation.byteLengthExceeded(min: min, max: max),
      transformed: string,
    );
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string contém algum caractere multibyte (não-ASCII).
IUncategorizedFormFieldValidator<String, String> isMultibyteValidator() => (string) {
  if (!string.codeUnits.any((c) => c > 255)) {
    return Validation(validation: StringValidation.notMultibyte(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

bool _isFullWidthChar(int codeUnit) =>
    (codeUnit >= 0xFF01 && codeUnit <= 0xFF60) || (codeUnit >= 0xFFE0 && codeUnit <= 0xFFE6);

bool _isHalfWidthChar(int codeUnit) =>
    (codeUnit >= 0x0000 && codeUnit <= 0x00FF) ||
    (codeUnit >= 0xFF61 && codeUnit <= 0xFFDC) ||
    (codeUnit >= 0xFFE8 && codeUnit <= 0xFFEE);

/// Retorna um validador que verifica se uma string contém algum caractere de largura completa (full-width).
IUncategorizedFormFieldValidator<String, String> isFullWidthValidator() => (string) {
  if (!string.codeUnits.any(_isFullWidthChar)) {
    return Validation(validation: StringValidation.notFullWidth(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string contém algum caractere de meia largura (half-width).
IUncategorizedFormFieldValidator<String, String> isHalfWidthValidator() => (string) {
  if (!string.codeUnits.any(_isHalfWidthChar)) {
    return Validation(validation: StringValidation.notHalfWidth(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string contém tanto caracteres de largura completa
/// quanto de meia largura.
IUncategorizedFormFieldValidator<String, String> isVariableWidthValidator() => (string) {
  final hasFull = string.codeUnits.any(_isFullWidthChar);
  final hasHalf = string.codeUnits.any(_isHalfWidthChar);
  if (!hasFull || !hasHalf) {
    return Validation(validation: StringValidation.notVariableWidth(), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string contém um par substituto (surrogate pair).
IUncategorizedFormFieldValidator<String, String> isSurrogatePairValidator() => (string) {
  final codeUnits = string.codeUnits;
  for (var i = 0; i < codeUnits.length - 1; i++) {
    if (codeUnits[i] >= 0xD800 && codeUnits[i] <= 0xDBFF && codeUnits[i + 1] >= 0xDC00 && codeUnits[i + 1] <= 0xDFFF) {
      return Validation(transformed: string, validation: null);
    }
  }
  return Validation(validation: StringValidation.notSurrogatePair(), transformed: '');
};
