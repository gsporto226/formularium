import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

import 'package:formularium_example/widgets.dart';

class ProfileFormExample extends StatefulWidget {
  const ProfileFormExample({super.key});

  @override
  State<ProfileFormExample> createState() => _ProfileFormExampleState();
}

class _ProfileFormExampleState extends State<ProfileFormExample> {
  late final _birthDateController = TextEditingController();
  late final _phoneController = TextEditingController();
  late final _postalCodeController = TextEditingController();

  late final birthDateField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.matches(RegExp(r'^\d{2}/\d{2}/\d{4}$')).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final phoneField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isMobilePhone(locale: 'pt-BR').error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final postalCodeField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isPostalCode('BR').error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final Formularium<({String birthDate, String phone, String postalCode})> form = Formularium.form3(
    first: birthDateField,
    second: phoneField,
    third: postalCodeField,
    valueCombiner: (String date, String phone, String postalCode) => (
      birthDate: date,
      phone: phone,
      postalCode: postalCode,
    ),
  );

  @override
  void dispose() {
    _birthDateController.dispose();
    _phoneController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('03 — Formulário de Perfil')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FormFieldTile<String, String>(
            field: birthDateField,
            label: 'Data de Nascimento',
            hint: 'dd/mm/aaaa',
            controller: _birthDateController,
          ),
          const SizedBox(height: 16),
          FormFieldTile<String, String>(
            field: phoneField,
            label: 'Telefone',
            hint: '(11) 91234-5678',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          FormFieldTile<String, String>(
            field: postalCodeField,
            label: 'CEP',
            hint: '12345-678',
            controller: _postalCodeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          FormEntityBuilder<
            ({
              String birthDate,
              String phone,
              String postalCode,
            })
          >(
            entity: form,
            builder: (context, entity, enabled, state, status, child) {
              final data = switch (status) {
                Valid(
                  :final transformed,
                ) =>
                  transformed,
                _ => null,
              };

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: data != null
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nascimento: ${data.birthDate}',
                                    ),
                                    Text('Telefone: ${data.phone}'),
                                    Text('CEP: ${data.postalCode}'),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        : null,
                    child: const Text('Salvar Perfil'),
                  ),
                  if (data != null) ...[
                    const SizedBox(height: 16),
                    _ResultCard(data: data),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.data});

  final ({
    String birthDate,
    String phone,
    String postalCode,
  })
  data;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dados validados:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('📅 Nascimento: ${data.birthDate}'),
          Text('📱 Telefone: ${data.phone}'),
          Text('📍 CEP: ${data.postalCode}'),
        ],
      ),
    ),
  );
}
