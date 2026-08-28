/// Re-exporta o contrato de localização do pacote `formularium_localization`.
///
/// Mantém os imports existentes (`package:formularium/features/localization/localizable_interface.dart`)
/// funcionando enquanto aponta para o [ILocalizable] real (não-genérico e
/// sem contexto) definido em `localize`.
library;

export 'package:formularium_localization/formularium_localization.dart';