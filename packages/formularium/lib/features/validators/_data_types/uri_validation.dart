import 'package:formularium/features/localization/localizable_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

/// Hierarquia selada de resultados de validação de campo URI.
sealed class UriValidation implements ILocalizable {
  /// Construtor const padrão.
  const UriValidation();

  /// Cria um erro [InvalidUrl] para um valor que não é uma URL válida.
  static InvalidUrl invalidUrl(String value) => InvalidUrl(value);
}

/// O valor não é uma URL válida.
class InvalidUrl extends UriValidation {
  /// Cria um [InvalidUrl] com a string inválida [value].
  InvalidUrl(this.value);

  /// O valor bruto da string que não pôde ser interpretado como URL.
  final String value;

  @override
  String localize() => fL10n.validation_invalid_url(value);
}
