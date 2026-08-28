import 'package:formularium/features/localization/localizable_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

/// Hierarquia selada de resultados de validação de campo booleano.
sealed class BooleanValidation implements ILocalizable {
  /// Construtor const padrão.
  const BooleanValidation();

  /// Cria um erro [NotABoolean] para um valor que não é um booleano válido.
  static NotABoolean notABoolean(String value) => NotABoolean(value);
}

/// O valor não é uma representação booleana válida.
class NotABoolean extends BooleanValidation {
  /// Cria um [NotABoolean] com a string inválida [value].
  NotABoolean(this.value);

  /// O valor bruto da string que não pôde ser interpretado como booleano.
  final String value;

  @override
  String localize() => fL10n.validation_not_a_boolean(value);
}
