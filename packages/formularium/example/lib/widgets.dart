import 'package:concierge/context_interface.dart';
import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_interfaces/form_field_interface.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'localizations.dart';


class FormFieldTile<T, Transformed> extends StatefulWidget {
  const FormFieldTile({
    super.key,
    required this.field,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.errorBuilder,
  });

  final IFormField<T, Transformed> field;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final Widget Function(FormFieldStatus<Transformed> status)? errorBuilder;

  @override
  State<FormFieldTile<T, Transformed>> createState() => _FormFieldTileState<T, Transformed>();
}

class _FormFieldTileState<T, Transformed> extends State<FormFieldTile<T, Transformed>> {
  @override
  void initState() {
    super.initState();
    widget.field.$status.addListener(_onChanged);
    widget.field.$enabled.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(FormFieldTile<T, Transformed> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.field != oldWidget.field) {
      oldWidget.field.$status.removeListener(_onChanged);
      oldWidget.field.$enabled.removeListener(_onChanged);
      widget.field.$status.addListener(_onChanged);
      widget.field.$enabled.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.field.$status.removeListener(_onChanged);
    widget.field.$enabled.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final field = widget.field;
    final enabled = field.enabled;
    final status = field.status;
    final appContext = const AppContext();
    final errorText = _extractError(status, appContext);
    final errorWidget = widget.errorBuilder?.call(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: !enabled ? Colors.grey : null,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          enabled: enabled,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: const OutlineInputBorder(),
            errorText: errorWidget != null ? null : errorText,
            filled: !enabled,
            fillColor: !enabled ? Colors.grey.shade200 : null,
          ),
          onChanged: (value) => field.value = value as T,
        ),
        if (errorWidget != null) ...[const SizedBox(height: 6), errorWidget],
      ],
    );
  }

String? _extractError(FormFieldStatus<Transformed> status, IContext context) => switch (status) {
  Invalid(:final validation) => validation.validation.localize(context),
  Valid(:final validation) when validation != null => validation.validation.localize(context),
  _ => null,
};
}

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({super.key, required this.status});

  final FormFieldStatus<String> status;

  @override
  Widget build(BuildContext context) {
    final weakPassword = switch (status) {
      Invalid(:final validation) when validation.validation is WeakPassword => validation.validation as WeakPassword,
      _ => null,
    };

    if (weakPassword == null) {
      return const SizedBox.shrink();
    }

    final score = weakPassword.score;
    final minScore = weakPassword.minScore;
    final progress = minScore > 0 ? (score / minScore).clamp(0.0, 1.5) : 1.0;
    final minLength = weakPassword.minLength;

    final color = switch (progress) {
      < 0.5 => Colors.red,
      < 1.0 => Colors.orange,
      < 1.2 => Colors.green,
      _ => Colors.green.shade700,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        _Requirement(
          label: 'Mínimo $minLength caracteres',
          met: weakPassword.hasLength,
        ),
        _Requirement(
          label: 'Uma letra minúscula',
          met: weakPassword.hasLowercase,
        ),
        _Requirement(
          label: 'Uma letra maiúscula',
          met: weakPassword.hasUppercase,
        ),
        _Requirement(label: 'Um número', met: weakPassword.hasNumbers),
        _Requirement(label: 'Um símbolo', met: weakPassword.hasSymbols),
      ],
    );
  }
}

class _Requirement extends StatelessWidget {
  const _Requirement({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 1),
    child: Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          size: 14,
          color: met ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: met ? Colors.green.shade700 : Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}
