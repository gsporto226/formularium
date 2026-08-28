import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_validators/string_base_encoding_validators.dart';
import 'package:formularium/features/validators/_validators/string_character_validators.dart';
import 'package:formularium/features/validators/_validators/string_constraint_validators.dart';
import 'package:formularium/features/validators/_validators/string_converters.dart';
import 'package:formularium/features/validators/_validators/string_credit_card_validator.dart';
import 'package:formularium/features/validators/_validators/string_ean_validator.dart';
import 'package:formularium/features/validators/_validators/string_email_validator.dart';
import 'package:formularium/features/validators/_validators/string_format_validators.dart';
import 'package:formularium/features/validators/_validators/string_ip_validator.dart';
import 'package:formularium/features/validators/_validators/string_isbn_validator.dart';
import 'package:formularium/features/validators/_validators/string_latlong_validator.dart';
import 'package:formularium/features/validators/_validators/string_password_validator.dart';
import 'package:formularium/features/validators/_validators/string_phone_validator.dart' show isMobilePhoneValidator;
import 'package:formularium/features/validators/_validators/string_postal_code_validator.dart'
    show isPostalCodeValidator;
import 'package:formularium/features/validators/_validators/string_sanitizers.dart';
import 'package:formularium/features/validators/_validators/string_simple_validators.dart';
import 'package:formularium/features/validators/_validators/string_url_validator.dart';
import 'package:formularium/features/validators/_validators/string_uuid_validator.dart';

/// Fachada que fornece uma API unificada para todos os validadores de string.
///
/// Cada método delega para uma implementação focada em um subarquivo organizado
/// por categoria de validador:
/// - [Conversores](string_converters.dart): notEmpty, asInt, asDouble, asBool, asPort
/// - [UUID](string_uuid_validator.dart): isUUID
/// - [Email](string_email_validator.dart): isEmail
/// - [Telefone](string_phone_validator.dart): isMobilePhone
/// - [Cartão de Crédito](string_credit_card_validator.dart): isCreditCard, isIMEI
/// - [Senha](string_password_validator.dart): isStrongPassword
/// - [Rede](string_url_validator.dart, string_ip_validator.dart, string_simple_validators.dart): isURL, isIP, isMACAddress
/// - [Dígito Verificador](string_isbn_validator.dart, string_ean_validator.dart): isISBN, isEAN
/// - [Codificação](string_format_validators.dart, string_base_encoding_validators.dart, string_character_validators.dart): isBase64, isBase32, isBase58, isHexadecimal, isOctal
/// - [Identificadores](string_format_validators.dart, string_simple_validators.dart): isSemVer, isJWT, isSlug, isMimeType, isLocale, isMongoId, isMD5, isHash, isJSON
/// - [Classe de Caractere](string_character_validators.dart, string_simple_validators.dart): isAlphanumeric, isAlpha, isAscii, isNumeric, isLowercase, isUppercase, isMultibyte, isFullWidth, isHalfWidth, isVariableWidth, isSurrogatePair, isByteLength
/// - [Geográfico](string_postal_code_validator.dart, string_latlong_validator.dart): isPostalCode, isLatLong
/// - [Restrições](string_constraint_validators.dart): length, matches, isIn, contains, equals
/// - [Transformações](string_sanitizers.dart): escape, unescape, stripLow, whitelist, blacklist
class StringValidators {
  /// Construtor privado — use o singleton [instance].
  const StringValidators._();

  /// A instância singleton de [StringValidators].
  static StringValidators instance = const StringValidators._();

  /// Valida que uma string não está vazia.
  IUncategorizedFormFieldValidator<String, String> notEmpty() => notEmptyValidator();

  /// Converte uma string para um inteiro.
  IUncategorizedFormFieldValidator<String, int> asInt() => asIntValidator();

  /// Converte uma string para um double.
  IUncategorizedFormFieldValidator<String, double> asDouble() => asDoubleValidator();

  /// Converte uma string para um booleano, opcionalmente usando análise [loose].
  IUncategorizedFormFieldValidator<String, bool> asBool({bool loose = false}) => asBoolValidator(loose: loose);

  /// Valida e converte uma string para um número de porta válido.
  IUncategorizedFormFieldValidator<String, int> asPort() => asPortValidator();

  /// Valida que uma string é um UUID válido, opcionalmente restrito por [version].
  IUncategorizedFormFieldValidator<String, String> isUUID({String? version}) => isUuidValidator(version: version);

  /// Valida que uma string é um endereço de email válido.
  IUncategorizedFormFieldValidator<String, String> isEmail({
    bool allowDisplayName = false,
    bool requireDisplayName = false,
    bool allowUtf8LocalPart = true,
    bool requireTld = true,
    bool allowIpDomain = false,
    bool allowUnderscores = false,
    List<Object> hostBlacklist = const [],
    List<Object> hostWhitelist = const [],
    String blacklistedChars = '',
    bool ignoreMaxLength = false,
  }) => isEmailValidator(
    allowDisplayName: allowDisplayName,
    requireDisplayName: requireDisplayName,
    allowUtf8LocalPart: allowUtf8LocalPart,
    requireTld: requireTld,
    allowIpDomain: allowIpDomain,
    allowUnderscores: allowUnderscores,
    hostBlacklist: hostBlacklist,
    hostWhitelist: hostWhitelist,
    blacklistedChars: blacklistedChars,
    ignoreMaxLength: ignoreMaxLength,
  );

  /// Valida que uma string é uma versão semântica válida.
  IUncategorizedFormFieldValidator<String, String> isSemVer() => isSemVerValidator();

  /// Valida que uma string é um JSON Web Token (JWT) válido.
  IUncategorizedFormFieldValidator<String, String> isJWT() => isJwtValidator();

  /// Valida que uma string é um slug de URL válido.
  IUncategorizedFormFieldValidator<String, String> isSlug() => isSlugValidator();

  /// Valida que uma string é um tipo MIME válido.
  IUncategorizedFormFieldValidator<String, String> isMimeType() => isMimeTypeValidator();

  /// Valida que uma string é um código de localidade válido.
  IUncategorizedFormFieldValidator<String, String> isLocale() => isLocaleValidator();

  /// Valida que uma string é um MongoDB ObjectId válido.
  IUncategorizedFormFieldValidator<String, String> isMongoId() => isMongoIdValidator();

  /// Valida que uma string é um hash MD5 válido.
  IUncategorizedFormFieldValidator<String, String> isMD5() => isMD5Validator();

  /// Valida que uma string é um hash válido para o [algorithm] informado.
  IUncategorizedFormFieldValidator<String, String> isHash(String algorithm) => isHashValidator(algorithm);

  /// Valida que uma string contém dados codificados em Base64 válidos,
  /// opcionalmente em codificação [urlSafe] com ou sem [padding].
  IUncategorizedFormFieldValidator<String, String> isBase64({bool urlSafe = false, bool padding = true}) =>
      isBase64Validator(urlSafe: urlSafe, padding: padding);

  /// Valida que uma string é alfanumérica, opcionalmente ignorando caracteres
  /// em [ignore].
  IUncategorizedFormFieldValidator<String, String> isAlphanumeric({String? ignore}) =>
      isAlphanumericValidator(ignore: ignore);

  /// Valida que uma string é alfabética, opcionalmente ignorando caracteres
  /// em [ignore].
  IUncategorizedFormFieldValidator<String, String> isAlpha({String? ignore}) => isAlphaValidator(ignore: ignore);

  /// Valida que uma string contém apenas caracteres ASCII.
  IUncategorizedFormFieldValidator<String, String> isAscii() => isAsciiValidator();

  /// Valida que uma string é numérica, opcionalmente permitindo símbolos quando
  /// [noSymbols] é false.
  IUncategorizedFormFieldValidator<String, String> isNumeric({bool noSymbols = false}) =>
      isNumericValidator(noSymbols: noSymbols);

  /// Valida que uma string é um valor hexadecimal.
  IUncategorizedFormFieldValidator<String, String> isHexadecimal() => isHexadecimalValidator();

  /// Valida que uma string está toda em minúsculas.
  IUncategorizedFormFieldValidator<String, String> isLowercase() => isLowercaseValidator();

  /// Valida que uma string está toda em maiúsculas.
  IUncategorizedFormFieldValidator<String, String> isUppercase() => isUppercaseValidator();

  /// Valida que o comprimento de uma string está dentro do intervalo informado
  /// ou entre os [discreteLengths].
  IUncategorizedFormFieldValidator<String, String> length({int min = 0, int? max, List<int>? discreteLengths}) =>
      lengthValidator(min: min, max: max, discreteLengths: discreteLengths);

  /// Valida que uma string corresponde ao [pattern] informado.
  IUncategorizedFormFieldValidator<String, String> matches(Pattern pattern) => matchesValidator(pattern);

  /// Valida que uma string é um dos [values] permitidos.
  IUncategorizedFormFieldValidator<String, String> isIn(List<String> values) => isInValidator(values);

  /// Valida que uma string contém o [seed] informado, com opcional
  /// insensibilidade a maiúsculas/minúsculas e contagem mínima de ocorrências.
  IUncategorizedFormFieldValidator<String, String> contains(
    String seed, {
    bool ignoreCase = false,
    int minOccurrences = 1,
  }) => containsValidator(seed, ignoreCase: ignoreCase, minOccurrences: minOccurrences);

  /// Valida que uma string é exatamente igual ao [comparison] informado.
  IUncategorizedFormFieldValidator<String, String> equals(String comparison) => equalsValidator(comparison);

  /// Valida que uma string é um número de cartão de crédito válido,
  /// opcionalmente restrito a um [provider] específico.
  IUncategorizedFormFieldValidator<String, String> isCreditCard({String? provider}) =>
      isCreditCardValidator(provider: provider);

  /// Valida que uma string é um número IMEI válido, opcionalmente permitindo
  /// hífens.
  IUncategorizedFormFieldValidator<String, String> isIMEI({bool allowHyphens = false}) =>
      isImeiValidator(allowHyphens: allowHyphens);

  /// Valida que uma string atende aos requisitos de força de senha.
  IUncategorizedFormFieldValidator<String, String> isStrongPassword({
    int minLength = 8,
    int minLowercase = 1,
    int minUppercase = 1,
    int minNumbers = 1,
    int minSymbols = 1,
    double pointsPerUnique = 1,
    double pointsPerRepeat = 0.5,
    double pointsForContainingLower = 10,
    double pointsForContainingUpper = 10,
    double pointsForContainingNumber = 10,
    double pointsForContainingSymbol = 10,
  }) => isStrongPasswordValidator(
    minLength: minLength,
    minLowercase: minLowercase,
    minUppercase: minUppercase,
    minNumbers: minNumbers,
    minSymbols: minSymbols,
    pointsPerUnique: pointsPerUnique,
    pointsPerRepeat: pointsPerRepeat,
    pointsForContainingLower: pointsForContainingLower,
    pointsForContainingUpper: pointsForContainingUpper,
    pointsForContainingNumber: pointsForContainingNumber,
    pointsForContainingSymbol: pointsForContainingSymbol,
  );

  /// Valida que uma string é um número de telefone móvel válido para o
  /// [locale] ou [locales] informado.
  IUncategorizedFormFieldValidator<String, String> isMobilePhone({
    String? locale,
    List<String>? locales,
    bool strictMode = false,
  }) => isMobilePhoneValidator(locale: locale, locales: locales, strictMode: strictMode);

  /// Valida que uma string é JSON válido.
  IUncategorizedFormFieldValidator<String, String> isJson() => isJsonValidator();

  /// Valida que uma string é um endereço MAC válido, opcionalmente sem
  /// dois-pontos.
  IUncategorizedFormFieldValidator<String, String> isMACAddress({bool noColons = false}) =>
      isMacAddressValidator(noColons: noColons);

  /// Valida que uma string é octal válido.
  IUncategorizedFormFieldValidator<String, String> isOctal() => isOctalValidator();

  /// Valida que o comprimento em bytes de uma string está dentro dos limites
  /// informados.
  IUncategorizedFormFieldValidator<String, String> isByteLength({int min = 0, int? max}) =>
      isByteLengthValidator(min: min, max: max);

  /// Valida que uma string contém caracteres multibyte.
  IUncategorizedFormFieldValidator<String, String> isMultibyte() => isMultibyteValidator();

  /// Valida que uma string contém caracteres de largura completa.
  IUncategorizedFormFieldValidator<String, String> isFullWidth() => isFullWidthValidator();

  /// Valida que uma string contém caracteres de meia largura.
  IUncategorizedFormFieldValidator<String, String> isHalfWidth() => isHalfWidthValidator();

  /// Valida que uma string contém caracteres de largura variável.
  IUncategorizedFormFieldValidator<String, String> isVariableWidth() => isVariableWidthValidator();

  /// Valida que uma string contém caracteres de par substituto.
  IUncategorizedFormFieldValidator<String, String> isSurrogatePair() => isSurrogatePairValidator();

  /// Valida que uma string é um endereço IP válido, opcionalmente restrito
  /// a uma [version] específica (4 ou 6).
  IUncategorizedFormFieldValidator<String, String> isIP({int? version}) => isIpValidator(version: version);

  /// Valida que uma string é um ISBN válido, opcionalmente restrito a uma
  /// [version] específica.
  IUncategorizedFormFieldValidator<String, String> isISBN({int? version}) => isIsbnValidator(version: version);

  /// Valida que uma string é um EAN válido, opcionalmente restrito a um
  /// [type] específico.
  IUncategorizedFormFieldValidator<String, String> isEAN({String? type}) => isEanValidator(type: type);

  /// Valida que uma string contém dados codificados em Base32 válidos.
  IUncategorizedFormFieldValidator<String, String> isBase32() => isBase32Validator();

  /// Valida que uma string contém dados codificados em Base58 válidos.
  IUncategorizedFormFieldValidator<String, String> isBase58() => isBase58Validator();

  /// Valida que uma string é uma URL válida.
  IUncategorizedFormFieldValidator<String, Uri> isURL({
    List<String> protocols = const ['http', 'https', 'ftp'],
    bool requireTld = true,
    bool requireProtocol = false,
    bool requireHost = true,
    bool requirePort = false,
    bool requireValidProtocol = true,
    bool allowUnderscores = false,
    List<Object> hostWhitelist = const [],
    List<Object> hostBlacklist = const [],
    bool allowTrailingDot = false,
    bool allowProtocolRelativeUrls = false,
    bool allowFragments = true,
    bool allowQueryComponents = true,
    bool disallowAuth = false,
    bool validateLength = true,
    int maxAllowedLength = 2084,
  }) => isUrlValidator(
    protocols: protocols,
    requireTld: requireTld,
    requireProtocol: requireProtocol,
    requireHost: requireHost,
    requirePort: requirePort,
    requireValidProtocol: requireValidProtocol,
    allowUnderscores: allowUnderscores,
    hostWhitelist: hostWhitelist,
    hostBlacklist: hostBlacklist,
    allowTrailingDot: allowTrailingDot,
    allowProtocolRelativeUrls: allowProtocolRelativeUrls,
    allowFragments: allowFragments,
    allowQueryComponents: allowQueryComponents,
    disallowAuth: disallowAuth,
    validateLength: validateLength,
    maxAllowedLength: maxAllowedLength,
  );

  /// Valida que uma string é um par latitude/longitude válido, opcionalmente
  /// no formato DMS.
  IUncategorizedFormFieldValidator<String, ({double lat, double lng})> isLatLong({bool checkDMS = false}) =>
      isLatLongValidator(checkDMS: checkDMS);

  /// Valida que uma string é um código postal válido para o [countryCode]
  /// informado.
  IUncategorizedFormFieldValidator<String, String> isPostalCode(String countryCode) =>
      isPostalCodeValidator(countryCode);

  /// Escapa caracteres especiais em uma string.
  IUncategorizedFormFieldValidator<String, String> escape() => escapeValidator();

  /// Remove escape de caracteres previamente escapados em uma string.
  IUncategorizedFormFieldValidator<String, String> unescape() => unescapeValidator();

  /// Remove caracteres baixos (de controle), opcionalmente mantendo novas
  /// linhas.
  IUncategorizedFormFieldValidator<String, String> stripLow({bool keepNewLines = false}) =>
      stripLowValidator(keepNewLines: keepNewLines);

  /// Mantém apenas os [chars] especificados em uma string.
  IUncategorizedFormFieldValidator<String, String> whitelist(String chars) => whitelistValidator(chars);

  /// Remove os [chars] especificados de uma string.
  IUncategorizedFormFieldValidator<String, String> blacklist(String chars) => blacklistValidator(chars);
}
