import 'dart:async';

import 'package:concierge/context_interface.dart';
import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/forms/_utils/form_field_validators.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';
import 'package:formularium/features/localization/localizable_interface.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';
import 'package:formularium_example/widgets.dart';

class UsernameTaken implements ILocalizable {
  const UsernameTaken();
  @override
  String localize(IContext context) => 'Nome de usuário já está em uso';
}

class EmailTaken implements ILocalizable {
  const EmailTaken();
  @override
  String localize(IContext context) => 'Email já está cadastrado';
}

class AsyncValidationExample extends StatefulWidget {
  const AsyncValidationExample({super.key});

  @override
  State<AsyncValidationExample> createState() => _AsyncValidationExampleState();
}

class _AsyncValidationExampleState extends State<AsyncValidationExample> {
  late final _usernameCtrl = TextEditingController();
  late final _emailCtrl = TextEditingController();
  late final _passwordCtrl = TextEditingController();

  IUncategorizedFormFieldValidator<String, String> _isUsernameAvailable() => (value) {
    if (value.isEmpty) {
      return Validation(transformed: value, validation: null);
    }
    return Future.delayed(const Duration(milliseconds: 800), () {
      final blocked = {'admin', 'root', 'system', 'test'};
      if (blocked.contains(value.toLowerCase())) {
        return Validation(transformed: value, validation: const UsernameTaken());
      }
      return Validation(transformed: value, validation: null);
    });
  };

  IUncategorizedFormFieldValidator<String, String> _isEmailAvailable() => (value) {
    if (value.isEmpty) {
      return Validation(transformed: value, validation: null);
    }
    return Future.delayed(const Duration(milliseconds: 800), () {
      if (value.toLowerCase() == 'taken@example.com') {
        return Validation(transformed: value, validation: const EmailTaken());
      }
      return Validation(transformed: value, validation: null);
    });
  };

  IUncategorizedFormFieldValidator<String, String> _isEmailFormat() => StringValidators.instance.isEmail();

  IUncategorizedFormFieldValidator<String, String> _isNotEmpty() => StringValidators.instance.notEmpty();

  late final usernameField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: FormFieldValidators.instance.serial([_isNotEmpty(), _isUsernameAvailable()]).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final emailField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: FormFieldValidators.instance.serial([_isEmailFormat(), _isEmailAvailable()]).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final passwordField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isStrongPassword().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final Formularium<({String email, String password, String username})> form = Formularium.form3(
    first: usernameField,
    second: emailField,
    third: passwordField,
    valueCombiner: (String username, String email, String password) => (
      username: username,
      email: email,
      password: password,
    ),
  );

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('09 — Validação Assíncrona')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cadastre-se',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Usuário e email são verificados via chamada assíncrona simulada.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _AsyncFieldTile(
            field: usernameField,
            label: 'Nome de Usuário',
            hint: 'Escolha um nome de usuário',
            controller: _usernameCtrl,
          ),
          const SizedBox(height: 16),
          _AsyncFieldTile(
            field: emailField,
            label: 'Email',
            hint: 'seu@email.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _AsyncFieldTile(
            field: passwordField,
            label: 'Senha',
            hint: 'Mínimo 8 caracteres',
            controller: _passwordCtrl,
            obscureText: true,
            errorBuilder: (status) => PasswordStrengthIndicator(status: status),
          ),
          const SizedBox(height: 24),
          FormEntityBuilder<({String username, String email, String password})>(
            entity: form,
            builder: (context, entity, enabled, state, status, child) {
              final isValid = status is Valid<({String username, String email, String password})>;
              final isValidating = status is Validating;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isValid && !isValidating ? _onSubmit : null,
                  icon: isValidating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.person_add),
                  label: Text(isValidating ? 'Validando...' : 'Criar Conta'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );

  void _onSubmit() {
    final username = switch (usernameField.status) {
      Valid(:final transformed) => transformed,
      _ => '',
    };
    final email = switch (emailField.status) {
      Valid(:final transformed) => transformed,
      _ => '',
    };

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conta Criada'),
        content: Text('Usuário: $username\nEmail: $email'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _AsyncFieldTile extends StatelessWidget {
  const _AsyncFieldTile({
    required this.field,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.errorBuilder,
  });

  final FormulariumFormField<String, String> field;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget Function(FormFieldStatus<String> status)? errorBuilder;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FormFieldTile<String, String>(
        field: field,
        label: label,
        hint: hint,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        errorBuilder: errorBuilder,
      ),
      ValueListenableBuilder<FormFieldStatus<String>>(
        valueListenable: field.$status,
        builder: (context, status, _) {
          if (status is! Validating) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
                const SizedBox(width: 6),
                Text(
                  'Verificando...',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}
