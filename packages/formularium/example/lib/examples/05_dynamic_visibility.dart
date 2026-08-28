import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/variant_formularium.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

import 'package:formularium_example/widgets.dart';

sealed class PersonForm {
  const PersonForm();
}

class SinglePerson extends PersonForm {
  const SinglePerson({required this.name});
  final String name;
}

class MarriedPerson extends PersonForm {
  const MarriedPerson({required this.name, required this.spouse});
  final String name;
  final String spouse;
}

class DynamicVisibilityExample extends StatefulWidget {
  const DynamicVisibilityExample({super.key});

  @override
  State<DynamicVisibilityExample> createState() => _DynamicVisibilityExampleState();
}

class _DynamicVisibilityExampleState extends State<DynamicVisibilityExample> {
  late final _nameController = TextEditingController();
  late final _spouseNameController = TextEditingController();

  late final nameField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final spouseNameField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  final ValueNotifier<bool> _hasSpouse = ValueNotifier(false);

  late final Formularium<SinglePerson> _singleForm = Formularium.form1(
    first: nameField,
    valueCombiner: (name) => SinglePerson(name: name),
  );

  late final Formularium<MarriedPerson> _marriedForm = Formularium.form2(
    first: nameField,
    second: spouseNameField,
    valueCombiner: (name, spouse) => MarriedPerson(name: name, spouse: spouse),
  );

  late final form = VariantFormularium<bool, PersonForm>(
    selector: _hasSpouse,
    variants: {false: _singleForm, true: _marriedForm},
  );

  @override
  void dispose() {
    _nameController.dispose();
    _spouseNameController.dispose();
    _hasSpouse.dispose();
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('05 — Visibilidade Dinâmica')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FormFieldTile<String, String>(
            field: nameField,
            label: 'Seu Nome',
            hint: 'Digite seu nome completo',
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _hasSpouse,
            builder: (context, hasSpouse, child) => CheckboxListTile(
              title: const Text('Possui cônjuge?'),
              value: hasSpouse,
              onChanged: (v) => _hasSpouse.value = v ?? false,
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _hasSpouse,
            builder: (context, hasSpouse, child) {
              if (!hasSpouse) {
                return const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Marque "Possui cônjuge?" para adicionar o nome do cônjuge.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                );
              }
              return FormFieldTile<String, String>(
                field: spouseNameField,
                label: 'Nome do Cônjuge',
                hint: 'Digite o nome do cônjuge',
                controller: _spouseNameController,
              );
            },
          ),
          const SizedBox(height: 24),
          FormEntityBuilder<PersonForm>(
            entity: form,
            builder: (context, entity, enabled, state, status, child) {
              final data = switch (status) {
                Valid(:final transformed) => transformed,
                _ => null,
              };

              return ElevatedButton(
                onPressed: data != null
                    ? () {
                        final message = switch (data) {
                          SinglePerson(:final name) => 'Nome: $name (solteiro)',
                          MarriedPerson(:final name, :final spouse) => 'Nome: $name\nCônjuge: $spouse',
                        };
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : null,
                child: const Text('Salvar'),
              );
            },
          ),
        ],
      ),
    ),
  );
}
