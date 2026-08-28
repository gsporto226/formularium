import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

import 'package:formularium_example/widgets.dart';

class LoginFormExample extends StatefulWidget {
  const LoginFormExample({super.key});

  @override
  State<LoginFormExample> createState() => _LoginFormExampleState();
}

class _LoginFormExampleState extends State<LoginFormExample> {
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();

  late final emailField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isEmail().error(),
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

  late final Formularium<({String email, String password})> form = Formularium.form2(
    first: emailField,
    second: passwordField,
    valueCombiner: (String email, String password) => (
      email: email,
      password: password,
    ),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('02 — Formulário de Login')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldTile<String, String>(
            field: emailField,
            label: 'Email',
            hint: 'usuario@exemplo.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          FormFieldTile<String, String>(
            field: passwordField,
            label: 'Senha',
            hint: 'Digite sua senha',
            controller: _passwordController,
            obscureText: true,
            errorBuilder: (status) => PasswordStrengthIndicator(
              status: status,
            ),
          ),
          const SizedBox(height: 24),
          FormEntityBuilder<({String email, String password})>(
            entity: form,
            builder: (context, entity, enabled, state, status, child) {
              final isValid = status is Valid<({String email, String password})>;

              return ElevatedButton.icon(
                onPressed: isValid
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login realizado com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.login),
                label: const Text('Entrar'),
              );
            },
          ),
        ],
      ),
    ),
  );
}
