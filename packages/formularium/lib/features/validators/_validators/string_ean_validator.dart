import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Valida se uma string é um EAN (Número de Artigo Europeu) válido.
///
/// Se [type] for 'ean8', valida como EAN-8. Se for 'ean13', valida como EAN-13.
/// Se for 'all' (padrão), aceita qualquer um dos formatos.
IUncategorizedFormFieldValidator<String, String> isEanValidator({String? type}) => (string) {
  final sanitized = string.replaceAll(RegExp(r'[-\s]'), '');

  if (type != null && type != 'all') {
    if (!RegExp(r'^\d{8}$').hasMatch(sanitized) && !RegExp(r'^\d{13}$').hasMatch(sanitized)) {
      return Validation(validation: StringValidation.invalidEan(string), transformed: '');
    }
    if (type == 'ean8' && sanitized.length != 8) {
      return Validation(validation: StringValidation.invalidEan(string), transformed: '');
    }
    if (type == 'ean13' && sanitized.length != 13) {
      return Validation(validation: StringValidation.invalidEan(string), transformed: '');
    }
  } else {
    if (!RegExp(r'^\d{8}$').hasMatch(sanitized) && !RegExp(r'^\d{13}$').hasMatch(sanitized)) {
      return Validation(validation: StringValidation.invalidEan(string), transformed: '');
    }
  }

  if (!_isValidGs1Checksum(sanitized)) {
    return Validation(validation: StringValidation.invalidEan(string), transformed: '');
  }

  return Validation(transformed: string, validation: null);
};

bool _isValidGs1Checksum(String digits) {
  var sum = 0;
  for (var i = 0; i < digits.length - 1; i++) {
    final multiplier = digits.length == 8 ? (i.isEven ? 3 : 1) : (i.isEven ? 1 : 3);
    sum += int.parse(digits[i]) * multiplier;
  }
  final check = (10 - sum % 10) % 10;
  return check == int.parse(digits[digits.length - 1]);
}
