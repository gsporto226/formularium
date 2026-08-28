import 'package:formularium/features/forms/_utils/form_field_validators.dart';
import 'package:formularium/features/validators/_validators/number_form_field_validators.dart';

/// Extensão em [FormFieldValidators] para expor [NumberFormFieldValidators] através do getter `number`.
extension NumberValidatorsExtension on FormFieldValidators {
  /// A instância singleton de [NumberFormFieldValidators].
  NumberFormFieldValidators get number => NumberFormFieldValidators.instance;
}
