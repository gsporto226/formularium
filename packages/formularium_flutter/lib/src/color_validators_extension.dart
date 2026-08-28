import 'package:formularium/features/forms/_utils/form_field_validators.dart';
import 'package:formularium_flutter/src/color_validators.dart';

/// Extensão que adiciona validadores de cor a [FormFieldValidators].
extension ColorValidatorsExtension on FormFieldValidators {
  /// Acessor para a instância de [ColorFormFieldValidators].
  ColorFormFieldValidators get color => ColorFormFieldValidators.instance;
}
