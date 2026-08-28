import 'package:clock/clock.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/date_time_validation.dart';
import 'package:formularium/features/validators/_enums/input_date_format.dart';
import 'package:reef_utils/reef_utils.dart';

/// Validadores para campos de formulário de data, hora e data-hora.
class DateTimeFormFieldValidators {
  const DateTimeFormFieldValidators._();

  /// A instância singleton de [DateTimeFormFieldValidators].
  static DateTimeFormFieldValidators instance = const DateTimeFormFieldValidators._();

  /// Valida se um [DateTime] é posterior a [reference].
  ///
  /// Se [inclusive] for true, o valor também é válido quando igual a [reference].
  IUncategorizedFormFieldValidator<DateTime, DateTime> after(
    DateTime reference, {
    bool inclusive = false,
    InputDateFormat? format,
  }) => (DateTime value) {
    if (inclusive) {
      if (!value.isBefore(reference)) {
        return Validation(transformed: value, validation: null);
      }
      return Validation(
        transformed: reference,
        validation: DateTimeValidation.afterInclusive(reference, format: format),
      );
    }
    if (!value.isAfter(reference)) {
      return Validation(
        transformed: reference,
        validation: DateTimeValidation.after(reference, format: format),
      );
    }
    return Validation(transformed: value, validation: null);
  };

  /// Valida se um [DateTime] é anterior a [reference].
  ///
  /// Se [inclusive] for true, o valor também é válido quando igual a [reference].
  IUncategorizedFormFieldValidator<DateTime, DateTime> before(
    DateTime reference, {
    bool inclusive = false,
    InputDateFormat? format,
  }) => (DateTime value) {
    if (inclusive) {
      if (!value.isAfter(reference)) {
        return Validation(transformed: value, validation: null);
      }
      return Validation(
        transformed: reference,
        validation: DateTimeValidation.beforeInclusive(reference, format: format),
      );
    }
    if (!value.isBefore(reference)) {
      return Validation(
        transformed: reference,
        validation: DateTimeValidation.before(reference, format: format),
      );
    }
    return Validation(transformed: value, validation: null);
  };

  /// Valida se uma string é uma data válida no [format] informado.
  ///
  /// Transforma a string em um [DateTime] no final da unidade de data
  /// detectada (dia, mês, ano).
  IUncategorizedFormFieldValidator<String, DateTime> isDate({required InputDateFormat format}) => (String value) {
    var date = format.toDateFormat.tryParseStrict(value);
    date = date?.endOf(date.detect());

    if (date == null) {
      return Validation(transformed: clock.now(), validation: DateTimeValidation.invalid());
    }
    return Validation(transformed: date, validation: null);
  };

  /// Valida se uma string é uma data-hora ISO 8601 válida.
  ///
  /// Se [strict] for true, valida os valores reais da data (intervalo do mês,
  /// dias no mês, ano bissexto).
  /// Se [strictSeparator] for true, exige um separador 'T' entre as porções
  /// de data e hora.
  IUncategorizedFormFieldValidator<String, DateTime> isISO8601({
    bool strict = false,
    bool strictSeparator = false,
  }) => (String value) {
    final pattern = strictSeparator
        ? RegExp(
            r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|[+\-]\d{2}:?\d{2})$',
          )
        : RegExp(
            r'^(\d{4})-(\d{2})-(\d{2})(?:[T ](\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|[+\-]\d{2}:?\d{2})?)?$',
          );

    final match = pattern.firstMatch(value.trim());
    if (match == null) {
      return Validation(transformed: clock.now(), validation: DateTimeValidation.invalid());
    }

    if (strict) {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      if (!_isValidDate(year, month, day)) {
        return Validation(transformed: clock.now(), validation: DateTimeValidation.invalid());
      }
    }

    final dateTime = DateTime.tryParse(value.trim());
    if (dateTime == null) {
      return Validation(transformed: clock.now(), validation: DateTimeValidation.invalid());
    }
    return Validation(transformed: dateTime, validation: null);
  };

  /// Valida se uma string é uma data-hora RFC 3339 válida (ISO 8601 estrito com separador 'T').
  IUncategorizedFormFieldValidator<String, DateTime> isRFC3339() => isISO8601(strict: true, strictSeparator: true);

  /// Valida se uma string é um horário válido.
  ///
  /// Suporta formatos de 12 e 24 horas através de [hourFormat].
  /// Controla se segundos são obrigatórios, opcionais ou não permitidos através de [mode].
  IUncategorizedFormFieldValidator<String, ({int hour, int minute, int? second})> isTime({
    HourFormat hourFormat = HourFormat.hour24,
    TimeMode mode = TimeMode.default_,
  }) => (String value) {
    final pattern = switch ((hourFormat, mode)) {
      (HourFormat.hour24, TimeMode.default_) => RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$'),
      (HourFormat.hour24, TimeMode.withSeconds) => RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$'),
      (HourFormat.hour24, TimeMode.withOptionalSeconds) => RegExp(r'^([01]\d|2[0-3]):([0-5]\d)(?::([0-5]\d))?$'),
      (HourFormat.hour12, TimeMode.default_) => RegExp(r'^(0[1-9]|1[0-2]):([0-5]\d)\s*([APap][Mm])?$'),
      (HourFormat.hour12, TimeMode.withSeconds) => RegExp(r'^(0[1-9]|1[0-2]):([0-5]\d):([0-5]\d)\s*([APap][Mm])?$'),
      (HourFormat.hour12, TimeMode.withOptionalSeconds) => RegExp(
        r'^(0[1-9]|1[0-2]):([0-5]\d)(?::([0-5]\d))?\s*([APap][Mm])?$',
      ),
    };

    final match = pattern.firstMatch(value.trim());
    if (match == null) {
      return Validation(
        transformed: (hour: 0, minute: 0, second: null),
        validation: DateTimeValidation.invalidTime(
          value: value,
          hourFormat: hourFormat.name,
          mode: mode.name,
        ),
      );
    }

    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    int? second;
    if (match.groupCount >= 3 && match.group(3) != null) {
      second = int.tryParse(match.group(3)!);
    }

    return Validation(
      transformed: (hour: hour, minute: minute, second: second),
      validation: null,
    );
  };

  bool _isValidDate(int year, int month, int day) {
    if (month < 1 || month > 12) return false;
    final daysInMonth = <int>[0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var maxDay = daysInMonth[month];
    if (month == 2 && _isLeapYear(year)) maxDay = 29;
    return day >= 1 && day <= maxDay;
  }

  bool _isLeapYear(int year) => (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

/// Especifica o formato de hora para validação de horário.
enum HourFormat {
  /// Formato de 12 horas (AM/PM).
  hour12,

  /// Formato de 24 horas.
  hour24,
}

/// Especifica se os segundos são obrigatórios na validação de horário.
enum TimeMode {
  /// Sem segundos.
  default_,

  /// Segundos obrigatórios.
  withSeconds,

  /// Segundos opcionais.
  withOptionalSeconds,
}
