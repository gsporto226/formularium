import 'package:flutter/foundation.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_interfaces/form_entity_interface.dart';

/// Passthrough mixin to implement IFormEntity<T> with a formularium
/// field.
mixin FormulariumMixin<T> implements IFormEntity<T> {
  IFormEntity<T> get formularium;

  @override
  ValueListenable<FormFieldStatus<T>> get $status => formularium.$status;

  @override
  FormFieldStatus<T> get status => formularium.status;

  @override
  ValueListenable<FormFieldState> get $state => formularium.$state;

  @override
  FormFieldState get state => formularium.state;

  @override
  bool get enabled => formularium.enabled;

  @override
  set enabled(bool enabled) => formularium.enabled = enabled;

  @override
  ValueListenable<bool> get $enabled => formularium.$enabled;

  @override
  FormFieldStatus<T> validate() => formularium.validate();

  @override
  FormFieldStatus<T> validateDirty() => formularium.validateDirty();

  @override
  void reset() => formularium.reset();

  @override
  void clear() => formularium.clear();
}
