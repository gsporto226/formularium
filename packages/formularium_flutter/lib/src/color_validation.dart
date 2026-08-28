import 'package:concierge/context_interface.dart';
import 'package:formularium_flutter/src/color_localizations.dart';
import 'package:formularium/features/localization/localizable_interface.dart';

/// Classe base selada para resultados de validação de cor.
///
/// Suporta localização via [ILocalizable].
sealed class ColorValidation implements ILocalizable {
  const ColorValidation();

  /// Cria uma validação [InvalidColor] para o [value] informado.
  static InvalidColor invalidColor(String value) => InvalidColor(value);
}

/// Uma validação indicando um valor de cor inválido.
class InvalidColor extends ColorValidation {
  /// Cria um [InvalidColor] com o [value] fornecido.
  InvalidColor(this.value);

  /// A string de cor inválida que falhou na validação.
  final String value;

  @override
  String localize(IContext context) => context.ffL10n.validation_invalid_color(value);
}
