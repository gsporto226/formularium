import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';

const _htmlEscapeMap = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  "'": '&#x27;',
  '`': '&#x60;',
};

const _htmlUnescapeMap = {
  '&amp;': '&',
  '&lt;': '<',
  '&gt;': '>',
  '&quot;': '"',
  '&#x27;': "'",
  '&#39;': "'",
  '&#x60;': '`',
  '&#96;': '`',
};

/// Retorna um sanitizador que escapa caracteres especiais HTML.
IUncategorizedFormFieldValidator<String, String> escapeValidator() => (string) {
  final result = string.split('').map((c) => _htmlEscapeMap[c] ?? c).join();
  return Validation(transformed: result, validation: null);
};

/// Retorna um sanitizador que desescapa entidades HTML.
IUncategorizedFormFieldValidator<String, String> unescapeValidator() => (string) {
  var result = string;
  for (final entry in _htmlUnescapeMap.entries) {
    result = result.replaceAll(entry.key, entry.value);
  }
  result = result.replaceAllMapped(
    RegExp(r'&#x([0-9a-fA-F]+);|&#(\d+);'),
    (m) {
      final codePoint = m.group(1) != null ? int.parse(m.group(1)!, radix: 16) : int.parse(m.group(2)!);
      return String.fromCharCode(codePoint);
    },
  );
  return Validation(transformed: result, validation: null);
};

/// Retorna um sanitizador que remove todos os caracteres com código ASCII abaixo de 32.
///
/// Defina [keepNewLines] como `true` para preservar os caracteres de nova linha (10) e
/// retorno de carro (13).
IUncategorizedFormFieldValidator<String, String> stripLowValidator({
  bool keepNewLines = false,
}) => (string) {
  final result = string.split('').where((c) {
    final code = c.codeUnitAt(0);
    if (keepNewLines && (code == 10 || code == 13)) return true;
    return code >= 32;
  }).join();
  return Validation(transformed: result, validation: null);
};

/// Retorna um sanitizador que mantém apenas os caracteres presentes em [chars].
IUncategorizedFormFieldValidator<String, String> whitelistValidator(String chars) => (string) {
  final result = string.split('').where((c) => chars.contains(c)).join();
  return Validation(transformed: result, validation: null);
};

/// Retorna um sanitizador que remove todos os caracteres presentes em [chars].
IUncategorizedFormFieldValidator<String, String> blacklistValidator(String chars) => (string) {
  final result = string.split('').where((c) => !chars.contains(c)).join();
  return Validation(transformed: result, validation: null);
};
