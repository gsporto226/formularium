import 'package:formularium/features/forms/_utils/form_field_validators.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

/// Extensão em [FormFieldValidators] para expor [StringValidators] através do getter `string`.
extension StringValidatorsExtension on FormFieldValidators {
  /// A instância singleton de [StringValidators].
  StringValidators get string => StringValidators.instance;
}
