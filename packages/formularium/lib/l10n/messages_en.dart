// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(date) => "Must be after ${date}";

  static m1(date) => "Must be after or on ${date}";

  static m2(date) => "Must be before ${date}";

  static m3(date) => "Must be before or on ${date}";

  static m4(divisor) => "Not divisible by ${divisor}";

  static m5(number) => "Value greater than ${number}";

  static m6(number) => "Value less than ${number}";

  static m7(min, max) => "Byte length must be between ${min} and ${max}";

  static m8(value) => "\"${value}\" is not valid Base32";

  static m9(value) => "\"${value}\" is not valid Base58";

  static m10(provider) => "Invalid credit card ${provider}";

  static m11(value) => "\"${value}\" is not a valid EAN";

  static m12(value) => "\"${value}\" is not a valid email";

  static m13(algorithm) => "Invalid ${algorithm} hash";

  static m14(value) => "\"${value}\" is not a valid IMEI";

  static m15(value) => "\"${value}\" is not a valid IP address";

  static m16(value) => "\"${value}\" is not a valid ISBN";

  static m17(value) => "\"${value}\" is not valid JSON";

  static m18(value) => "\"${value}\" is not a valid JWT";

  static m19(value) => "\"${value}\" is not a valid latitude/longitude";

  static m20(value) => "\"${value}\" is not a valid locale";

  static m21(value) => "\"${value}\" is not a valid MAC address";

  static m22(value) => "\"${value}\" is not a valid MIME type";

  static m23(value) => "\"${value}\" is not a valid MongoId";

  static m24(value) => "\"${value}\" is not a valid phone number";

  static m25(value) => "\"${value}\" is not a valid port";

  static m26(value) => "\"${value}\" is not a valid postal code";

  static m27(value) => "\"${value}\" is not a valid semantic version";

  static m28(value) => "\"${value}\" is not a valid slug";

  static m29(value, hourFormat, mode) => "\"${value}\" is not a valid time (format ${hourFormat}, mode ${mode})";

  static m30(value) => "\"${value}\" is not a valid URL";

  static m31(version) => "Invalid UUID ${version}";

  static m32(seed) => "Must contain \"${seed}\"";

  static m33(comparison) => "Must be equal to \"${comparison}\"";

  static m34(value) => "\"${value}\" is not a valid boolean";

  static m35(value) => "\"${value}\" is not valid Base64";

  static m36(noSymbols) => "Not numeric";

  static m37(pattern) => "Does not match the pattern: ${pattern}";

  static m38(min, max) => "Length must be between ${min} and ${max}";

  static m39(discrete) => "Length must be one of: ${discrete}";

  static m40(score, minScore) => "Weak password (${score}/${minScore})";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(Object? _) => {
      'date_invalid': MessageLookupByLibrary.simpleMessage('Invalid date'),
    'date_time_field_after': m0,
    'date_time_field_after_inclusive': m1,
    'date_time_field_before': m2,
    'date_time_field_before_inclusive': m3,
    'number_field_not_divisible': m4,
    'number_field_not_negative': MessageLookupByLibrary.simpleMessage('Must be negative'),
    'number_field_not_positive': MessageLookupByLibrary.simpleMessage('Must be positive'),
    'number_field_value_too_big': m5,
    'number_field_value_too_small': m6,
    'required_field_label': MessageLookupByLibrary.simpleMessage('Required field'),
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
    'validation_not_a_number': MessageLookupByLibrary.simpleMessage('Not a valid number'),
    'validation_not_alpha': MessageLookupByLibrary.simpleMessage('Not alphabetic'),
    'validation_not_alphanumeric': MessageLookupByLibrary.simpleMessage('Not alphanumeric'),
    'validation_not_ascii': MessageLookupByLibrary.simpleMessage('Not ASCII'),
    'validation_not_base64': m35,
    'validation_not_full_width': MessageLookupByLibrary.simpleMessage('Not full-width'),
    'validation_not_half_width': MessageLookupByLibrary.simpleMessage('Not half-width'),
    'validation_not_hexadecimal': MessageLookupByLibrary.simpleMessage('Not hexadecimal'),
    'validation_not_in_list': MessageLookupByLibrary.simpleMessage('Value is not in the allowed list'),
    'validation_not_lowercase': MessageLookupByLibrary.simpleMessage('Not lowercase'),
    'validation_not_multibyte': MessageLookupByLibrary.simpleMessage('Not multibyte'),
    'validation_not_numeric': m36,
    'validation_not_octal': MessageLookupByLibrary.simpleMessage('Not valid octal'),
    'validation_not_surrogate_pair': MessageLookupByLibrary.simpleMessage('Not a surrogate pair'),
    'validation_not_uppercase': MessageLookupByLibrary.simpleMessage('Not uppercase'),
    'validation_not_variable_width': MessageLookupByLibrary.simpleMessage('Not variable-width'),
    'validation_pattern_mismatch': m37,
    'validation_string_length_exceeded': m38,
    'validation_string_length_mismatch': m39,
    'validation_weak_password': m40
  };
}
