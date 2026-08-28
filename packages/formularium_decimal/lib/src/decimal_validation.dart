import 'package:concierge/context_interface.dart';
import 'package:decimal/decimal.dart';
import 'package:formularium_decimal/src/decimal_localizations.dart';
import 'package:intl/intl.dart';
import 'package:localization_interface/localization_interface.dart';

/// Hierarquia selada de estados de validação decimal, cada um localizável.
sealed class DecimalValidation implements ILocalizable {
  /// Cria uma validação [DecimalTooBig] para o [maxValue] informado.
  static DecimalTooBig max(Decimal maxValue) => DecimalTooBig(maxValue);

  /// Cria uma validação [DecimalTooSmall] para o [minValue] informado.
  static DecimalTooSmall min(Decimal minValue) => DecimalTooSmall(minValue);
}

/// Validação indicando que o valor decimal excedeu o máximo permitido.
class DecimalTooBig implements DecimalValidation {
  /// Constrói um [DecimalTooBig] com o [maxValue] informado.
  DecimalTooBig(this.maxValue);

  /// O valor decimal máximo permitido.
  final Decimal maxValue;

  @override
  String localize(IContext context) {
    final fdL10n = context.fdL10n;
    final formatted = NumberFormat.currency(locale: fdL10n.localeName, symbol: r'R$').format(maxValue);
    return fdL10n.decimal_field_value_too_big(formatted);
  }
}

/// Validação indicando que o valor decimal ficou abaixo do mínimo permitido.
class DecimalTooSmall implements DecimalValidation {
  /// Constrói um [DecimalTooSmall] com o [minValue] informado.
  DecimalTooSmall(this.minValue);

  /// O valor decimal mínimo permitido.
  final Decimal minValue;

  @override
  String localize(IContext context) {
    final fdL10n = context.fdL10n;
    final formatted = NumberFormat.currency(locale: fdL10n.localeName, symbol: r'R$').format(minValue);
    return fdL10n.decimal_field_value_too_small(formatted);
  }
}
