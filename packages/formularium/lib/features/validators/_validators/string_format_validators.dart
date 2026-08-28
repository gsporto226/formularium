import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_helpers.dart';

/// Retorna um validador que verifica se uma string é uma versão semântica (SemVer) válida.
IUncategorizedFormFieldValidator<String, String> isSemVerValidator() => (string) {
  final pattern = RegExp(
    r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)'
    r'(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)'
    r'(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?'
    r'(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$',
  );
  if (!pattern.hasMatch(string)) {
    return Validation(validation: StringValidation.invalidSemVer(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string é um JWT válido (três segmentos codificados em base64url).
IUncategorizedFormFieldValidator<String, String> isJwtValidator() => (string) {
  final parts = string.split('.');
  if (parts.length != 3) {
    return Validation(validation: StringValidation.invalidJwt(string), transformed: '');
  }
  for (final part in parts) {
    if (part.isEmpty) {
      return Validation(validation: StringValidation.invalidJwt(string), transformed: '');
    }
    try {
      base64UrlDecode(part);
    } on Object catch (_) {
      return Validation(validation: StringValidation.invalidJwt(string), transformed: '');
    }
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string é um slug de URL válido (minúsculas, separado por hífens).
IUncategorizedFormFieldValidator<String, String> isSlugValidator() => (string) {
  if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(string)) {
    return Validation(validation: StringValidation.invalidSlug(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string é um tipo MIME válido (ex.: "text/plain").
IUncategorizedFormFieldValidator<String, String> isMimeTypeValidator() => (string) {
  if (!RegExp(r'^[a-zA-Z0-9!#$&.+\-^_]+/[a-zA-Z0-9!#$&.+\-^_]+$').hasMatch(string)) {
    return Validation(validation: StringValidation.invalidMimeType(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string é um código de localidade válido (ex.: "en", "en_US").
IUncategorizedFormFieldValidator<String, String> isLocaleValidator() => (string) {
  if (!RegExp(r'^[a-zA-Z]{2}([_-][a-zA-Z]{2,4})?$').hasMatch(string)) {
    return Validation(validation: StringValidation.invalidLocale(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string é um ObjectId do MongoDB válido (24 caracteres hexadecimais).
IUncategorizedFormFieldValidator<String, String> isMongoIdValidator() => (string) {
  if (!RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(string)) {
    return Validation(validation: StringValidation.invalidMongoId(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string é um hash MD5 válido.
IUncategorizedFormFieldValidator<String, String> isMD5Validator() => isHashValidator('md5');

/// Retorna um validador que verifica se uma string é um hash válido para o [algorithm] informado.
///
/// Os algoritmos suportados incluem md4, md5, sha1, sha256, sha384, sha512, entre outros.
IUncategorizedFormFieldValidator<String, String> isHashValidator(String algorithm) => (string) {
  final length = hashLengths[algorithm.toLowerCase()];
  if (length == null) {
    return Validation(validation: StringValidation.invalidHash(algorithm), transformed: '');
  }
  if (!RegExp('^[0-9a-fA-F]{$length}\$').hasMatch(string)) {
    return Validation(validation: StringValidation.invalidHash(algorithm), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna um validador que verifica se uma string é um Base64 válido.
///
/// Defina [urlSafe] como `true` para base64 seguro para URL. Defina [padding] como `false` para ignorar a validação de preenchimento.
IUncategorizedFormFieldValidator<String, String> isBase64Validator({
  bool urlSafe = false,
  bool padding = true,
}) => (string) {
  if (string.isEmpty) {
    return Validation(validation: StringValidation.notBase64(string), transformed: '');
  }

  final pattern = urlSafe ? RegExp(r'^[A-Za-z0-9\-_]+=*$') : RegExp(r'^[A-Za-z0-9+/]+=*$');
  if (!pattern.hasMatch(string)) {
    return Validation(validation: StringValidation.notBase64(string), transformed: '');
  }

  if (padding && string.length % 4 != 0) {
    return Validation(validation: StringValidation.notBase64(string), transformed: '');
  }

  return Validation(transformed: string, validation: null);
};
