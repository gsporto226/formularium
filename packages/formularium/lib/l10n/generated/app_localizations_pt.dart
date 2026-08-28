// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String date_time_field_before(String date) {
    return 'Deve ser antes de $date';
  }

  @override
  String date_time_field_after(String date) {
    return 'Deve ser depois de $date';
  }

  @override
  String date_time_field_before_inclusive(String date) {
    return 'Deve ser antes ou em $date';
  }

  @override
  String date_time_field_after_inclusive(String date) {
    return 'Deve ser depois ou em $date';
  }

  @override
  String number_field_value_too_big(String number) {
    return 'Valor maior que $number';
  }

  @override
  String number_field_value_too_small(String number) {
    return 'Valor menor que $number';
  }

  @override
  String get validation_not_a_number => 'Não é um número válido';

  @override
  String number_field_not_divisible(String divisor) {
    return 'Não é divisível por $divisor';
  }

  @override
  String get number_field_not_positive => 'Deve ser positivo';

  @override
  String get number_field_not_negative => 'Deve ser negativo';

  @override
  String validation_not_a_boolean(String value) {
    return '\"$value\" não é um booleano válido';
  }

  @override
  String validation_invalid_port(String value) {
    return '\"$value\" não é uma porta válida';
  }

  @override
  String validation_invalid_url(String value) {
    return '\"$value\" não é uma URL válida';
  }

  @override
  String validation_invalid_lat_long(String value) {
    return '\"$value\" não é latitude/longitude válida';
  }

  @override
  String validation_invalid_email(String value) {
    return '\"$value\" não é um email válido';
  }

  @override
  String validation_invalid_uuid(String version) {
    return 'UUID inválido $version';
  }

  @override
  String validation_invalid_semver(String value) {
    return '\"$value\" não é uma versão semântica válida';
  }

  @override
  String validation_invalid_jwt(String value) {
    return '\"$value\" não é um JWT válido';
  }

  @override
  String validation_invalid_slug(String value) {
    return '\"$value\" não é um slug válido';
  }

  @override
  String validation_not_base64(String value) {
    return '\"$value\" não é Base64 válido';
  }

  @override
  String validation_invalid_mime_type(String value) {
    return '\"$value\" não é um MIME type válido';
  }

  @override
  String validation_invalid_locale(String value) {
    return '\"$value\" não é uma localidade válida';
  }

  @override
  String validation_invalid_credit_card(String provider) {
    return 'Cartão de crédito inválido $provider';
  }

  @override
  String validation_weak_password(int score, int minScore) {
    return 'Senha fraca ($score/$minScore)';
  }

  @override
  String validation_invalid_mongo_id(String value) {
    return '\"$value\" não é um MongoId válido';
  }

  @override
  String validation_invalid_hash(String algorithm) {
    return 'Hash $algorithm inválido';
  }

  @override
  String validation_invalid_imei(String value) {
    return '\"$value\" não é um IMEI válido';
  }

  @override
  String validation_invalid_phone(String value) {
    return '\"$value\" não é um telefone válido';
  }

  @override
  String validation_invalid_json(String value) {
    return '\"$value\" não é JSON válido';
  }

  @override
  String validation_invalid_mac_address(String value) {
    return '\"$value\" não é MAC address válido';
  }

  @override
  String get validation_not_octal => 'Não é octal válido';

  @override
  String validation_byte_length_exceeded(int min, int max) {
    return 'Comprimento em bytes deve ser entre $min e $max';
  }

  @override
  String get validation_not_multibyte => 'Não é multibyte';

  @override
  String get validation_not_full_width => 'Não é full-width';

  @override
  String get validation_not_half_width => 'Não é half-width';

  @override
  String get validation_not_variable_width => 'Não é variable-width';

  @override
  String get validation_not_surrogate_pair => 'Não é surrogate pair';

  @override
  String validation_invalid_ip(String value) {
    return '\"$value\" não é um IP válido';
  }

  @override
  String validation_invalid_postal_code(String value) {
    return '\"$value\" não é um CEP válido';
  }

  @override
  String validation_invalid_isbn(String value) {
    return '\"$value\" não é um ISBN válido';
  }

  @override
  String validation_invalid_ean(String value) {
    return '\"$value\" não é um EAN válido';
  }

  @override
  String validation_invalid_base32(String value) {
    return '\"$value\" não é Base32 válido';
  }

  @override
  String validation_invalid_base58(String value) {
    return '\"$value\" não é Base58 válido';
  }

  @override
  String get validation_not_alphanumeric => 'Não é alfanumérico';

  @override
  String get validation_not_alpha => 'Não é alfabético';

  @override
  String get validation_not_ascii => 'Não é ASCII';

  @override
  String validation_not_numeric(bool noSymbols) {
    return 'Não é numérico';
  }

  @override
  String get validation_not_hexadecimal => 'Não é hexadecimal';

  @override
  String get validation_not_lowercase => 'Não está em minúsculas';

  @override
  String get validation_not_uppercase => 'Não está em maiúsculas';

  @override
  String validation_string_length_exceeded(int min, int max) {
    return 'Comprimento deve ser entre $min e $max';
  }

  @override
  String validation_string_length_mismatch(List<int> discrete) {
    return 'Comprimento deve ser um de: $discrete';
  }

  @override
  String validation_pattern_mismatch(String pattern) {
    return 'Não corresponde ao padrão: $pattern';
  }

  @override
  String get validation_not_in_list => 'Valor não está na lista permitida';

  @override
  String validation_must_contain(String seed) {
    return 'Deve conter \"$seed\"';
  }

  @override
  String validation_must_equal(String comparison) {
    return 'Deve ser igual a \"$comparison\"';
  }

  @override
  String validation_invalid_time(String value, String hourFormat, String mode) {
    return '\"$value\" não é um horário válido (formato $hourFormat, modo $mode)';
  }

  @override
  String get date_invalid => 'Data inválida';

  @override
  String get required_field_label => 'Campo obrigatório';
}
