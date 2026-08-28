/// Contrato de localização do ecossistema formularium.
///
/// A resolução é feita sem BuildContext: o locale corrente vive em
/// `Intl.defaultLocale`, sincronizado pelo delegate de cada pacote consumidor.
library;

/// Algo que pode ser localizado.
abstract interface class ILocalizable {
  /// Localiza esta mensagem usando o locale corrente.
  String localize();
}
