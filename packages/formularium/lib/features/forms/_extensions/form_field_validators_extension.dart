import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';

/// Converte um validador não categorizado em categorizado (error ou warning).
extension CategorizeFormFieldValidator<T, Transformed> on IUncategorizedFormFieldValidator<T, Transformed> {
  /// Converte para validador categorizado: falha → erro, sucesso → pass.
  FormFieldValidatorBundle<T, Transformed> error() => CategorizedFormFieldValidators.instance.error(this);

  /// Converte para validador categorizado: falha vira pass com warning.
  FormFieldValidatorBundle<T, Transformed> warning() => CategorizedFormFieldValidators.instance.warning(this);
}
