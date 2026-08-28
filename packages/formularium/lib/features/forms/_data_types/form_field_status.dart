import 'package:flutter/widgets.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';
import 'package:formularium/features/forms/_interfaces/form_field_interface.dart';
import 'package:formularium/features/localization/localizable_interface.dart';

/// Indica o status do [IFormField] em relação à validação
sealed class FormFieldStatus<Transformed> {
  const FormFieldStatus();

  /// Mapeia cada variante de status para um valor [R].
  R map<R>({
    required R Function(Valid<Transformed> valid) valid,
    required R Function(Invalid<Transformed> invalid) invalid,
    required R Function(Validating<Transformed> validating) validating,
    required R Function(Pending<Transformed> pending) pending,
  }) {
    switch (this) {
      case final Valid<Transformed> value:
        return valid(value);
      case final Invalid<Transformed> value:
        return invalid(value);
      case final Validating<Transformed> value:
        return validating(value);
      case final Pending<Transformed> value:
        return pending(value);
    }
  }
}

/// Status válido — campo passou na validação.
/// Contém valor transformado e warning opcional.
@immutable
class Valid<Transformed> extends FormFieldStatus<Transformed> {
  /// Cria status válido com [transformed] e [validation] opcional.
  const Valid({required this.transformed, this.validation});

  /// Valor transformado após validação bem-sucedida.
  final Transformed transformed;

  /// Resultado da validação, podendo conter um warning.
  final ValidationBundle? validation;

  /// Não é pendente.
  bool get pending => false;

  /// Não está em validação.
  bool get validating => false;

  @override
  int get hashCode => Object.hash(transformed, validation);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Valid<Transformed> && other.transformed == transformed && other.validation == validation);

  @override
  String toString() => 'Valid(transformed: $transformed, validation: $validation)';
}

/// Status inválido — campo não passou na validação.
@immutable
class Invalid<Transformed> extends FormFieldStatus<Transformed> {
  /// Cria status inválido com [transformed] e [validation].
  const Invalid({required this.transformed, required this.validation});

  /// Valor transformado disponível no momento da invalidação.
  final Transformed transformed;

  /// Resultado da validação, obrigatoriamente um erro.
  final ValidationBundle validation;

  /// Não é pendente.
  bool get pending => false;

  /// Não está em validação.
  bool get validating => false;

  @override
  int get hashCode => Object.hash(transformed, validation);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invalid<Transformed> && other.transformed == transformed && other.validation == validation);

  @override
  String toString() => 'Invalid(transformed: $transformed, validation: $validation)';
}

/// Status pendente — campo ainda não foi validado.
@immutable
class Pending<Transformed> extends FormFieldStatus<Transformed> {
  /// Cria status pendente.
  const Pending();

  /// Ausência de erro de validação.
  ILocalizable? get validation => null;

  /// Nenhum valor transformado disponível.
  Transformed? get transformed => null;

  /// É pendente.
  bool get pending => true;

  /// Não está em validação.
  bool get validating => false;

  @override
  int get hashCode => 0xabf33dc;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Pending;
}

/// Status validando — campo está atualmente passando por validação assíncrona.
@immutable
class Validating<Transformed> extends FormFieldStatus<Transformed> {
  /// Cria status validando.
  const Validating();

  /// Ausência de erro de validação.
  ILocalizable? get validation => null;

  /// Nenhum valor transformado disponível.
  Transformed? get transformed => null;

  /// Não é pendente.
  bool get pending => false;

  /// Está em validação.
  bool get validating => true;

  @override
  int get hashCode => 0xdecafbad;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Validating<Transformed>;
}
