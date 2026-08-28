import 'package:concierge/context_interface.dart';
import 'package:formularium/features/localization/localizable_interface.dart';
import 'package:formularium/features/validators/_enums/input_date_format.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:formularium/features/validators/_utils/date_time_localizations.dart';

/// Classe base para tipos de erro de validação de data/hora.
sealed class DateTimeValidation implements ILocalizable {
  /// Cria um erro de validação [DateAfter] exigindo que o valor seja posterior a [reference].
  static DateAfter after(DateTime reference, {InputDateFormat? format}) => DateAfter(reference, format: format);

  /// Cria um erro de validação [DateBefore] exigindo que o valor seja anterior a [reference].
  static DateBefore before(DateTime reference, {InputDateFormat? format}) => DateBefore(reference, format: format);

  /// Cria um erro de validação [DateAfterInclusive] exigindo que o valor seja igual ou posterior a [reference].
  static DateAfterInclusive afterInclusive(DateTime reference, {InputDateFormat? format}) =>
      DateAfterInclusive(reference, format: format);

  /// Cria um erro de validação [DateBeforeInclusive] exigindo que o valor seja igual ou anterior a [reference].
  static DateBeforeInclusive beforeInclusive(DateTime reference, {InputDateFormat? format}) =>
      DateBeforeInclusive(reference, format: format);

  /// Cria um erro de validação [DateInvalid] para uma data inválida.
  static DateInvalid invalid() => const DateInvalid();

  /// Cria um erro de validação [InvalidTime] para o [value] informado.
  static InvalidTime invalidTime({
    required String value,
    required String hourFormat,
    required String mode,
  }) => InvalidTime(value: value, hourFormat: hourFormat, mode: mode);
}

/// Erro de validação indicando que o valor deve ser anterior a [reference].
class DateBefore implements DateTimeValidation {
  /// Cria um erro de validação [DateBefore].
  DateBefore(this.reference, {this.format});

  /// A data de referência que o valor deve ser anterior.
  final DateTime reference;

  /// O formato de data de entrada opcional para localização.
  final InputDateFormat? format;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) {
    final l10n = context.fL10n;
    return l10n.date_time_field_before(reference.localize(l10n, pattern: format?.toDateFormat.pattern));
  }
}

/// Erro de validação indicando que o valor deve ser posterior a [reference].
class DateAfter implements DateTimeValidation {
  /// Cria um erro de validação [DateAfter].
  DateAfter(this.reference, {this.format});

  /// A data de referência que o valor deve ser posterior.
  final DateTime reference;

  /// O formato de data de entrada opcional para localização.
  final InputDateFormat? format;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) {
    final l10n = context.fL10n;
    return l10n.date_time_field_after(reference.localize(l10n, pattern: format?.toDateFormat.pattern));
  }
}

/// Erro de validação indicando que o valor deve ser igual ou posterior a [reference].
class DateAfterInclusive implements DateTimeValidation {
  /// Cria um erro de validação [DateAfterInclusive].
  DateAfterInclusive(this.reference, {this.format});

  /// A data de referência que o valor deve ser igual ou posterior.
  final DateTime reference;

  /// O formato de data de entrada opcional para localização.
  final InputDateFormat? format;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) {
    final l10n = context.fL10n;
    return l10n.date_time_field_after_inclusive(reference.localize(l10n, pattern: format?.toDateFormat.pattern));
  }
}

/// Erro de validação indicando que o valor deve ser igual ou anterior a [reference].
class DateBeforeInclusive implements DateTimeValidation {
  /// Cria um erro de validação [DateBeforeInclusive].
  DateBeforeInclusive(this.reference, {this.format});

  /// A data de referência que o valor deve ser igual ou anterior.
  final DateTime reference;

  /// O formato de data de entrada opcional para localização.
  final InputDateFormat? format;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) {
    final l10n = context.fL10n;
    return l10n.date_time_field_before_inclusive(reference.localize(l10n, pattern: format?.toDateFormat.pattern));
  }
}

/// Erro de validação indicando que a data é inválida.
class DateInvalid implements DateTimeValidation {
  /// Cria um erro de validação [DateInvalid].
  const DateInvalid();

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.date_invalid;
}

/// Erro de validação indicando que o valor de tempo é inválido.
class InvalidTime implements DateTimeValidation {
  /// Cria um erro de validação [InvalidTime].
  InvalidTime({
    required this.value,
    required this.hourFormat,
    required this.mode,
  });

  /// O valor da string que falhou na validação de tempo.
  final String value;

  /// O formato de hora esperado (ex.: 12h ou 24h).
  final String hourFormat;

  /// O modo de validação que foi verificado.
  final String mode;

  /// Localiza este erro de validação.
  @override
  String localize(IContext context) => context.fL10n.validation_invalid_time(value, hourFormat, mode);
}
