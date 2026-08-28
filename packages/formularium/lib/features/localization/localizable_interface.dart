/// Re-exporta o contrato de localização do pacote `formularium_localization`.
///
/// Mantém os imports existentes
/// (`package:formularium/features/localization/localizable_interface.dart`)
/// funcionando apontando para o [ILocalizable] real do pacote
/// `formularium_localization` (não-genérico e sem contexto).
library;

export 'package:formularium_localization/formularium_localization.dart';
