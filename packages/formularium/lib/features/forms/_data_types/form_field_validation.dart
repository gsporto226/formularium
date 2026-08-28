import 'package:formularium/features/localization/localizable_interface.dart';

/// Representa problemas de validação (warning ou erro).
/// Usado para transportar resultado de validação sem vincular ao status do campo.
sealed class FormFieldValidation<T, Transformed> {
  /// Cria validação do tipo warning.
  static Warning<T, Transformed> warning<T, Transformed>({
    required ILocalizable validation,
    required Transformed transformed,
  }) => Warning(validation: validation, transformed: transformed);

  /// Cria validação do tipo erro.
  static Error<T, Transformed> error<T, Transformed>(ILocalizable validation) => Error(validation);

  /// Converte o tipo genérico [T] para [R], mantendo o mesmo tipo de validação.
  FormFieldValidation<R, Transformed> cast<R>() => switch (this) {
    Warning(:final validation, :final transformed) => FormFieldValidation.warning(
      validation: validation,
      transformed: transformed,
    ),
    Error(:final validation) => FormFieldValidation.error(validation),
  };

  /// Transforma o valor [Transformed] usando [mapper], mantendo validação.
  FormFieldValidation<T, R> mapTransformed<R>(R Function(Transformed validation) mapper) => switch (this) {
    Warning(:final validation, :final transformed) => FormFieldValidation.warning(
      validation: validation,
      transformed: mapper(transformed),
    ),
    Error(:final validation) => FormFieldValidation.error(validation),
  };
}

/// Advertência — campo válido mas com ressalva.
class Warning<T, Transformed> extends FormFieldValidation<T, Transformed> {
  /// Cria warning com [validation] e valor [transformed].
  Warning({required this.validation, required this.transformed});

  /// Mensagem de advertência.
  final ILocalizable validation;

  /// Valor transformado mesmo com warning.
  final Transformed transformed;
}

/// Erro — campo inválido.
class Error<T, Transformed> extends FormFieldValidation<T, Transformed> {
  /// Cria erro com mensagem de [validation].
  Error(this.validation);

  /// Mensagem de erro.
  final ILocalizable validation;
}
