import 'package:concierge/context_interface.dart';
import 'package:formularium/features/localization/localizable_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

/// Hierarquia selada de resultados de validação de campo de latitude/longitude.
sealed class LatLongValidation implements ILocalizable {
  /// Construtor const padrão.
  const LatLongValidation();

  /// Cria um erro [InvalidLatLong] para um valor que não é uma latitude/longitude válida.
  static InvalidLatLong invalidLatLong(String value) => InvalidLatLong(value);
}

/// O valor não é um par de latitude/longitude válido.
class InvalidLatLong extends LatLongValidation {
  /// Cria um [InvalidLatLong] com a string inválida [value].
  InvalidLatLong(this.value);

  /// O valor bruto da string que não pôde ser interpretado como latitude/longitude.
  final String value;

  @override
  String localize(IContext context) => context.fL10n.validation_invalid_lat_long(value);
}
