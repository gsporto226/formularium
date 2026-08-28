import 'package:concierge/context_interface.dart';
import 'package:formularium/features/localization/localizable_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

/// Hierarquia selada de resultados de validação de campo de tempo.
sealed class TimeValidation implements ILocalizable {
  /// Construtor const padrão.
  const TimeValidation();

  /// Cria um erro [InvalidTime] para um valor que não pode ser interpretado.
  static InvalidTime invalidTime({
    required String value,
    required String hourFormat,
    required String mode,
  }) => InvalidTime(value: value, hourFormat: hourFormat, mode: mode);
}

/// O valor não é um horário válido no formato esperado.
class InvalidTime extends TimeValidation {
  /// Cria um [InvalidTime] com o [value] bruto, [hourFormat] esperado e [mode] de exibição.
  InvalidTime({
    required this.value,
    required this.hourFormat,
    required this.mode,
  });

  /// O valor bruto da string que não pôde ser interpretado como horário.
  final String value;

  /// O formato de hora esperado (ex.: "12" ou "24").
  final String hourFormat;

  /// O modo de exibição do seletor de horário.
  final String mode;

  @override
  String localize(IContext context) => context.fL10n.validation_invalid_time(value, hourFormat, mode);
}
