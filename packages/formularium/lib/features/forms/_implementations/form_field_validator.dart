import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/localization/localizable_interface.dart';

/// Classe interna para gerenciar validação de campo de formulário.
///
/// Não deve ser usada diretamente em código de usuário.
@protected
class FormFieldValidator<T, Transformed> extends ChangeNotifier {
  /// Cria validador com função de validação [_fn] e tipo [type].
  FormFieldValidator({required this._fn, required this.type, required this.invalidates});

  /// Cria validador a partir de [_fn] que recebe valor e retorna [ValidationResult]
  /// (síncrono) ou [Future<ValidationResult>] (assíncrono).

  final FutureOr<Validation<Transformed>> Function(T) _fn;

  /// Tipo de validação (ex: 'error' ou 'warning').
  final String type;

  /// Indica se esta validação invalida o campo
  final bool invalidates;

  ValidationResult<Transformed> _latest = const ValidationPending();

  int _generation = 0;
  int _lastEmittedGeneration = -1;

  /// O resultado mais recente da validação.
  ValidationResult<Transformed> get result => _latest;

  /// Setter interno para atualizar o valor e notificar os ouvintes.
  /// Não usar em código de usuário.
  void value(T input) {
    final currentGeneration = ++_generation;
    final r = _fn(input);
    if (r is Future<Validation<Transformed>>) {
      _latest = const ValidationValidating();
      r.then((value) {
        if (currentGeneration == _generation) {
          _latest = ValidationDone(
            transformed: value.transformed,
            validation: value.validation != null ? ValidationBundle(type: type, validation: value.validation!) : null,
          );
          notifyListeners();
        }
      }, onError: _onAsyncError);
    } else {
      _latest = ValidationDone(
        transformed: r.transformed,
        validation: r.validation != null ? ValidationBundle(type: type, validation: r.validation!) : null,
      );
    }
  }

  /// Validação interna.
  /// Não usar em código de usuário.
  void validate() {
    if (_generation != _lastEmittedGeneration) {
      _lastEmittedGeneration = _generation;
      notifyListeners();
    }
  }

  /// Reseta o validador para estado pendente.
  void reset() {
    _latest = const ValidationPending();
    _generation = 0;
    _lastEmittedGeneration = -1;
    notifyListeners();
  }

  void _onAsyncError(Object e, StackTrace s) {
    throw ValidationFNShouldNeverThrowError(
      'Validation function threw an exception. '
      'Validation functions must not throw. '
      'Instead, catch errors and return ValidationFail with an ILocalizable.',
      e,
      s,
    );
  }
}

/// Erro lançado quando uma função de validação lança exceção.
///
/// Validações devem capturar erros e retornar [Validation] com [ILocalizable].
class ValidationFNShouldNeverThrowError extends Error {
  /// Cria erro com [message], [originalError] e [originalStack].
  ValidationFNShouldNeverThrowError(this.message, this.originalError, this.originalStack);

  /// Mensagem descritiva.
  final String message;

  /// Erro original.
  final Object originalError;

  /// Stack trace original.
  final StackTrace originalStack;

  @override
  String toString() =>
      'ValidationFunctionError: $message\n'
      'Original error: $originalError\n'
      'Original stack: $originalStack';
}

/// Resultado de uma validacao
sealed class ValidationResult<Transformed> {
  /// Cria um [ValidationResult].
  const ValidationResult();
}

/// Validação bem-sucedida. Contém valor transformado e aviso opcional.
class ValidationDone<Transformed> extends ValidationResult<Transformed> {
  /// Validacao concluída.
  const ValidationDone({required this.transformed, required this.validation});

  /// Valor transformado pela validação.
  final Transformed transformed;

  /// Validação categorizada (ex: 'error' ou 'warning').
  final ValidationBundle? validation;
}

/// Validação não categorizada bem-sucedida. Contém valor transformado.
class ValidationPending<Transformed> implements ValidationResult<Transformed> {
  /// Cria resultado de validação pendente.
  const ValidationPending();
}

/// Validação em andamento.
class ValidationValidating<Transformed> implements ValidationResult<Transformed> {
  /// Cria resultado de validação em andamento.
  const ValidationValidating();
}

/// Um pacote de resultado de validação categorizado contendo um rótulo de tipo e uma mensagem de validação localizável.
@immutable
class ValidationBundle {
  /// Cria bundle de validação com [type] e [validation].
  const ValidationBundle({required this.type, required this.validation});

  /// Categoria da validação (ex: 'error' ou 'warning').
  final String type;

  /// Localizable retornado pela validacao.
  final ILocalizable validation;

  @override
  int get hashCode => Object.hash(type, validation);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ValidationBundle && other.type == type && other.validation == validation);

  @override
  String toString() => 'ValidationBundle(type: $type, validation: $validation)';
}
