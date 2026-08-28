import 'package:flutter/widgets.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';

/// Validadores para campos do tipo [TextEditingValue].
class TextEditingValueValidators {
  const TextEditingValueValidators._();

  /// Instância singleton de [TextEditingValueValidators].
  static TextEditingValueValidators instance = const TextEditingValueValidators._();

  /// Retorna um validador que converte um [TextEditingValue] no seu texto [String].
  IUncategorizedFormFieldValidator<TextEditingValue, String> asString() =>
      (TextEditingValue value) => Validation(transformed: value.text, validation: null);
}
