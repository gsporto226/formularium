import 'package:formularium/features/forms/_utils/form_field_validators.dart';
import 'package:formularium_decimal/src/decimal_form_field_validators.dart';

/// Extensão em [FormFieldValidators] que fornece acesso a validadores
/// específicos para decimais.
extension DecimalValidatorsExtension on FormFieldValidators {
  /// Retorna a instância singleton de [DecimalFormFieldValidators].
  DecimalFormFieldValidators get decimal => DecimalFormFieldValidators.instance;
}
