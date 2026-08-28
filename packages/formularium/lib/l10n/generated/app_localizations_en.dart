// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String date_time_field_before(String date) {
    return 'Must be before $date';
  }

  @override
  String date_time_field_after(String date) {
    return 'Must be after $date';
  }

  @override
  String date_time_field_before_inclusive(String date) {
    return 'Must be before or on $date';
  }

  @override
  String date_time_field_after_inclusive(String date) {
    return 'Must be after or on $date';
  }

  @override
  String number_field_value_too_big(String number) {
    return 'Value greater than $number';
  }

  @override
  String number_field_value_too_small(String number) {
    return 'Value less than $number';
  }

  @override
  String get validation_not_a_number => 'Not a valid number';

  @override
  String number_field_not_divisible(String divisor) {
    return 'Not divisible by $divisor';
  }

  @override
  String get number_field_not_positive => 'Must be positive';

  @override
  String get number_field_not_negative => 'Must be negative';

  @override
  String validation_not_a_boolean(String value) {
    return '\"$value\" is not a valid boolean';
  }

  @override
  String validation_invalid_port(String value) {
    return '\"$value\" is not a valid port';
  }

  @override
  String validation_invalid_url(String value) {
    return '\"$value\" is not a valid URL';
  }

  @override
  String validation_invalid_lat_long(String value) {
    return '\"$value\" is not a valid latitude/longitude';
  }

  @override
  String validation_invalid_email(String value) {
    return '\"$value\" is not a valid email';
  }

  @override
  String validation_invalid_uuid(String version) {
    return 'Invalid UUID $version';
  }

  @override
  String validation_invalid_semver(String value) {
    return '\"$value\" is not a valid semantic version';
  }

  @override
  String validation_invalid_jwt(String value) {
    return '\"$value\" is not a valid JWT';
  }

  @override
  String validation_invalid_slug(String value) {
    return '\"$value\" is not a valid slug';
  }

  @override
  String validation_not_base64(String value) {
    return '\"$value\" is not valid Base64';
  }

  @override
  String validation_invalid_mime_type(String value) {
    return '\"$value\" is not a valid MIME type';
  }

  @override
  String validation_invalid_locale(String value) {
    return '\"$value\" is not a valid locale';
  }

  @override
  String validation_invalid_credit_card(String provider) {
    return 'Invalid credit card $provider';
  }

  @override
  String validation_weak_password(int score, int minScore) {
    return 'Weak password ($score/$minScore)';
  }

  @override
  String validation_invalid_mongo_id(String value) {
    return '\"$value\" is not a valid MongoId';
  }

  @override
  String validation_invalid_hash(String algorithm) {
    return 'Invalid $algorithm hash';
  }

  @override
  String validation_invalid_imei(String value) {
    return '\"$value\" is not a valid IMEI';
  }

  @override
  String validation_invalid_phone(String value) {
    return '\"$value\" is not a valid phone number';
  }

  @override
  String validation_invalid_json(String value) {
    return '\"$value\" is not valid JSON';
  }

  @override
  String validation_invalid_mac_address(String value) {
    return '\"$value\" is not a valid MAC address';
  }

  @override
  String get validation_not_octal => 'Not valid octal';

  @override
  String validation_byte_length_exceeded(int min, int max) {
    return 'Byte length must be between $min and $max';
  }

  @override
  String get validation_not_multibyte => 'Not multibyte';

  @override
  String get validation_not_full_width => 'Not full-width';

  @override
  String get validation_not_half_width => 'Not half-width';

  @override
  String get validation_not_variable_width => 'Not variable-width';

  @override
  String get validation_not_surrogate_pair => 'Not a surrogate pair';

  @override
  String validation_invalid_ip(String value) {
    return '\"$value\" is not a valid IP address';
  }

  @override
  String validation_invalid_postal_code(String value) {
    return '\"$value\" is not a valid postal code';
  }

  @override
  String validation_invalid_isbn(String value) {
    return '\"$value\" is not a valid ISBN';
  }

  @override
  String validation_invalid_ean(String value) {
    return '\"$value\" is not a valid EAN';
  }

  @override
  String validation_invalid_base32(String value) {
    return '\"$value\" is not valid Base32';
  }

  @override
  String validation_invalid_base58(String value) {
    return '\"$value\" is not valid Base58';
  }

  @override
  String get validation_not_alphanumeric => 'Not alphanumeric';

  @override
  String get validation_not_alpha => 'Not alphabetic';

  @override
  String get validation_not_ascii => 'Not ASCII';

  @override
  String validation_not_numeric(bool noSymbols) {
    return 'Not numeric';
  }

  @override
  String get validation_not_hexadecimal => 'Not hexadecimal';

  @override
  String get validation_not_lowercase => 'Not lowercase';

  @override
  String get validation_not_uppercase => 'Not uppercase';

  @override
  String validation_string_length_exceeded(int min, int max) {
    return 'Length must be between $min and $max';
  }

  @override
  String validation_string_length_mismatch(List<int> discrete) {
    return 'Length must be one of: $discrete';
  }

  @override
  String validation_pattern_mismatch(String pattern) {
    return 'Does not match the pattern: $pattern';
  }

  @override
  String get validation_not_in_list => 'Value is not in the allowed list';

  @override
  String validation_must_contain(String seed) {
    return 'Must contain \"$seed\"';
  }

  @override
  String validation_must_equal(String comparison) {
    return 'Must be equal to \"$comparison\"';
  }

  @override
  String validation_invalid_time(String value, String hourFormat, String mode) {
    return '\"$value\" is not a valid time (format $hourFormat, mode $mode)';
  }

  @override
  String get date_invalid => 'Invalid date';

  @override
  String get required_field_label => 'Required field';
}
