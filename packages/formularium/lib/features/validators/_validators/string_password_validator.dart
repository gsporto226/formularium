import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Valida se uma string atende aos requisitos de força de senha.
///
/// Verifica comprimento mínimo, contagem de classes de caracteres (minúsculas,
/// maiúsculas, números, símbolos) e calcula uma pontuação de força com base em
/// pesos configuráveis.
IUncategorizedFormFieldValidator<String, String> isStrongPasswordValidator({
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
}) => (string) {
  final score = _passwordScore(
    string,
    pointsPerUnique: pointsPerUnique,
    pointsPerRepeat: pointsPerRepeat,
    pointsForContainingLower: pointsForContainingLower,
    pointsForContainingUpper: pointsForContainingUpper,
    pointsForContainingNumber: pointsForContainingNumber,
    pointsForContainingSymbol: pointsForContainingSymbol,
  );

  final hasLength = string.length >= minLength;
  final hasLower = _countLowercase(string) >= minLowercase;
  final hasUpper = _countUppercase(string) >= minUppercase;
  final hasNumbers = _countNumbers(string) >= minNumbers;
  final hasSymbols = _countSymbols(string) >= minSymbols;

  if (hasLength && hasLower && hasUpper && hasNumbers && hasSymbols) {
    return Validation(transformed: string, validation: null);
  }

  final minScore = _minPasswordScore(
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

  return Validation(
    validation: StringValidation.weakPassword(
      score: score.round(),
      minScore: minScore.round(),
      minLength: minLength,
      hasLength: hasLength,
      hasLowercase: hasLower,
      hasUppercase: hasUpper,
      hasNumbers: hasNumbers,
      hasSymbols: hasSymbols,
    ),
    transformed: '',
  );
};

double _passwordScore(
  String password, {
  double pointsPerUnique = 1,
  double pointsPerRepeat = 0.5,
  double pointsForContainingLower = 10,
  double pointsForContainingUpper = 10,
  double pointsForContainingNumber = 10,
  double pointsForContainingSymbol = 10,
}) {
  var score = password.length * 4.0;
  score += _countUniqueChars(password) * pointsPerUnique;
  score += _countRepeats(password) * pointsPerRepeat;
  if (_countLowercase(password) > 0) score += pointsForContainingLower;
  if (_countUppercase(password) > 0) score += pointsForContainingUpper;
  if (_countNumbers(password) > 0) score += pointsForContainingNumber;
  if (_countSymbols(password) > 0) score += pointsForContainingSymbol;
  return score;
}

double _minPasswordScore({
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
}) {
  var score = minLength * 4.0;
  score += minLength * pointsPerUnique;
  if (minLowercase > 0) score += pointsForContainingLower;
  if (minUppercase > 0) score += pointsForContainingUpper;
  if (minNumbers > 0) score += pointsForContainingNumber;
  if (minSymbols > 0) score += pointsForContainingSymbol;
  return score;
}

int _countUniqueChars(String s) => s.split('').toSet().length;

int _countRepeats(String s) {
  var repeats = 0;
  for (var i = 0; i < s.length - 1; i++) {
    if (s[i] == s[i + 1]) repeats++;
  }
  return repeats;
}

int _countLowercase(String s) => 'abcdefghijklmnopqrstuvwxyz'
    .split('')
    .fold(
      0,
      (count, c) => count + c.allMatches(s).length,
    );

int _countUppercase(String s) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    .split('')
    .fold(
      0,
      (count, c) => count + c.allMatches(s).length,
    );

int _countNumbers(String s) => '0123456789'.split('').fold(0, (count, c) => count + c.allMatches(s).length);

int _countSymbols(String s) {
  var count = 0;
  for (var i = 0; i < s.length; i++) {
    final c = s.codeUnitAt(i);
    if (c >= 32 && c <= 126 && !(c >= 48 && c <= 57) && !(c >= 65 && c <= 90) && !(c >= 97 && c <= 122)) {
      count++;
    }
  }
  return count;
}
