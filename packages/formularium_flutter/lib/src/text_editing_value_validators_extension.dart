import 'package:formularium/features/forms/_utils/form_field_validators.dart';
import 'package:formularium_flutter/src/text_editing_value_validators.dart';

/// Extensão que adiciona validadores de valor de edição de texto a [FormFieldValidators].
extension TextEditingValueValidatorsExtension on FormFieldValidators {
  /// Acessor para a instância de [TextEditingValueValidators].
  TextEditingValueValidators get textEditingValue => TextEditingValueValidators.instance;
}
