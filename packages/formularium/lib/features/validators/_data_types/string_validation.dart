import 'package:concierge/context_interface.dart';
import 'package:formularium/features/localization/localizable_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

/// Classe base para tipos de erro de validação de string.
sealed class StringValidation implements ILocalizable {
  /// Cria uma instância de [StringValidation].
  const StringValidation();

  /// Cria um erro de validação [NotABoolean] para o [value] informado.
  static NotABoolean notABoolean(String value) => NotABoolean(value);

  /// Cria um erro de validação [InvalidPort] para o [value] informado.
  static InvalidPort invalidPort(String value) => InvalidPort(value);

  /// Cria um erro de validação [InvalidUrl] para o [value] informado.
  static InvalidUrl invalidUrl(String value) => InvalidUrl(value);

  /// Cria um erro de validação [InvalidLatLong] para o [value] informado.
  static InvalidLatLong invalidLatLong(String value) => InvalidLatLong(value);

  /// Cria um erro de validação [InvalidEmail] para o [value] informado.
  static InvalidEmail invalidEmail(String value) => InvalidEmail(value);

  /// Cria um erro de validação [InvalidUuid] para a [version] de UUID opcional informada.
  static InvalidUuid invalidUuid({String? version}) => InvalidUuid(version);

  /// Cria um erro de validação [InvalidSemVer] para o [value] informado.
  static InvalidSemVer invalidSemVer(String value) => InvalidSemVer(value);

  /// Cria um erro de validação [InvalidJwt] para o [value] informado.
  static InvalidJwt invalidJwt(String value) => InvalidJwt(value);

  /// Cria um erro de validação [InvalidSlug] para o [value] informado.
  static InvalidSlug invalidSlug(String value) => InvalidSlug(value);

  /// Cria um erro de validação [NotBase64] para o [value] informado.
  static NotBase64 notBase64(String value) => NotBase64(value);

  /// Cria um erro de validação [InvalidMimeType] para o [value] informado.
  static InvalidMimeType invalidMimeType(String value) => InvalidMimeType(value);

  /// Cria um erro de validação [InvalidLocale] para o [value] informado.
  static InvalidLocale invalidLocale(String value) => InvalidLocale(value);

  /// Cria um erro de validação [InvalidCreditCard] para o [provider] informado.
  static InvalidCreditCard invalidCreditCard({String? provider}) => InvalidCreditCard(provider);

  /// Cria um erro de validação [WeakPassword] com a [score] e [minScore] informadas.
  static WeakPassword weakPassword({
    required int score,
    required int minScore,
    required int minLength,
    required bool hasLength,
    required bool hasLowercase,
    required bool hasUppercase,
    required bool hasNumbers,
    required bool hasSymbols,
  }) => WeakPassword(
    score: score,
    minScore: minScore,
    minLength: minLength,
    hasLength: hasLength,
    hasLowercase: hasLowercase,
    hasUppercase: hasUppercase,
    hasNumbers: hasNumbers,
    hasSymbols: hasSymbols,
  );

  /// Cria um erro de validação [InvalidMongoId] para o [value] informado.
  static InvalidMongoId invalidMongoId(String value) => InvalidMongoId(value);

  /// Cria um erro de validação [InvalidHash] para o [algorithm] de hash informado.
  static InvalidHash invalidHash(String algorithm) => InvalidHash(algorithm);

  /// Cria um erro de validação [InvalidImei] para o [value] informado.
  static InvalidImei invalidImei(String value) => InvalidImei(value);

  /// Cria um erro de validação [InvalidPhone] para o [value] informado.
  static InvalidPhone invalidPhone(String value) => InvalidPhone(value);

  /// Cria um erro de validação [InvalidJson] para o [value] informado.
  static InvalidJson invalidJson(String value) => InvalidJson(value);

  /// Cria um erro de validação [InvalidMacAddress] para o [value] informado.
  static InvalidMacAddress invalidMacAddress(String value) => InvalidMacAddress(value);

  /// Cria um erro de validação [NotOctal].
  static NotOctal notOctal() => const NotOctal();

  /// Cria um erro de validação [ByteLengthExceeded] com limites [min] e [max] opcionais.
  static ByteLengthExceeded byteLengthExceeded({int? min, int? max}) => ByteLengthExceeded(min, max);

  /// Cria um erro de validação [NotMultibyte].
  static NotMultibyte notMultibyte() => const NotMultibyte();

  /// Cria um erro de validação [NotFullWidth].
  static NotFullWidth notFullWidth() => const NotFullWidth();

  /// Cria um erro de validação [NotHalfWidth].
  static NotHalfWidth notHalfWidth() => const NotHalfWidth();

  /// Cria um erro de validação [NotVariableWidth].
  static NotVariableWidth notVariableWidth() => const NotVariableWidth();

  /// Cria um erro de validação [NotSurrogatePair].
  static NotSurrogatePair notSurrogatePair() => const NotSurrogatePair();

  /// Cria um erro de validação [InvalidIp] para o [value] informado.
  static InvalidIp invalidIp(String value) => InvalidIp(value);

  /// Cria um erro de validação [InvalidPostalCode] para o [value] informado.
  static InvalidPostalCode invalidPostalCode(String value) => InvalidPostalCode(value);

  /// Cria um erro de validação [InvalidIsbn] para o [value] informado.
  static InvalidIsbn invalidIsbn(String value) => InvalidIsbn(value);

  /// Cria um erro de validação [InvalidEan] para o [value] informado.
  static InvalidEan invalidEan(String value) => InvalidEan(value);

  /// Cria um erro de validação [InvalidBase32] para o [value] informado.
  static InvalidBase32 invalidBase32(String value) => InvalidBase32(value);

  /// Cria um erro de validação [InvalidBase58] para o [value] informado.
  static InvalidBase58 invalidBase58(String value) => InvalidBase58(value);

  /// Cria um erro de validação [NotAlphanumeric].
  static NotAlphanumeric notAlphanumeric() => const NotAlphanumeric();

  /// Cria um erro de validação [NotAlpha].
  static NotAlpha notAlpha() => const NotAlpha();

  /// Cria um erro de validação [NotAscii].
  static NotAscii notAscii() => const NotAscii();

  /// Cria um erro de validação [NotNumeric], opcionalmente ignorando símbolos.
  static NotNumeric notNumeric({bool noSymbols = false}) => NotNumeric(noSymbols);

  /// Cria um erro de validação [NotHexadecimal].
  static NotHexadecimal notHexadecimal() => const NotHexadecimal();

  /// Cria um erro de validação [NotLowercase].
  static NotLowercase notLowercase() => const NotLowercase();

  /// Cria um erro de validação [NotUppercase].
  static NotUppercase notUppercase() => const NotUppercase();

  /// Cria um erro de validação [StringLengthExceeded] com limites [min] e [max] opcionais.
  static StringLengthExceeded stringLengthExceeded({int? min, int? max}) => StringLengthExceeded(min, max);

  /// Cria um erro de validação [StringLengthMismatch] para os comprimentos [discrete] informados.
  static StringLengthMismatch stringLengthMismatch(List<int> discrete) => StringLengthMismatch(discrete);

  /// Cria um erro de validação [PatternMismatch] para o [pattern] informado.
  static PatternMismatch patternMismatch(String pattern) => PatternMismatch(pattern);

  /// Cria um erro de validação [NotInList].
  static NotInList notInList() => const NotInList();

  /// Cria um erro de validação [MustContain] que exige que [seed] esteja presente.
  static MustContain mustContain(String seed) => MustContain(seed);

  /// Cria um erro de validação [MustEqual] que exige que o valor seja igual a [comparison].
  static MustEqual mustEqual(String comparison) => MustEqual(comparison);
}

/// Erro de validação indicando que [value] não é um booleano válido.
class NotABoolean extends StringValidation {
  /// Cria um erro de validação [NotABoolean].
  NotABoolean(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_a_boolean(value);
}

/// Erro de validação indicando que [value] não é um número de porta válido.
class InvalidPort extends StringValidation {
  /// Cria um erro de validação [InvalidPort].
  InvalidPort(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_port(value);
}

/// Erro de validação indicando que [value] não é uma URL válida.
class InvalidUrl extends StringValidation {
  /// Cria um erro de validação [InvalidUrl].
  InvalidUrl(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_url(value);
}

/// Erro de validação indicando que [value] não é um par de latitude/longitude válido.
class InvalidLatLong extends StringValidation {
  /// Cria um erro de validação [InvalidLatLong].
  InvalidLatLong(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_lat_long(value);
}

/// Erro de validação indicando que [value] não é um endereço de email válido.
class InvalidEmail extends StringValidation {
  /// Cria um erro de validação [InvalidEmail].
  InvalidEmail(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_email(value);
}

/// Erro de validação indicando que [version] não é um UUID válido.
class InvalidUuid extends StringValidation {
  /// Cria um erro de validação [InvalidUuid].
  InvalidUuid(this.version);

  /// A restrição de versão de UUID opcional.
  final String? version;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_uuid(version);
}

/// Erro de validação indicando que [value] não é uma string de versão semântica válida.
class InvalidSemVer extends StringValidation {
  /// Cria um erro de validação [InvalidSemVer].
  InvalidSemVer(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_semver(value);
}

/// Erro de validação indicando que [value] não é um JWT válido.
class InvalidJwt extends StringValidation {
  /// Cria um erro de validação [InvalidJwt].
  InvalidJwt(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_jwt(value);
}

/// Erro de validação indicando que [value] não é um slug de URL válido.
class InvalidSlug extends StringValidation {
  /// Cria um erro de validação [InvalidSlug].
  InvalidSlug(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_slug(value);
}

/// Erro de validação indicando que [value] não é um dado Base64 válido.
class NotBase64 extends StringValidation {
  /// Cria um erro de validação [NotBase64].
  NotBase64(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_base64(value);
}

/// Erro de validação indicando que [value] não é um tipo MIME válido.
class InvalidMimeType extends StringValidation {
  /// Cria um erro de validação [InvalidMimeType].
  InvalidMimeType(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_mime_type(value);
}

/// Erro de validação indicando que [value] não é uma locale válida.
class InvalidLocale extends StringValidation {
  /// Cria um erro de validação [InvalidLocale].
  InvalidLocale(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_locale(value);
}

/// Erro de validação indicando que o valor não é um número de cartão de crédito válido
/// para o [provider] informado.
class InvalidCreditCard extends StringValidation {
  /// Cria um erro de validação [InvalidCreditCard].
  InvalidCreditCard(this.provider);

  /// A restrição de bandeira do cartão de crédito opcional.
  final String? provider;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_credit_card(provider);
}

/// Erro de validação indicando uma senha fraca com a [score] informada
/// abaixo da [minScore] exigida.
class WeakPassword extends StringValidation {
  /// Cria um erro de validação [WeakPassword].
  WeakPassword({
    required this.score,
    required this.minScore,
    required this.minLength,
    required this.hasLength,
    required this.hasLowercase,
    required this.hasUppercase,
    required this.hasNumbers,
    required this.hasSymbols,
  });

  /// A pontuação real de força da senha.
  final int score;

  /// A pontuação mínima de força exigida.
  final int minScore;

  /// Comprimento mínimo exigido.
  final int minLength;

  /// Se o comprimento mínimo foi atingido.
  final bool hasLength;

  /// Se contém pelo menos uma letra minúscula.
  final bool hasLowercase;

  /// Se contém pelo menos uma letra maiúscula.
  final bool hasUppercase;

  /// Se contém pelo menos um número.
  final bool hasNumbers;

  /// Se contém pelo menos um símbolo.
  final bool hasSymbols;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_weak_password(score, minScore);
}

/// Erro de validação indicando que [value] não é um ObjectId do MongoDB válido.
class InvalidMongoId extends StringValidation {
  /// Cria um erro de validação [InvalidMongoId].
  InvalidMongoId(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_mongo_id(value);
}

/// Erro de validação indicando que o valor não é um hash válido para o
/// [algorithm] informado.
class InvalidHash extends StringValidation {
  /// Cria um erro de validação [InvalidHash].
  InvalidHash(this.algorithm);

  /// O algoritmo de hash que era esperado.
  final String algorithm;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_hash(algorithm);
}

/// Erro de validação indicando que [value] não é um número IMEI válido.
class InvalidImei extends StringValidation {
  /// Cria um erro de validação [InvalidImei].
  InvalidImei(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_imei(value);
}

/// Erro de validação indicando que [value] não é um número de telefone válido.
class InvalidPhone extends StringValidation {
  /// Cria um erro de validação [InvalidPhone].
  InvalidPhone(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_phone(value);
}

/// Erro de validação indicando que [value] não é um JSON válido.
class InvalidJson extends StringValidation {
  /// Cria um erro de validação [InvalidJson].
  InvalidJson(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_json(value);
}

/// Erro de validação indicando que [value] não é um endereço MAC válido.
class InvalidMacAddress extends StringValidation {
  /// Cria um erro de validação [InvalidMacAddress].
  InvalidMacAddress(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_mac_address(value);
}

/// Erro de validação indicando que o valor não é um octal válido.
class NotOctal extends StringValidation {
  /// Cria um erro de validação [NotOctal].
  const NotOctal();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_octal;
}

/// Erro de validação indicando que o comprimento em bytes excede os limites.
class ByteLengthExceeded extends StringValidation {
  /// Cria um erro de validação [ByteLengthExceeded].
  ByteLengthExceeded(this.min, this.max);

  /// O limite mínimo de comprimento em bytes opcional.
  final int? min;

  /// O limite máximo de comprimento em bytes opcional.
  final int? max;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_byte_length_exceeded(min, max);
}

/// Erro de validação indicando que o valor não é texto multibyte.
class NotMultibyte extends StringValidation {
  /// Cria um erro de validação [NotMultibyte].
  const NotMultibyte();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_multibyte;
}

/// Erro de validação indicando que o valor não é texto full-width.
class NotFullWidth extends StringValidation {
  /// Cria um erro de validação [NotFullWidth].
  const NotFullWidth();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_full_width;
}

/// Erro de validação indicando que o valor não é texto half-width.
class NotHalfWidth extends StringValidation {
  /// Cria um erro de validação [NotHalfWidth].
  const NotHalfWidth();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_half_width;
}

/// Erro de validação indicando que o valor não é texto variable-width.
class NotVariableWidth extends StringValidation {
  /// Cria um erro de validação [NotVariableWidth].
  const NotVariableWidth();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_variable_width;
}

/// Erro de validação indicando que o valor não é um par substituto (surrogate pair).
class NotSurrogatePair extends StringValidation {
  /// Cria um erro de validação [NotSurrogatePair].
  const NotSurrogatePair();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_surrogate_pair;
}

/// Erro de validação indicando que [value] não é um endereço IP válido.
class InvalidIp extends StringValidation {
  /// Cria um erro de validação [InvalidIp].
  InvalidIp(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_ip(value);
}

/// Erro de validação indicando que [value] não é um código postal válido.
class InvalidPostalCode extends StringValidation {
  /// Cria um erro de validação [InvalidPostalCode].
  InvalidPostalCode(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_postal_code(value);
}

/// Erro de validação indicando que [value] não é um ISBN válido.
class InvalidIsbn extends StringValidation {
  /// Cria um erro de validação [InvalidIsbn].
  InvalidIsbn(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_isbn(value);
}

/// Erro de validação indicando que [value] não é um EAN válido.
class InvalidEan extends StringValidation {
  /// Cria um erro de validação [InvalidEan].
  InvalidEan(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_ean(value);
}

/// Erro de validação indicando que [value] não é um dado Base32 válido.
class InvalidBase32 extends StringValidation {
  /// Cria um erro de validação [InvalidBase32].
  InvalidBase32(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_base32(value);
}

/// Erro de validação indicando que [value] não é um dado Base58 válido.
class InvalidBase58 extends StringValidation {
  /// Cria um erro de validação [InvalidBase58].
  InvalidBase58(this.value);

  /// O valor da string que falhou na validação.
  final String value;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_base58(value);
}

/// Erro de validação indicando que o valor não é alfanumérico.
class NotAlphanumeric extends StringValidation {
  /// Cria um erro de validação [NotAlphanumeric].
  const NotAlphanumeric();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_alphanumeric;
}

/// Erro de validação indicando que o valor não é alfabético.
class NotAlpha extends StringValidation {
  /// Cria um erro de validação [NotAlpha].
  const NotAlpha();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_alpha;
}

/// Erro de validação indicando que o valor não é texto ASCII.
class NotAscii extends StringValidation {
  /// Cria um erro de validação [NotAscii].
  const NotAscii();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_ascii;
}

/// Erro de validação indicando que o valor não é numérico.
class NotNumeric extends StringValidation {
  /// Cria um erro de validação [NotNumeric].
  NotNumeric(this.noSymbols);

  /// Se os símbolos devem ser ignorados durante a validação.
  final bool noSymbols;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_numeric(noSymbols);
}

/// Erro de validação indicando que o valor não é uma string hexadecimal.
class NotHexadecimal extends StringValidation {
  /// Cria um erro de validação [NotHexadecimal].
  const NotHexadecimal();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_hexadecimal;
}

/// Erro de validação indicando que o valor não está em minúsculas.
class NotLowercase extends StringValidation {
  /// Cria um erro de validação [NotLowercase].
  const NotLowercase();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_lowercase;
}

/// Erro de validação indicando que o valor não está em maiúsculas.
class NotUppercase extends StringValidation {
  /// Cria um erro de validação [NotUppercase].
  const NotUppercase();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_uppercase;
}

/// Erro de validação indicando que o comprimento da string excede o intervalo permitido.
class StringLengthExceeded extends StringValidation {
  /// Cria um erro de validação [StringLengthExceeded].
  StringLengthExceeded(this.min, this.max);

  /// O limite mínimo de comprimento opcional.
  final int? min;

  /// O limite máximo de comprimento opcional.
  final int? max;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_string_length_exceeded(min, max);
}

/// Erro de validação indicando que o comprimento da string não corresponde a nenhum
/// dos comprimentos [discrete] permitidos.
class StringLengthMismatch extends StringValidation {
  /// Cria um erro de validação [StringLengthMismatch].
  StringLengthMismatch(this.discrete);

  /// A lista de comprimentos discretos permitidos.
  final List<int> discrete;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_string_length_mismatch(discrete);
}

/// Erro de validação indicando que o valor não corresponde ao [pattern] informado.
class PatternMismatch extends StringValidation {
  /// Cria um erro de validação [PatternMismatch].
  PatternMismatch(this.pattern);

  /// O padrão esperado que não foi correspondido.
  final String pattern;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_pattern_mismatch(pattern);
}

/// Erro de validação indicando que o valor não está na lista esperada.
class NotInList extends StringValidation {
  /// Cria um erro de validação [NotInList].
  const NotInList();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_not_in_list;
}

/// Erro de validação indicando que o valor deve conter o [seed] informado.
class MustContain extends StringValidation {
  /// Cria um erro de validação [MustContain].
  MustContain(this.seed);

  /// A substring que deve estar presente no valor.
  final String seed;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_must_contain(seed);
}

/// Erro de validação indicando que o valor deve ser igual ao [comparison] informado.
class MustEqual extends StringValidation {
  /// Cria um erro de validação [MustEqual].
  MustEqual(this.comparison);

  /// O valor esperado que deve ser correspondido exatamente.
  final String comparison;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_must_equal(comparison);
}
