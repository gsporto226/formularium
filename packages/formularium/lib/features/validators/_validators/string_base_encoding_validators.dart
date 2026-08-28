import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Valida se uma string é uma string codificada em Base32 válida.
IUncategorizedFormFieldValidator<String, String> isBase32Validator() => (string) {
  if (string.isEmpty) {
    return Validation(validation: StringValidation.invalidBase32(string), transformed: '');
  }
  if (!RegExp(r'^[A-Z2-7]+=*$').hasMatch(string)) {
    return Validation(validation: StringValidation.invalidBase32(string), transformed: '');
  }
  if (string.length % 8 != 0) {
    return Validation(validation: StringValidation.invalidBase32(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Valida se uma string é uma string codificada em Base58 válida.
IUncategorizedFormFieldValidator<String, String> isBase58Validator() => (string) {
  if (string.isEmpty) {
    return Validation(validation: StringValidation.invalidBase58(string), transformed: '');
  }
  if (!RegExp(r'^[1-9A-HJ-NP-Za-km-z]+$').hasMatch(string)) {
    return Validation(validation: StringValidation.invalidBase58(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};
