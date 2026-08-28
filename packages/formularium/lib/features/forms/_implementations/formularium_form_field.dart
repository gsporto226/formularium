import 'package:flutter/widgets.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/raw_formularium_form_field.dart';

/// [RawFormulariumFormField] com autovalidação baseada em [AutovalidateMode].
///
/// Escuta mudanças de foco e valor para validar conforme modo configurado.
class FormulariumFormField<T, Transformed> extends RawFormulariumFormField<T, Transformed> {
  /// Cria campo com autovalidação conforme [autovalidateMode].
  FormulariumFormField({
    required super.initialValue,
    required super.validator,
    required super.enabled,
    required AutovalidateMode autovalidateMode,
    required this._focusNode,
  }) : _autoValidateMode = autovalidateMode,
       super() {
    _focusNode?.addListener(_onFocusChanged);
    if (_autoValidateMode == AutovalidateMode.always) {
      validate();
    }
  }

  final AutovalidateMode _autoValidateMode;

  /// Modo de autovalidação do campo.
  AutovalidateMode get autovalidateMode => _autoValidateMode;

  final FocusNode? _focusNode;

  void _onFocusChanged() {
    switch (_autoValidateMode) {
      case AutovalidateMode.disabled:
        break;
      case AutovalidateMode.always:
        validate();
      case AutovalidateMode.onUserInteraction:
        if (!_focusNode!.hasFocus) {
          validate();
        }
      case .onUserInteractionIfError:
        if (status is Invalid) {
          validate();
        }
      case .onUnfocus:
        if (!_focusNode!.hasFocus) {
          validate();
        }
    }
  }

  @override
  set value(T value) {
    super.value = value;
    switch (_autoValidateMode) {
      case AutovalidateMode.always:
      case AutovalidateMode.onUserInteraction:
        validate();
      case AutovalidateMode.disabled:
        break;
      case .onUserInteractionIfError:
        if (status is Invalid) {
          validate();
        }
      default:
        break;
    }
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    switch (_autoValidateMode) {
      case AutovalidateMode.always:
        validate();
      case AutovalidateMode.disabled:
      case AutovalidateMode.onUserInteraction:
      case AutovalidateMode.onUnfocus:
      case AutovalidateMode.onUserInteractionIfError:
      // no-op
    }
  }

  @override
  void clear() {
    super.clear();
    switch (_autoValidateMode) {
      case AutovalidateMode.always:
        validate();
      case AutovalidateMode.disabled:
      case AutovalidateMode.onUserInteraction:
      case AutovalidateMode.onUnfocus:
      case AutovalidateMode.onUserInteractionIfError:
      // no-op
    }
  }
}
