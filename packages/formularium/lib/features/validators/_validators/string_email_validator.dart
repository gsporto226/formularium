import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_helpers.dart';

/// Valida se uma string é um endereço de e-mail válido.
///
/// Oferece suporte a opções para nomes de exibição, partes locais em UTF-8,
/// exigência de TLD, domínios IP, lista de permissão/bloqueio de hosts e
/// restrições de caracteres.
IUncategorizedFormFieldValidator<String, String> isEmailValidator({
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
}) => (original) {
  var email = original.trim();

  if (allowDisplayName || requireDisplayName) {
    final match = RegExp(r'^(.+)\s+<([^>]+)>$').firstMatch(email);
    if (match != null) {
      email = match.group(2)!;
    } else if (requireDisplayName) {
      return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
    }
  }

  final atIndex = email.lastIndexOf('@');
  if (atIndex < 1 || atIndex == email.length - 1) {
    return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
  }

  final localPart = email.substring(0, atIndex);
  final domain = email.substring(atIndex + 1);

  if (!ignoreMaxLength && original.length > 254) {
    return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
  }

  if (localPart.isEmpty || localPart.length > 64) {
    return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
  }

  if (blacklistedChars.isNotEmpty) {
    for (var i = 0; i < blacklistedChars.length; i++) {
      if (localPart.contains(blacklistedChars[i])) {
        return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
      }
    }
  }

  final localRegex = allowUtf8LocalPart
      ? RegExp("^[a-zA-Z0-9\u0080-\uFFFF!#\$%&'*+\\-/?=^_`{|}~.]+\$")
      : RegExp(r"^[a-zA-Z0-9!#$%&'*+\-/?=^_`{|}~.]+$");
  if (!localRegex.hasMatch(localPart)) {
    return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
  }

  if (localPart.contains('..') || localPart.startsWith('.') || localPart.endsWith('.')) {
    return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
  }

  if (allowIpDomain) {
    final ipMatch = RegExp(r'^\[([^\[\]]+)\]$').firstMatch(domain);
    if (ipMatch != null) {
      final ip = ipMatch.group(1)!;
      if (isValidIp(ip)) {
        return Validation(transformed: original, validation: null);
      }
    }
  }

  return validateDomain(original, domain, requireTld, allowUnderscores, hostBlacklist, hostWhitelist);
};
