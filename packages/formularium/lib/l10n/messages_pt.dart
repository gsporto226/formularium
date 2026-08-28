// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(
    String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'pt';

  static m0(date) => "Deve ser depois de ${date}";

  static m1(date) => "Deve ser depois ou em ${date}";

  static m2(date) => "Deve ser antes de ${date}";

  static m3(date) => "Deve ser antes ou em ${date}";

  static m4(divisor) => "Não é divisível por ${divisor}";

  static m5(number) => "Valor maior que ${number}";

  static m6(number) => "Valor menor que ${number}";

  static m7(min, max) => "Comprimento em bytes deve ser entre ${min} e ${max}";

  static m8(value) => "\"${value}\" não é Base32 válido";

  static m9(value) => "\"${value}\" não é Base58 válido";

  static m10(provider) => "Cartão de crédito inválido ${provider}";

  static m11(value) => "\"${value}\" não é um EAN válido";

  static m12(value) => "\"${value}\" não é um email válido";

  static m13(algorithm) => "Hash ${algorithm} inválido";

  static m14(value) => "\"${value}\" não é um IMEI válido";

  static m15(value) => "\"${value}\" não é um IP válido";

  static m16(value) => "\"${value}\" não é um ISBN válido";

  static m17(value) => "\"${value}\" não é JSON válido";

  static m18(value) => "\"${value}\" não é um JWT válido";

  static m19(value) => "\"${value}\" não é latitude/longitude válida";

  static m20(value) => "\"${value}\" não é uma localidade válida";

  static m21(value) => "\"${value}\" não é MAC address válido";

  static m22(value) => "\"${value}\" não é um MIME type válido";

  static m23(value) => "\"${value}\" não é um MongoId válido";

  static m24(value) => "\"${value}\" não é um telefone válido";

  static m25(value) => "\"${value}\" não é uma porta válida";

  static m26(value) => "\"${value}\" não é um CEP válido";

  static m27(value) => "\"${value}\" não é uma versão semântica válida";

  static m28(value) => "\"${value}\" não é um slug válido";

  static m29(value, hourFormat, mode) => "\"${value}\" não é um horário válido (formato ${hourFormat}, modo ${mode})";

  static m30(value) => "\"${value}\" não é uma URL válida";

  static m31(version) => "UUID inválido ${version}";

  static m32(seed) => "Deve conter \"${seed}\"";

  static m33(comparison) => "Deve ser igual a \"${comparison}\"";

  static m34(value) => "\"${value}\" não é um booleano válido";

  static m35(value) => "\"${value}\" não é Base64 válido";

  static m36(noSymbols) => "Não é numérico";

  static m37(pattern) => "Não corresponde ao padrão: ${pattern}";

  static m38(min, max) => "Comprimento deve ser entre ${min} e ${max}";

  static m39(discrete) => "Comprimento deve ser um de: ${discrete}";

  static m40(score, minScore) => "Senha fraca (${score}/${minScore})";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(Object? _) => {
      'date_invalid': MessageLookupByLibrary.simpleMessage('Data inválida'),
    'date_time_field_after': m0,
    'date_time_field_after_inclusive': m1,
    'date_time_field_before': m2,
    'date_time_field_before_inclusive': m3,
    'number_field_not_divisible': m4,
    'number_field_not_negative': MessageLookupByLibrary.simpleMessage('Deve ser negativo'),
    'number_field_not_positive': MessageLookupByLibrary.simpleMessage('Deve ser positivo'),
    'number_field_value_too_big': m5,
    'number_field_value_too_small': m6,
    'required_field_label': MessageLookupByLibrary.simpleMessage('Campo obrigatório'),
    'validation_byte_length_exceeded': m7,
    'validation_invalid_base32': m8,
    'validation_invalid_base58': m9,
    'validation_invalid_credit_card': m10,
    'validation_invalid_ean': m11,
    'validation_invalid_email': m12,
    'validation_invalid_hash': m13,
    'validation_invalid_imei': m14,
    'validation_invalid_ip': m15,
    'validation_invalid_isbn': m16,
    'validation_invalid_json': m17,
    'validation_invalid_jwt': m18,
    'validation_invalid_lat_long': m19,
    'validation_invalid_locale': m20,
    'validation_invalid_mac_address': m21,
    'validation_invalid_mime_type': m22,
    'validation_invalid_mongo_id': m23,
    'validation_invalid_phone': m24,
    'validation_invalid_port': m25,
    'validation_invalid_postal_code': m26,
    'validation_invalid_semver': m27,
    'validation_invalid_slug': m28,
    'validation_invalid_time': m29,
    'validation_invalid_url': m30,
    'validation_invalid_uuid': m31,
    'validation_must_contain': m32,
    'validation_must_equal': m33,
    'validation_not_a_boolean': m34,
    'validation_not_a_number': MessageLookupByLibrary.simpleMessage('Não é um número válido'),
    'validation_not_alpha': MessageLookupByLibrary.simpleMessage('Não é alfabético'),
    'validation_not_alphanumeric': MessageLookupByLibrary.simpleMessage('Não é alfanumérico'),
    'validation_not_ascii': MessageLookupByLibrary.simpleMessage('Não é ASCII'),
    'validation_not_base64': m35,
    'validation_not_full_width': MessageLookupByLibrary.simpleMessage('Não é full-width'),
    'validation_not_half_width': MessageLookupByLibrary.simpleMessage('Não é half-width'),
    'validation_not_hexadecimal': MessageLookupByLibrary.simpleMessage('Não é hexadecimal'),
    'validation_not_in_list': MessageLookupByLibrary.simpleMessage('Valor não está na lista permitida'),
    'validation_not_lowercase': MessageLookupByLibrary.simpleMessage('Não está em minúsculas'),
    'validation_not_multibyte': MessageLookupByLibrary.simpleMessage('Não é multibyte'),
    'validation_not_numeric': m36,
    'validation_not_octal': MessageLookupByLibrary.simpleMessage('Não é octal válido'),
    'validation_not_surrogate_pair': MessageLookupByLibrary.simpleMessage('Não é surrogate pair'),
    'validation_not_uppercase': MessageLookupByLibrary.simpleMessage('Não está em maiúsculas'),
    'validation_not_variable_width': MessageLookupByLibrary.simpleMessage('Não é variable-width'),
    'validation_pattern_mismatch': m37,
    'validation_string_length_exceeded': m38,
    'validation_string_length_mismatch': m39,
    'validation_weak_password': m40
  };
}
