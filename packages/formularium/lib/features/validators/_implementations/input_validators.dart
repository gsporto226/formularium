import 'package:formularium/features/validators/_enums/input_date_format.dart';

/// Coleção de funções de validação de entrada para campos de formulário.
class InputValidators {
  const InputValidators._();

  /// Retorna um validador que verifica se a entrada é uma data válida no formato [inputDateFormat].
  /// Retorna [invalidDateMessage] quando a análise falha.
  static String? Function(String?) date({
    required InputDateFormat inputDateFormat,
    required String invalidDateMessage,
  }) => (String? value) {
    final dateFormat = inputDateFormat.toDateFormat;
    final result = dateFormat.tryParseLoose(value ?? '');
    if (result == null) {
      return invalidDateMessage;
    }
    return null;
  };
}
