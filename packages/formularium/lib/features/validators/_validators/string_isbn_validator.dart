import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Valida se uma string é um ISBN válido.
///
/// Se [version] for 10, valida como ISBN-10. Se for 13, valida como ISBN-13.
/// Se for null (padrão), aceita qualquer formato.
IUncategorizedFormFieldValidator<String, String> isIsbnValidator({int? version}) => (string) {
  final sanitized = string.replaceAll(RegExp(r'[-\s]'), '');
  if (version == null || version == 10) {
    if (_isValidIsbn10(sanitized)) {
      return Validation(transformed: string, validation: null);
    }
  }
  if (version == null || version == 13) {
    if (_isValidIsbn13(sanitized)) {
      return Validation(transformed: string, validation: null);
    }
  }
  return Validation(validation: StringValidation.invalidIsbn(string), transformed: '');
};

bool _isValidIsbn10(String isbn) {
  if (!RegExp(r'^\d{9}[\dX]$').hasMatch(isbn)) return false;
  var sum = 0;
  for (var i = 0; i < 9; i++) {
    sum += (10 - i) * int.parse(isbn[i]);
  }
  final check = isbn[9] == 'X' ? 10 : int.parse(isbn[9]);
  sum += check;
  return sum % 11 == 0;
}

bool _isValidIsbn13(String isbn) {
  if (!RegExp(r'^\d{13}$').hasMatch(isbn)) return false;
  var sum = 0;
  for (var i = 0; i < 13; i++) {
    sum += int.parse(isbn[i]) * (i.isEven ? 1 : 3);
  }
  return sum % 10 == 0;
}
