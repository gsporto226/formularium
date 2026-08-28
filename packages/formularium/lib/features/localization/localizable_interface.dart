/// Re-exporta o contrato de localização do pacote `localization_interface`.
///
/// Mantém os imports existentes (`package:formularium/features/localization/localizable_interface.dart`)
/// funcionando enquanto aponta para o [ILocalizable] real (não-genérico) que
/// recebe um [IContext] em `localize`.
library;

export 'package:localization_interface/localization_interface.dart';