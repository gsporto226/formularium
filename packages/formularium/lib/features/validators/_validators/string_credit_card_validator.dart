import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_helpers.dart';

/// Valida se uma string é um número de cartão de crédito válido usando o algoritmo de Luhn.
///
/// Se [provider] for informado, também valida se o número pertence àquela
/// bandeira de cartão (ex.: 'visa', 'mastercard', 'amex').
IUncategorizedFormFieldValidator<String, String> isCreditCardValidator({
  String? provider,
}) => (string) {
  final sanitized = string.replaceAll(RegExp(r'[\s-]'), '');
  if (!RegExp(r'^\d{13,19}$').hasMatch(sanitized)) {
    return Validation(
      validation: StringValidation.invalidCreditCard(provider: provider),
      transformed: '',
    );
  }

  if (!luhnCheck(sanitized)) {
    return Validation(
      validation: StringValidation.invalidCreditCard(provider: provider),
      transformed: '',
    );
  }

  if (provider != null && !_matchesCardProvider(sanitized, provider)) {
    return Validation(
      validation: StringValidation.invalidCreditCard(provider: provider),
      transformed: '',
    );
  }

  return Validation(transformed: string, validation: null);
};

bool _matchesCardProvider(String digits, String provider) {
  switch (provider.toLowerCase()) {
    case 'visa':
      return digits.startsWith('4');
    case 'mastercard':
      final start = int.parse(digits.substring(0, 2));
      return (start >= 51 && start <= 55) ||
          (int.parse(digits.substring(0, 4)) >= 2221 && int.parse(digits.substring(0, 4)) <= 2720);
    case 'amex':
      return digits.startsWith('34') || digits.startsWith('37');
    case 'discover':
      return digits.startsWith('6011') ||
          digits.startsWith('65') ||
          (int.parse(digits.substring(0, 3)) >= 644 && int.parse(digits.substring(0, 3)) <= 649);
    case 'dinersclub':
      return digits.startsWith('300') ||
          digits.startsWith('301') ||
          digits.startsWith('302') ||
          digits.startsWith('303') ||
          digits.startsWith('304') ||
          digits.startsWith('305') ||
          digits.startsWith('36');
    case 'jcb':
      final start = int.parse(digits.substring(0, 4));
      return start >= 3528 && start <= 3589;
    case 'unionpay':
      final start = int.parse(digits.substring(0, 6));
      return (start >= 622126 && start <= 622925) ||
          (int.parse(digits.substring(0, 3)) >= 624 && int.parse(digits.substring(0, 3)) <= 626) ||
          (int.parse(digits.substring(0, 4)) >= 6282 && int.parse(digits.substring(0, 4)) <= 6288);
    default:
      return false;
  }
}

/// Valida se uma string é um número IMEI válido usando o algoritmo de Luhn.
///
/// Se [allowHyphens] for true, os hífens da entrada são removidos antes da validação.
IUncategorizedFormFieldValidator<String, String> isImeiValidator({
  bool allowHyphens = false,
}) => (string) {
  final sanitized = allowHyphens ? string.replaceAll('-', '') : string;
  if (!RegExp(r'^\d{15}$').hasMatch(sanitized)) {
    return Validation(validation: StringValidation.invalidImei(string), transformed: '');
  }
  if (!luhnCheck(sanitized)) {
    return Validation(validation: StringValidation.invalidImei(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};
