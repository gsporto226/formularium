import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

const _postalCodePatterns = <String, String>{
  'AD': r'^AD\d{3}$',
  'AT': r'^\d{4}$',
  'AU': r'^\d{4}$',
  'AZ': r'^AZ\d{4}$',
  'BA': r'^([7-8]\d{4})$',
  'BD': r'^([1-8][0-9]{3}|9[0-4][0-9]{2})$',
  'BE': r'^\d{4}$',
  'BG': r'^\d{4}$',
  'BR': r'^\d{5}-?\d{3}$',
  'BY': r'^2[1-4]\d{4}$',
  'CA': r'^[ABCEGHJKLMNPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][\s\-]?\d[ABCEGHJ-NPRSTV-Z]\d$',
  'CH': r'^\d{4}$',
  'CN': r'^(0[1-7]|1[012356]|2[0-7]|3[0-6]|4[0-7]|5[1-7]|6[1-7]|7[1-5]|8[1345]|9[09])\d{4}$',
  'CO':
      r'^(05|08|11|13|15|17|18|19|20|23|25|27|41|44|47|50|52|54|63|66|68|70|73|76|81|85|86|88|91|94|95|97|99)(\d{4})$',
  'CZ': r'^\d{3}\s?\d{2}$',
  'DE': r'^\d{5}$',
  'DK': r'^\d{4}$',
  'DO': r'^\d{5}$',
  'DZ': r'^\d{5}$',
  'EE': r'^\d{5}$',
  'ES': r'^(5[0-2]{1}|[0-4]{1}\d{1})\d{3}$',
  'FI': r'^\d{5}$',
  'FR': r'^(?:(?:0[1-9]|[1-8]\d|9[0-5])\d{3}|97[1-46]\d{2})$',
  'GB': r'^(gir\s?0aa|[a-z]{1,2}\d[\da-z]?\s?(\d[a-z]{2})?)$',
  'GR': r'^\d{3}\s?\d{2}$',
  'HR': r'^([1-5]\d{4})$',
  'HT': r'^HT\d{4}$',
  'HU': r'^\d{4}$',
  'ID': r'^\d{5}$',
  'IE': r'^(?!.*(?:o))[A-Za-z]\d[\dw]\s\w{4}$',
  'IL': r'^(\d{5}|\d{7})$',
  'IN': r'^((?!10|29|35|54|55|65|66|86|87|88|89)[1-9][0-9]{5})$',
  'IR': r'^(?!(\d)\1{3})[13-9]{4}[1346-9][013-9]{5}$',
  'IS': r'^\d{3}$',
  'IT': r'^\d{5}$',
  'JP': r'^\d{3}\-\d{4}$',
  'KE': r'^\d{5}$',
  'KR': r'^(\d{5}|\d{6})$',
  'LI': r'^(948[5-9]|949[0-7])$',
  'LT': r'^LT\-\d{5}$',
  'LU': r'^\d{4}$',
  'LV': r'^LV\-\d{4}$',
  'LK': r'^\d{5}$',
  'MC': r'^980\d{2}$',
  'MG': r'^\d{3}$',
  'MX': r'^\d{5}$',
  'MT': r'^[A-Za-z]{3}\s{0,1}\d{4}$',
  'MY': r'^\d{5}$',
  'NL': r'^[1-9]\d{3}\s?(?!sa|sd|ss)[a-z]{2}$',
  'NO': r'^\d{4}$',
  'NP': r'^(10|21|22|32|33|34|44|45|56|57)\d{3}$|^(977)$',
  'NZ': r'^\d{4}$',
  'PK': r'^\d{5}$',
  'PL': r'^\d{2}\-\d{3}$',
  'PR': r'^00[679]\d{2}([ -]\d{4})?$',
  'PT': r'^\d{4}\-\d{3}?$',
  'RO': r'^\d{6}$',
  'RU': r'^\d{6}$',
  'SA': r'^\d{5}$',
  'SE': r'^[1-9]\d{2}\s?\d{2}$',
  'SG': r'^\d{6}$',
  'SI': r'^\d{4}$',
  'SK': r'^\d{3}\s?\d{2}$',
  'TH': r'^\d{5}$',
  'TN': r'^\d{4}$',
  'TW': r'^\d{3}(\d{2,3})?$',
  'UA': r'^\d{5}$',
  'US': r'^\d{5}(-\d{4})?$',
  'ZA': r'^\d{4}$',
  'ZM': r'^\d{5}$',
};

/// O conjunto de códigos de localidade suportados para validação de código postal.
Set<String> get postalCodeLocales => _postalCodePatterns.keys.toSet();

/// Valida se uma string é um código postal válido para o [countryCode] informado.
IUncategorizedFormFieldValidator<String, String> isPostalCodeValidator(String countryCode) => (string) {
  final patternStr = _postalCodePatterns[countryCode.toUpperCase()];
  if (patternStr == null) {
    return Validation(validation: StringValidation.invalidPostalCode(string), transformed: '');
  }
  if (!RegExp(patternStr, caseSensitive: false).hasMatch(string.trim())) {
    return Validation(validation: StringValidation.invalidPostalCode(string), transformed: '');
  }
  return Validation(transformed: string, validation: null);
};
