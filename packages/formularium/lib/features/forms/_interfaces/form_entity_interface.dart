import 'package:flutter/foundation.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';

/// Interface de leitura de um campo de formulário.
///
/// Expõe status (validação), estado (dirty/pure) e enabled.
abstract class IFormEntity<T> {
  /// Observable do status de validação.
  ValueListenable<FormFieldStatus<T>> get $status;

  /// Status atual de validação.
  FormFieldStatus<T> get status => $status.value;

  /// Observable do estado (dirty/pure).
  ValueListenable<FormFieldState> get $state;

  /// Estado atual (dirty se modificado, pure se inicial).
  FormFieldState get state => $state.value;

  /// Se o form field está ativo.
  bool get enabled;

  /// Ativa/desativa o campo.
  set enabled(bool enabled);

  /// Observable de enabled.
  ValueListenable<bool> get $enabled;

  /// Dispara validação do campo. Por padrão, campos não validam ao alterar valor — apenas sob comando.
  FormFieldStatus<T> validate();

  /// Valida apenas campos que foram modificados ([FormFieldState.dirty]).
  /// Para entidades simples, delega para [validate]; para grupos, itera sobre os campos
  /// e valida apenas os que estão dirty.
  FormFieldStatus<T> validateDirty();

  /// Reseta o campo ao valor inicial e estado pure.
  void reset();

  /// Limpa todos os campos (nulo se possível ou valor inicial em estado puro)
  void clear();
}
