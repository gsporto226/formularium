import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';

/// Utilitário para converter [IUncategorizedFormFieldValidator] em [FormFieldValidatorBundle].
class CategorizedFormFieldValidators {
  const CategorizedFormFieldValidators._();

  /// Instância singleton.
  static const CategorizedFormFieldValidators instance = CategorizedFormFieldValidators._();

  /// Converte [validator] não categorizado em categorizado: erro
  FormFieldValidatorBundle<T, Transformed> error<T, Transformed>(
    IUncategorizedFormFieldValidator<T, Transformed> validator,
  ) => FormFieldValidatorBundle(validator: validator, type: 'error', invalidates: true);

  /// Converte [validator] não categorizado em categorizado: aviso
  FormFieldValidatorBundle<T, Transformed> warning<T, Transformed>(
    IUncategorizedFormFieldValidator<T, Transformed> validator,
  ) => FormFieldValidatorBundle(validator: validator, type: 'warning', invalidates: false);
}

/// Pacote para construir um validador categorizado.
class FormFieldValidatorBundle<T, Transformed> {
  /// Cria bundle de validador a partir de [validator] e [type] (ex: 'error' ou 'warning').
  FormFieldValidatorBundle({required this.validator, required this.type, required this.invalidates});

  /// Validador não categorizado.
  final IUncategorizedFormFieldValidator<T, Transformed> validator;

  /// Tipo de validação (ex: 'error' ou 'warning').
  final String type;

  /// Se true, falha nesta validação invalida o campo (status = invalid).
  final bool invalidates;
}
