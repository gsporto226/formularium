import 'package:flutter/foundation.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_interfaces/form_entity_interface.dart';

class VariantFormularium<K, T> implements IFormEntity<T> {
  VariantFormularium({
    required this._variants,
    required this._selector,
  }) {
    if (!_variants.containsKey(_selector.value)) {
      throw ArgumentError('Selector initial value not found in variants');
    }
    _selector.addListener(_onSelectorChanged);
    _updateActive();
  }

  final Map<K, IFormEntity<T>> _variants;
  final ValueListenable<K> _selector;

  final ValueNotifier<bool> _enabledNotifier = ValueNotifier(true);
  final ValueNotifier<FormFieldState> _stateNotifier = ValueNotifier(FormFieldState.pure);
  final ValueNotifier<FormFieldStatus<T>> _statusNotifier = ValueNotifier(const Pending());

  IFormEntity<T>? _lastActive;
  VoidCallback? _onEnabledChanged;
  VoidCallback? _onStateChanged;
  VoidCallback? _onStatusChanged;

  IFormEntity<T> get _active => _variants[_selector.value]!;

  @override
  ValueListenable<bool> get $enabled => _enabledNotifier;
  @override
  ValueListenable<FormFieldState> get $state => _stateNotifier;
  @override
  ValueListenable<FormFieldStatus<T>> get $status => _statusNotifier;

  @override
  bool get enabled => _enabledNotifier.value;
  @override
  set enabled(bool value) => _active.enabled = value;
  @override
  FormFieldState get state => _stateNotifier.value;
  @override
  FormFieldStatus<T> get status => _statusNotifier.value;

  void _onSelectorChanged() {
    _updateActive();
    _active.validateDirty();
  }

  void _updateActive() {
    _removeListeners();

    final active = _active;

    _enabledNotifier.value = active.enabled;
    _stateNotifier.value = active.state;
    _statusNotifier.value = active.status;

    _lastActive = active;

    _onEnabledChanged = () => _enabledNotifier.value = active.$enabled.value;
    _onStateChanged = () => _stateNotifier.value = active.$state.value;
    _onStatusChanged = () => _statusNotifier.value = active.$status.value;

    active.$enabled.addListener(_onEnabledChanged!);
    active.$state.addListener(_onStateChanged!);
    active.$status.addListener(_onStatusChanged!);
  }

  void _removeListeners() {
    final last = _lastActive;
    if (last == null) return;

    if (_onEnabledChanged != null) last.$enabled.removeListener(_onEnabledChanged!);
    if (_onStateChanged != null) last.$state.removeListener(_onStateChanged!);
    if (_onStatusChanged != null) last.$status.removeListener(_onStatusChanged!);

    _onEnabledChanged = null;
    _onStateChanged = null;
    _onStatusChanged = null;
  }

  @override
  FormFieldStatus<T> validate() => _active.validate();
  @override
  FormFieldStatus<T> validateDirty() => _active.validateDirty();
  @override
  void reset() => _active.reset();
  @override
  void clear() => _active.clear();

  void dispose() {
    _selector.removeListener(_onSelectorChanged);
    _removeListeners();
    _enabledNotifier.dispose();
    _stateNotifier.dispose();
    _statusNotifier.dispose();
  }
}
