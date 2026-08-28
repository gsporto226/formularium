import 'dart:convert';

import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Valida uma parte de domínio contra regras de lista de bloqueio, lista de permissão, TLD e formato.
///
/// Retorna uma [Validation] com a string [original] como valor transformado em caso de sucesso.
Validation<String> validateDomain(
  String original,
  String domain,
  bool requireTld,
  bool allowUnderscores,
  List<Object> hostBlacklist,
  List<Object> hostWhitelist,
) {
  if (hostBlacklist.isNotEmpty) {
    for (final entry in hostBlacklist) {
      if (entry is String && domain == entry) {
        return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
      }
      if (entry is RegExp && entry.hasMatch(domain)) {
        return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
      }
    }
  }

  if (hostWhitelist.isNotEmpty) {
    final matchesWhitelist = hostWhitelist.any((entry) {
      if (entry is String) return domain == entry;
      if (entry is RegExp) return entry.hasMatch(domain);
      return false;
    });
    if (!matchesWhitelist) {
      return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
    }
  }

  final domainParts = domain.split('.');
  if (domainParts.length < 2) {
    return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
  }

  if (requireTld && domainParts.last.length < 2) {
    return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
  }

  final hostPattern = allowUnderscores ? RegExp(r'^[a-zA-Z0-9._-]+$') : RegExp(r'^[a-zA-Z0-9.-]+$');
  if (!hostPattern.hasMatch(domain)) {
    return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
  }

  for (final part in domainParts) {
    if (part.isEmpty || part.length > 63) {
      return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
    }
    if (part.startsWith('-') || part.endsWith('-')) {
      return Validation(validation: StringValidation.invalidEmail(original), transformed: '');
    }
  }

  return Validation(transformed: original, validation: null);
}

/// Retorna `true` se [ip] for um endereço IPv4 ou IPv6 válido.
bool isValidIp(String ip) {
  final v4Match = RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$').firstMatch(ip);
  if (v4Match != null) {
    for (var i = 1; i <= 4; i++) {
      final octet = int.parse(v4Match.group(i)!);
      if (octet < 0 || octet > 255) return false;
    }
    return true;
  }
  return ip.contains(':') && !ip.startsWith(':') && !ip.endsWith(':');
}

/// Retorna `true` se [digits] passar no algoritmo de checksum de Luhn.
bool luhnCheck(String digits) {
  var sum = 0;
  var alternate = false;
  for (var i = digits.length - 1; i >= 0; i--) {
    var n = int.parse(digits[i]);
    if (alternate) {
      n *= 2;
      if (n > 9) n -= 9;
    }
    sum += n;
    alternate = !alternate;
  }
  return sum % 10 == 0;
}

/// Decodifica uma string codificada em base64url para sua representação UTF-8.
String base64UrlDecode(String str) {
  final normalized = str.replaceAll('-', '+').replaceAll('_', '/');
  final padded = normalized.padRight(
    normalized.length + (4 - normalized.length % 4) % 4,
    '=',
  );
  return String.fromCharCodes(base64Decode(padded));
}

/// Mapa de nomes de algoritmos de hash para seus comprimentos esperados de string hexadecimal.
const Map<String, int> hashLengths = {
  'crc32': 8,
  'crc32b': 8,
  'md4': 32,
  'md5': 32,
  'ripemd128': 32,
  'ripemd160': 40,
  'sha1': 40,
  'sha256': 64,
  'sha384': 96,
  'sha512': 128,
  'tiger128': 32,
  'tiger160': 40,
  'tiger192': 48,
};
