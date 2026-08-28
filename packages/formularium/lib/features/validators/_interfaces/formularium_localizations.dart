import 'package:concierge/context_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:formularium/l10n/generated/app_localizations.dart';

/// Interface para mensagens localizadas de validação de formulário.
///
/// Fornece mensagens legíveis para cada regra de validação que pode falhar.
abstract interface class IFormulariumLocalizations {
  /// Mensagem de validação para uma data que deve ser anterior a [date].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String date_time_field_before(String date);

  /// Mensagem de validação para uma data que deve ser posterior a [date].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String date_time_field_after(String date);

  /// Mensagem de validação para uma data que deve ser anterior ou igual a [date].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String date_time_field_before_inclusive(String date);

  /// Mensagem de validação para uma data que deve ser posterior ou igual a [date].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String date_time_field_after_inclusive(String date);

  /// Mensagem de validação para um número grande demais (maior que [number]).
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String number_field_value_too_big(String number);

  /// Mensagem de validação para um número pequeno demais (menor que [number]).
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String number_field_value_too_small(String number);

  /// Mensagem de validação quando a entrada não é um número.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_a_number;

  /// Mensagem de validação quando a entrada [value] não é um booleano.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_not_a_boolean(String value);

  /// Mensagem de validação quando a entrada [value] não é um número de porta válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_port(String value);

  /// Mensagem de validação quando a entrada [value] não é uma URL válida.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_url(String value);

  /// Mensagem de validação quando a entrada [value] não é um par latitude/longitude válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_lat_long(String value);

  /// Mensagem de validação quando a entrada [value] não é um endereço de e-mail válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_email(String value);

  /// Mensagem de validação quando a entrada não é um UUID válido.
  /// [version] especifica opcionalmente a versão do UUID esperada.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_uuid(String? version);

  /// Mensagem de validação quando a entrada [value] não é uma versão semântica válida.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_semver(String value);

  /// Mensagem de validação quando a entrada [value] não é um JWT válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_jwt(String value);

  /// Mensagem de validação quando a entrada [value] não é um slug válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_slug(String value);

  /// Mensagem de validação quando a entrada [value] não é Base64 válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_not_base64(String value);

  /// Mensagem de validação quando a entrada [value] não é um tipo MIME válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_mime_type(String value);

  /// Mensagem de validação quando a entrada [value] não é um identificador de localidade válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_locale(String value);

  /// Mensagem de validação quando a entrada não é um número de cartão de crédito válido.
  /// [provider] especifica opcionalmente a bandeira do cartão esperada.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_credit_card(String? provider);

  /// Mensagem de validação quando a pontuação da senha [score] está abaixo de [minScore].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_weak_password(int score, int minScore);

  /// Mensagem de validação quando a entrada [value] não é um ObjectId do MongoDB válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_mongo_id(String value);

  /// Mensagem de validação quando a entrada não é um hash válido do [algorithm] esperado.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_hash(String algorithm);

  /// Mensagem de validação quando a entrada [value] não é um IMEI válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_imei(String value);

  /// Mensagem de validação quando a entrada [value] não é um número de telefone válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_phone(String value);

  /// Mensagem de validação quando a entrada [value] não é JSON válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_json(String value);

  /// Mensagem de validação quando a entrada [value] não é um endereço MAC válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_mac_address(String value);

  /// Mensagem de validação quando a entrada não é um número octal válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_octal;

  /// Mensagem de validação quando o comprimento em bytes da entrada excede [min] ou [max].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_byte_length_exceeded(int? min, int? max);

  /// Mensagem de validação quando a entrada não é uma string multibyte.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_multibyte;

  /// Mensagem de validação quando a entrada não é full-width.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_full_width;

  /// Mensagem de validação quando a entrada não é half-width.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_half_width;

  /// Mensagem de validação quando a entrada não é variable-width.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_variable_width;

  /// Mensagem de validação quando a entrada não é um par substituto.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_surrogate_pair;

  /// Mensagem de validação quando a entrada [value] não é um endereço IP válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_ip(String value);

  /// Mensagem de validação quando a entrada [value] não é um código postal válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_postal_code(String value);

  /// Mensagem de validação quando a entrada [value] não é um ISBN válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_isbn(String value);

  /// Mensagem de validação quando a entrada [value] não é um EAN válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_ean(String value);

  /// Mensagem de validação quando a entrada [value] não é Base32 válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_base32(String value);

  /// Mensagem de validação quando a entrada [value] não é Base58 válido.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_base58(String value);

  /// Mensagem de validação quando a entrada não é alfanumérica.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_alphanumeric;

  /// Mensagem de validação quando a entrada não é alfabética.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_alpha;

  /// Mensagem de validação quando a entrada não é ASCII.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_ascii;

  /// Mensagem de validação quando a entrada não é numérica.
  /// Se [noSymbols] for true, símbolos não são permitidos.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_not_numeric(bool noSymbols);

  /// Mensagem de validação quando a entrada não é hexadecimal.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_hexadecimal;

  /// Mensagem de validação quando a entrada não está em minúsculas.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_lowercase;

  /// Mensagem de validação quando a entrada não está em maiúsculas.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_uppercase;

  /// Mensagem de validação quando o comprimento da string excede os limites de [min] ou [max].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_string_length_exceeded(int? min, int? max);

  /// Mensagem de validação quando o comprimento da string não corresponde a nenhum dos comprimentos [discrete].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_string_length_mismatch(List<int> discrete);

  /// Mensagem de validação quando a entrada não corresponde ao [pattern].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_pattern_mismatch(String pattern);

  /// Mensagem de validação quando a entrada não está em uma lista esperada.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get validation_not_in_list;

  /// Mensagem de validação quando a entrada não contém [seed].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_must_contain(String seed);

  /// Mensagem de validação quando a entrada não é igual a [comparison].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_must_equal(String comparison);

  /// Mensagem de validação quando a entrada [value] não é um horário válido usando [hourFormat] e [mode].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_time(String value, String hourFormat, String mode);

  /// Mensagem de validação quando o número não é divisível por [divisor].
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String number_field_not_divisible(String divisor);

  /// Mensagem de validação quando o número não é positivo.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get number_field_not_positive;

  /// Mensagem de validação quando o número não é negativo.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get number_field_not_negative;

  /// Mensagem de validação quando a entrada não é uma data válida.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get date_invalid;

  /// Rótulo para campos obrigatórios.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String get required_field_label;

  /// O nome da localidade usado para formatação de data/número (ex.: 'en_US').
  String get localeName;
}

/// Exposição das localizações do formulário a partir de um [IContext].
///
/// Permite que validações em Dart puro acessem as mensagens via
/// `context.fL10n.<mensagem>` sem depender de BuildContext.
extension FormulariumL10n on IContext {
  /// Recupera o [IFormulariumLocalizations] registrado neste [IContext].
  IFormulariumLocalizations get fL10n => get<IFormulariumLocalizations>();
}

/// Ponte padrão que expõe o [AppLocalizations] gerado por gen-l10n
/// sob o contrato [IFormulariumLocalizations].
///
/// Permite manter a possibilidade de o consumidor fornecer suas próprias
/// localizações (implementando [IFormulariumLocalizations]) ao mesmo tempo que
/// oferece uma implementação default baseada nos ARBs do pacote.
class FormulariumLocalizations implements IFormulariumLocalizations {
  /// Cria uma ponte sobre a instância gerada [app].
  const FormulariumLocalizations(this._app);

  final AppLocalizations _app;

  /// Delegate padrão para uso em `MaterialApp.localizationsDelegates`.
  static const LocalizationsDelegate<FormulariumLocalizations> delegate =
      _FormulariumLocalizationsDelegate();

  /// Obtém as localizações do [context] embrulhadas na ponte.
  static FormulariumLocalizations of(BuildContext context) =>
      FormulariumLocalizations(AppLocalizations.of(context));

  @override
  String date_time_field_before(String date) => _app.date_time_field_before(date);

  @override
  String date_time_field_after(String date) => _app.date_time_field_after(date);

  @override
  String date_time_field_before_inclusive(String date) =>
      _app.date_time_field_before_inclusive(date);

  @override
  String date_time_field_after_inclusive(String date) =>
      _app.date_time_field_after_inclusive(date);

  @override
  String number_field_value_too_big(String number) =>
      _app.number_field_value_too_big(number);

  @override
  String number_field_value_too_small(String number) =>
      _app.number_field_value_too_small(number);

  @override
  String get validation_not_a_number => _app.validation_not_a_number;

  @override
  String validation_not_a_boolean(String value) =>
      _app.validation_not_a_boolean(value);

  @override
  String validation_invalid_port(String value) => _app.validation_invalid_port(value);

  @override
  String validation_invalid_url(String value) => _app.validation_invalid_url(value);

  @override
  String validation_invalid_lat_long(String value) =>
      _app.validation_invalid_lat_long(value);

  @override
  String validation_invalid_email(String value) => _app.validation_invalid_email(value);

  @override
  String validation_invalid_uuid(String? version) =>
      _app.validation_invalid_uuid(version ?? '');

  @override
  String validation_invalid_semver(String value) =>
      _app.validation_invalid_semver(value);

  @override
  String validation_invalid_jwt(String value) => _app.validation_invalid_jwt(value);

  @override
  String validation_invalid_slug(String value) => _app.validation_invalid_slug(value);

  @override
  String validation_not_base64(String value) => _app.validation_not_base64(value);

  @override
  String validation_invalid_mime_type(String value) =>
      _app.validation_invalid_mime_type(value);

  @override
  String validation_invalid_locale(String value) =>
      _app.validation_invalid_locale(value);

  @override
  String validation_invalid_credit_card(String? provider) =>
      _app.validation_invalid_credit_card(provider ?? '');

  @override
  String validation_weak_password(int score, int minScore) =>
      _app.validation_weak_password(score, minScore);

  @override
  String validation_invalid_mongo_id(String value) =>
      _app.validation_invalid_mongo_id(value);

  @override
  String validation_invalid_hash(String algorithm) =>
      _app.validation_invalid_hash(algorithm);

  @override
  String validation_invalid_imei(String value) => _app.validation_invalid_imei(value);

  @override
  String validation_invalid_phone(String value) =>
      _app.validation_invalid_phone(value);

  @override
  String validation_invalid_json(String value) => _app.validation_invalid_json(value);

  @override
  String validation_invalid_mac_address(String value) =>
      _app.validation_invalid_mac_address(value);

  @override
  String get validation_not_octal => _app.validation_not_octal;

  @override
  String validation_byte_length_exceeded(int? min, int? max) =>
      _app.validation_byte_length_exceeded(min ?? 0, max ?? 0);

  @override
  String get validation_not_multibyte => _app.validation_not_multibyte;

  @override
  String get validation_not_full_width => _app.validation_not_full_width;

  @override
  String get validation_not_half_width => _app.validation_not_half_width;

  @override
  String get validation_not_variable_width => _app.validation_not_variable_width;

  @override
  String get validation_not_surrogate_pair => _app.validation_not_surrogate_pair;

  @override
  String validation_invalid_ip(String value) => _app.validation_invalid_ip(value);

  @override
  String validation_invalid_postal_code(String value) =>
      _app.validation_invalid_postal_code(value);

  @override
  String validation_invalid_isbn(String value) => _app.validation_invalid_isbn(value);

  @override
  String validation_invalid_ean(String value) => _app.validation_invalid_ean(value);

  @override
  String validation_invalid_base32(String value) =>
      _app.validation_invalid_base32(value);

  @override
  String validation_invalid_base58(String value) =>
      _app.validation_invalid_base58(value);

  @override
  String get validation_not_alphanumeric => _app.validation_not_alphanumeric;

  @override
  String get validation_not_alpha => _app.validation_not_alpha;

  @override
  String get validation_not_ascii => _app.validation_not_ascii;

  @override
  String validation_not_numeric(bool noSymbols) =>
      _app.validation_not_numeric(noSymbols);

  @override
  String get validation_not_hexadecimal => _app.validation_not_hexadecimal;

  @override
  String get validation_not_lowercase => _app.validation_not_lowercase;

  @override
  String get validation_not_uppercase => _app.validation_not_uppercase;

  @override
  String validation_string_length_exceeded(int? min, int? max) =>
      _app.validation_string_length_exceeded(min ?? 0, max ?? 0);

  @override
  String validation_string_length_mismatch(List<int> discrete) =>
      _app.validation_string_length_mismatch(discrete);

  @override
  String validation_pattern_mismatch(String pattern) =>
      _app.validation_pattern_mismatch(pattern);

  @override
  String get validation_not_in_list => _app.validation_not_in_list;

  @override
  String validation_must_contain(String seed) => _app.validation_must_contain(seed);

  @override
  String validation_must_equal(String comparison) =>
      _app.validation_must_equal(comparison);

  @override
  String validation_invalid_time(String value, String hourFormat, String mode) =>
      _app.validation_invalid_time(value, hourFormat, mode);

  @override
  String number_field_not_divisible(String divisor) =>
      _app.number_field_not_divisible(divisor);

  @override
  String get number_field_not_positive => _app.number_field_not_positive;

  @override
  String get number_field_not_negative => _app.number_field_not_negative;

  @override
  String get date_invalid => _app.date_invalid;

  @override
  String get required_field_label => _app.required_field_label;

  @override
  String get localeName => _app.localeName;
}

/// Delegate que carrega um [FormulariumLocalizations] embrulhando o
/// [AppLocalizations] gerado.
class _FormulariumLocalizationsDelegate
    extends LocalizationsDelegate<FormulariumLocalizations> {
  const _FormulariumLocalizationsDelegate();

  @override
  Future<FormulariumLocalizations> load(Locale locale) async =>
      FormulariumLocalizations(await AppLocalizations.delegate.load(locale));

  @override
  bool isSupported(Locale locale) => AppLocalizations.delegate.isSupported(locale);

  @override
  bool shouldReload(_FormulariumLocalizationsDelegate old) => false;
}