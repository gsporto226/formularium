import 'dart:io';

import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Valida se uma string é um endereço IP válido.
///
/// Se [version] for 4, valida como IPv4. Se for 6, valida como IPv6.
/// Se for null (padrão), aceita qualquer versão.
IUncategorizedFormFieldValidator<String, String> isIpValidator({int? version}) => (string) {
  if (version != null && version != 4 && version != 6) {
    return Validation(validation: StringValidation.invalidIp(string), transformed: '');
  }

  try {
    final parsed = InternetAddress(string);
    if (version == null) {
      return Validation(transformed: string, validation: null);
    }
    if (version == 4 && parsed.type == InternetAddressType.IPv4) {
      return Validation(transformed: string, validation: null);
    }
    if (version == 6 && parsed.type == InternetAddressType.IPv6) {
      return Validation(transformed: string, validation: null);
    }
    return Validation(validation: StringValidation.invalidIp(string), transformed: '');
  } on Object catch (_) {
    return Validation(validation: StringValidation.invalidIp(string), transformed: '');
  }
};
