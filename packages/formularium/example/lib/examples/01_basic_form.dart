import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

import 'package:formularium_example/widgets.dart';

class BasicFormExample extends StatefulWidget {
  const BasicFormExample({super.key});

  @override
  State<BasicFormExample> createState() => _BasicFormExampleState();
}

class _BasicFormExampleState extends State<BasicFormExample> {
  late final _nameController = TextEditingController();
  late final _emailController = TextEditingController();

  late final nameField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final emailField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isEmail().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final Formularium<({String email, String name})> form = Formularium.form2(
    first: nameField,
    second: emailField,
    valueCombiner: (String name, String email) => (name: name, email: email),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('01 — Formulário Básico')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FormFieldTile<String, String>(
            field: nameField,
            label: 'Nome',
            hint: 'Digite seu nome',
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          FormFieldTile<String, String>(
            field: emailField,
            label: 'Email',
            hint: 'nome@exemplo.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          FormEntityBuilder<({String name, String email})>(
            entity: form,
            builder: (context, entity, enabled, state, status, child) {
              final isValid = status is Valid<({String name, String email})>;
              final data = status is Valid<({String name, String email})> ? status.transformed : null;

              return Column(
                children: [
                  ElevatedButton(
                    onPressed: isValid
                        ? () {
                            final message = 'Nome: ${data!.name}\nEmail: ${data.email}';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        : null,
                    child: const Text('Enviar'),
                  ),
                  if (!isValid && state == FormFieldState.dirty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Preencha todos os campos corretamente.',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}
