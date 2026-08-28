import 'package:flutter/foundation.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';
import 'package:formularium/features/forms/_implementations/form_field_validators.dart';
import 'package:formularium/features/forms/_interfaces/form_field_interface.dart';

/// Implementação base de [IFormField].
///
/// Gerencia valor, estado (dirty/pure), enabled e validação via [ValueNotifier].
/// Não faz validação automática — apenas sob comando via [validate].
class RawFormulariumFormField<T, Transformed> implements IFormField<T, Transformed> {
  /// Cria campo com [initialValue], [validator] e estado [enabled].
  RawFormulariumFormField({
    required this.initialValue,
    required FormFieldValidatorBundle<T, Transformed> validator,
    required bool enabled,
  }) : _$enabled = ValueNotifier(enabled),
       _$value = ValueNotifier(initialValue),
       _$status = ValueNotifier(const Pending()) {
    _validator = FormFieldValidator(fn: validator.validator, type: validator.type, invalidates: validator.invalidates);
    _validator.value(initialValue);
    _validator.addListener(_validate);
  }

  /// Valor inicial do campo.
  final T initialValue;

  late final FormFieldValidator<T, Transformed> _validator;
  final ValueNotifier<bool> _$enabled;

  @override
  bool get enabled => _$enabled.value;
  @override
  set enabled(bool enabled) => _$enabled.value = enabled;
  @override
  ValueListenable<bool> get $enabled => _$enabled;

  /// O primeiro valor é sempre puro, todo valor posterior é dirty
  final ValueNotifier<FormFieldState> _$state = ValueNotifier(
    FormFieldState.pure,
  );

  @override
  late final ValueNotifier<FormFieldState> $state = _$state;

  @override
  FormFieldState get state => $state.value;

  final ValueNotifier<T> _$value;
  final ValueNotifier<FormFieldStatus<Transformed>> _$status;

  @override
  ValueNotifier<FormFieldStatus<Transformed>> get $status => _$status;

  @override
  FormFieldStatus<Transformed> get status => $status.value;

  @override
  FormFieldStatus<Transformed> validate() {
    _validator.validate();
    return _validate();
  }

  FormFieldStatus<Transformed> _validate() {
    _$status.value = _mapResult(_validator.result);
    return _$status.value;
  }

  FormFieldStatus<Transformed> _mapResult(ValidationResult<Transformed> r) => switch (r) {
    ValidationPending() => const Pending(),
    ValidationValidating() => const Validating(),
    ValidationDone<Transformed>(:final validation, :final transformed) =>
      (validation != null && _validator.invalidates)
          ? Invalid(transformed: transformed, validation: validation)
          : Valid(transformed: transformed, validation: validation),
  };

  @override
  FormFieldStatus<Transformed> validateDirty() {
    if (state == FormFieldState.dirty) {
      return validate();
    }
    return _$status.value;
  }

  /// Altera o valor sem disparar validação nem marcar dirty.
  void valueRaw(T value) {
    _$value.value = value;
    _$status.value = const Pending();
    _validator.value(value);
  }

  @override
  set value(T value) {
    _$value.value = value;
    _$state.value = FormFieldState.dirty;
    _$status.value = const Pending();
    _validator.value(value);
  }

  /// Libera recursos dos [ValueNotifier]s internos.
  void dispose() {
    _$enabled.dispose();
    _$status.dispose();
    _$state.dispose();
    _$value.dispose();
    _validator.dispose();
  }

  @override
  void reset() {
    _$state.value = FormFieldState.pure;
    _validator.reset();
    valueRaw(initialValue);
  }

  @override
  void clear() {
    _$state.value = FormFieldState.pure;
    _validator.reset();
    valueRaw(null is T ? null as T : initialValue);
  }
}
