import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_helpers.dart';

/// Valida se uma string é uma URL válida.
///
/// Oferece suporte a várias opções para requisitos de protocolo, validação de TLD,
/// lista de permissão/bloqueio de hosts e controle de componentes.
IUncategorizedFormFieldValidator<String, Uri> isUrlValidator({
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
}) => (string) {
  if (validateLength && string.length > maxAllowedLength) {
    return Validation(validation: StringValidation.invalidUrl(string), transformed: Uri());
  }

  var url = string.trim();

  if (allowProtocolRelativeUrls && url.startsWith('//')) {
    url = 'https:$url';
  }

  var parsed = Uri.parse(url);

  if (!parsed.hasScheme || parsed.scheme.isEmpty) {
    if (requireProtocol) {
      return Validation(validation: StringValidation.invalidUrl(string), transformed: Uri());
    }
    parsed = Uri.parse('http://$url');
  }

  if (requireValidProtocol && !protocols.map((p) => p.toLowerCase()).contains(parsed.scheme.toLowerCase())) {
    return Validation(validation: StringValidation.invalidUrl(string), transformed: Uri());
  }

  if (requireHost && parsed.host.isEmpty) {
    return Validation(validation: StringValidation.invalidUrl(string), transformed: Uri());
  }

  if (requirePort && parsed.port == 0) {
    return Validation(validation: StringValidation.invalidUrl(string), transformed: Uri());
  }

  if (disallowAuth && parsed.userInfo.isNotEmpty) {
    return Validation(validation: StringValidation.invalidUrl(string), transformed: Uri());
  }

  if (!allowFragments && parsed.hasFragment) {
    return Validation(validation: StringValidation.invalidUrl(string), transformed: Uri());
  }

  if (!allowQueryComponents && parsed.hasQuery) {
    return Validation(validation: StringValidation.invalidUrl(string), transformed: Uri());
  }

  if (parsed.host.isNotEmpty) {
    final domainResult = validateDomain(
      string,
      parsed.host,
      requireTld,
      allowUnderscores,
      hostBlacklist,
      hostWhitelist,
    );
    if (domainResult.validation != null) {
      return Validation(validation: StringValidation.invalidUrl(string), transformed: Uri());
    }
  }

  return Validation(transformed: parsed, validation: null);
};
