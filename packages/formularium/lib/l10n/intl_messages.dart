import 'package:intl/intl.dart';

String date_time_field_before(String date) => Intl.message(
  'Deve ser antes de $date',
  name: 'date_time_field_before',
  args: [date],
  desc: 'Data deve ser anterior à data de referência',
);

String date_time_field_after(String date) => Intl.message(
  'Deve ser depois de $date',
  name: 'date_time_field_after',
  args: [date],
);

String date_time_field_before_inclusive(String date) => Intl.message(
  'Deve ser antes ou em $date',
  name: 'date_time_field_before_inclusive',
  args: [date],
);

String date_time_field_after_inclusive(String date) => Intl.message(
  'Deve ser depois ou em $date',
  name: 'date_time_field_after_inclusive',
  args: [date],
);

String number_field_value_too_big(String number) => Intl.message(
  'Valor maior que $number',
  name: 'number_field_value_too_big',
  args: [number],
);

String number_field_value_too_small(String number) => Intl.message(
  'Valor menor que $number',
  name: 'number_field_value_too_small',
  args: [number],
);

String get validation_not_a_number => Intl.message(
  'Não é um número válido',
  name: 'validation_not_a_number',
  desc: 'Entrada não é um número',
);

String number_field_not_divisible(String divisor) => Intl.message(
  'Não é divisível por $divisor',
  name: 'number_field_not_divisible',
  args: [divisor],
);

String get number_field_not_positive => Intl.message(
  'Deve ser positivo',
  name: 'number_field_not_positive',
);

String get number_field_not_negative => Intl.message(
  'Deve ser negativo',
  name: 'number_field_not_negative',
);

String validation_not_a_boolean(String value) => Intl.message(
  '"$value" não é um booleano válido',
  name: 'validation_not_a_boolean',
  args: [value],
);

String validation_invalid_port(String value) => Intl.message(
  '"$value" não é uma porta válida',
  name: 'validation_invalid_port',
  args: [value],
);

String validation_invalid_url(String value) => Intl.message(
  '"$value" não é uma URL válida',
  name: 'validation_invalid_url',
  args: [value],
);

String validation_invalid_lat_long(String value) => Intl.message(
  '"$value" não é latitude/longitude válida',
  name: 'validation_invalid_lat_long',
  args: [value],
);

String validation_invalid_email(String value) => Intl.message(
  '"$value" não é um email válido',
  name: 'validation_invalid_email',
  args: [value],
  desc: 'Email inválido',
);

String validation_invalid_uuid(String version) => Intl.message(
  'UUID inválido $version',
  name: 'validation_invalid_uuid',
  args: [version],
);

String validation_invalid_semver(String value) => Intl.message(
  '"$value" não é uma versão semântica válida',
  name: 'validation_invalid_semver',
  args: [value],
);

String validation_invalid_jwt(String value) => Intl.message(
  '"$value" não é um JWT válido',
  name: 'validation_invalid_jwt',
  args: [value],
);

String validation_invalid_slug(String value) => Intl.message(
  '"$value" não é um slug válido',
  name: 'validation_invalid_slug',
  args: [value],
);

String validation_not_base64(String value) => Intl.message(
  '"$value" não é Base64 válido',
  name: 'validation_not_base64',
  args: [value],
);

String validation_invalid_mime_type(String value) => Intl.message(
  '"$value" não é um MIME type válido',
  name: 'validation_invalid_mime_type',
  args: [value],
);

String validation_invalid_locale(String value) => Intl.message(
  '"$value" não é uma localidade válida',
  name: 'validation_invalid_locale',
  args: [value],
);

String validation_invalid_credit_card(String provider) => Intl.message(
  'Cartão de crédito inválido $provider',
  name: 'validation_invalid_credit_card',
  args: [provider],
);

String validation_weak_password(int score, int minScore) => Intl.message(
  'Senha fraca ($score/$minScore)',
  name: 'validation_weak_password',
  args: [score, minScore],
);

String validation_invalid_mongo_id(String value) => Intl.message(
  '"$value" não é um MongoId válido',
  name: 'validation_invalid_mongo_id',
  args: [value],
);

String validation_invalid_hash(String algorithm) => Intl.message(
  'Hash $algorithm inválido',
  name: 'validation_invalid_hash',
  args: [algorithm],
);

String validation_invalid_imei(String value) => Intl.message(
  '"$value" não é um IMEI válido',
  name: 'validation_invalid_imei',
  args: [value],
);

String validation_invalid_phone(String value) => Intl.message(
  '"$value" não é um telefone válido',
  name: 'validation_invalid_phone',
  args: [value],
);

String validation_invalid_json(String value) => Intl.message(
  '"$value" não é JSON válido',
  name: 'validation_invalid_json',
  args: [value],
);

String validation_invalid_mac_address(String value) => Intl.message(
  '"$value" não é MAC address válido',
  name: 'validation_invalid_mac_address',
  args: [value],
);

String get validation_not_octal => Intl.message(
  'Não é octal válido',
  name: 'validation_not_octal',
);

String validation_byte_length_exceeded(int min, int max) => Intl.message(
  'Comprimento em bytes deve ser entre $min e $max',
  name: 'validation_byte_length_exceeded',
  args: [min, max],
);

String get validation_not_multibyte => Intl.message(
  'Não é multibyte',
  name: 'validation_not_multibyte',
);

String get validation_not_full_width => Intl.message(
  'Não é full-width',
  name: 'validation_not_full_width',
);

String get validation_not_half_width => Intl.message(
  'Não é half-width',
  name: 'validation_not_half_width',
);

String get validation_not_variable_width => Intl.message(
  'Não é variable-width',
  name: 'validation_not_variable_width',
);

String get validation_not_surrogate_pair => Intl.message(
  'Não é surrogate pair',
  name: 'validation_not_surrogate_pair',
);

String validation_invalid_ip(String value) => Intl.message(
  '"$value" não é um IP válido',
  name: 'validation_invalid_ip',
  args: [value],
);

String validation_invalid_postal_code(String value) => Intl.message(
  '"$value" não é um CEP válido',
  name: 'validation_invalid_postal_code',
  args: [value],
);

String validation_invalid_isbn(String value) => Intl.message(
  '"$value" não é um ISBN válido',
  name: 'validation_invalid_isbn',
  args: [value],
);

String validation_invalid_ean(String value) => Intl.message(
  '"$value" não é um EAN válido',
  name: 'validation_invalid_ean',
  args: [value],
);

String validation_invalid_base32(String value) => Intl.message(
  '"$value" não é Base32 válido',
  name: 'validation_invalid_base32',
  args: [value],
);

String validation_invalid_base58(String value) => Intl.message(
  '"$value" não é Base58 válido',
  name: 'validation_invalid_base58',
  args: [value],
);

String get validation_not_alphanumeric => Intl.message(
  'Não é alfanumérico',
  name: 'validation_not_alphanumeric',
);

String get validation_not_alpha => Intl.message(
  'Não é alfabético',
  name: 'validation_not_alpha',
);

String get validation_not_ascii => Intl.message(
  'Não é ASCII',
  name: 'validation_not_ascii',
);

String validation_not_numeric(bool noSymbols) => Intl.message(
  'Não é numérico',
  name: 'validation_not_numeric',
  args: [noSymbols],
);

String get validation_not_hexadecimal => Intl.message(
  'Não é hexadecimal',
  name: 'validation_not_hexadecimal',
);

String get validation_not_lowercase => Intl.message(
  'Não está em minúsculas',
  name: 'validation_not_lowercase',
);

String get validation_not_uppercase => Intl.message(
  'Não está em maiúsculas',
  name: 'validation_not_uppercase',
);

String validation_string_length_exceeded(int min, int max) => Intl.message(
  'Comprimento deve ser entre $min e $max',
  name: 'validation_string_length_exceeded',
  args: [min, max],
);

String validation_string_length_mismatch(List<int> discrete) => Intl.message(
  'Comprimento deve ser um de: $discrete',
  name: 'validation_string_length_mismatch',
  args: [discrete],
);

String validation_pattern_mismatch(String pattern) => Intl.message(
  'Não corresponde ao padrão: $pattern',
  name: 'validation_pattern_mismatch',
  args: [pattern],
);

String get validation_not_in_list => Intl.message(
  'Valor não está na lista permitida',
  name: 'validation_not_in_list',
);

String validation_must_contain(String seed) => Intl.message(
  'Deve conter "$seed"',
  name: 'validation_must_contain',
  args: [seed],
);

String validation_must_equal(String comparison) => Intl.message(
  'Deve ser igual a "$comparison"',
  name: 'validation_must_equal',
  args: [comparison],
);

String validation_invalid_time(String value, String hourFormat, String mode) =>
    Intl.message(
  '"$value" não é um horário válido (formato $hourFormat, modo $mode)',
  name: 'validation_invalid_time',
  args: [value, hourFormat, mode],
);

String get date_invalid => Intl.message(
  'Data inválida',
  name: 'date_invalid',
);

String get required_field_label => Intl.message(
  'Campo obrigatório',
  name: 'required_field_label',
);
