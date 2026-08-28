import 'package:concierge/context_interface.dart';
import 'package:formularium/features/localization/localizable_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

/// Hierarquia selada de resultados de validação de campo numérico.
sealed class NumberValidation implements ILocalizable {
  /// Cria um erro [NumberTooBig] para um valor que excede [maxValue].
  static NumberTooBig max(num maxValue) => NumberTooBig(maxValue);

  /// Cria um erro [NumberTooSmall] para um valor abaixo de [minValue].
  static NumberTooSmall min(num minValue) => NumberTooSmall(minValue);

  /// Cria um erro [NotDivisible] onde o valor deve ser divisível por [divisor].
  static NotDivisible notDivisible(num divisor) => NotDivisible(divisor);

  /// Um valor que não é positivo.
  static const NotPositive notPositive = NotPositive();

  /// Um valor que não é negativo.
  static const NotNegative notNegative = NotNegative();
}

/// O número excede o máximo permitido.
class NumberTooBig implements NumberValidation {
  /// Cria um [NumberTooBig] com o [maxValue] informado.
  NumberTooBig(this.maxValue);

  /// O valor máximo permitido.
  final num maxValue;

  @override
  String localize(IContext context) => context.fL10n.number_field_value_too_big(maxValue.toString());
}

/// O número está abaixo do mínimo permitido.
class NumberTooSmall implements NumberValidation {
  /// Cria um [NumberTooSmall] com o [minValue] informado.
  NumberTooSmall(this.minValue);

  /// O valor mínimo permitido.
  final num minValue;

  @override
  String localize(IContext context) => context.fL10n.number_field_value_too_small(minValue.toString());
}

/// O valor não é um número válido.
class NotANumber implements NumberValidation {
  /// Cria um [NotANumber] com a string inválida [value].
  NotANumber({required this.value});

  /// O valor bruto da string que não pôde ser interpretado como número.
  final String value;

  @override
  String localize(IContext context) => context.fL10n.validation_not_a_number;
}

/// O número não é divisível pelo divisor esperado.
class NotDivisible implements NumberValidation {
  /// Cria um [NotDivisible] com o [divisor] exigido.
  NotDivisible(this.divisor);

  /// O divisor pelo qual o valor deve ser exatamente divisível.
  final num divisor;

  @override
  String localize(IContext context) => context.fL10n.number_field_not_divisible(divisor.toString());
}

/// O número não é positivo (<= 0).
class NotPositive implements NumberValidation {
  /// Uma instância constante de [NotPositive].
  const NotPositive();

  @override
  String localize(IContext context) => context.fL10n.number_field_not_positive;
}

/// O número não é negativo (>= 0).
class NotNegative implements NumberValidation {
  /// Uma instância constante de [NotNegative].
  const NotNegative();

  @override
  String localize(IContext context) => context.fL10n.number_field_not_negative;
}