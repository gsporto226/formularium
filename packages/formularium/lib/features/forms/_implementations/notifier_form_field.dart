import 'package:flutter/widgets.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';

/// Um form vinculado a um [ValueNotifier], toda vez que o valor do notifier muda, o valor do form field
/// atualiza, e quando se atualiza o valor do form field, o valor do notifier atualiza.
/// Vinculado a um [ValueNotifier].
///
/// Bidirecional: mudanças no notifier atualizam o campo e vice-versa.
class NotifierFormulariumField<T, Transformed> extends FormulariumFormField<T, Transformed> {
  /// Cria campo vinculado ao [controller], sincronizando valor bidirecionalmente.
  NotifierFormulariumField({
    required this.controller,
    required super.validator,
    required super.focusNode,
    required super.autovalidateMode,
    super.enabled = true,
  }) : super(initialValue: controller.value) {
    controller.addListener(_onNotifierValueChanged);
    if (autovalidateMode != AutovalidateMode.always) {
      valueRaw(controller.value);
      return;
    }
    super.value = controller.value;
  }

  /// Notifier externo sincronizado com o campo.
  final ValueNotifier<T> controller;

  void _onNotifierValueChanged() {
    super.value = controller.value;
  }

  @override
  set value(T value) {
    controller.value = value;
    super.value = value;
  }

  @override
  void dispose() {
    controller.removeListener(_onNotifierValueChanged);
  }

  @override
  void reset() {
    controller.removeListener(_onNotifierValueChanged);
    controller.value = super.initialValue;
    super.reset();
    controller.addListener(_onNotifierValueChanged);
  }

  @override
  void clear() {
    controller.removeListener(_onNotifierValueChanged);
    super.clear();
    controller.value = null is T ? null as T : initialValue;
    controller.addListener(_onNotifierValueChanged);
  }
}
