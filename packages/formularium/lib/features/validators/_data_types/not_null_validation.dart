import 'package:formularium/features/localization/localizable_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

/// Indica que um campo obrigatório está ausente.
final class RequiredValidation implements ILocalizable {
  /// Uma instância constante de [RequiredValidation].
  const RequiredValidation();

  @override
  String localize() => fL10n.required_field_label;
}
