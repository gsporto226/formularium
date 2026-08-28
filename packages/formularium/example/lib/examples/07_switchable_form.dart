import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/variant_formularium.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

import 'package:formularium_example/widgets.dart';

class SwitchableFormExample extends StatefulWidget {
  const SwitchableFormExample({super.key});

  @override
  State<SwitchableFormExample> createState() => _SwitchableFormExampleState();
}

class _SwitchableFormExampleState extends State<SwitchableFormExample> {
  final _isIndividual = ValueNotifier<bool>(true);

  late final _individualNameController = TextEditingController();
  late final _individualCpfController = TextEditingController();
  late final _individualBirthController = TextEditingController();
  late final _companyNameController = TextEditingController();
  late final _companyCnpjController = TextEditingController();
  late final _companyFantasyController = TextEditingController();

  late final _individualName = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final _individualCpf = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.matches(RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$')).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final _individualBirth = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.matches(RegExp(r'^\d{2}/\d{2}/\d{4}$')).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final _companyName = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final _companyCnpj = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.matches(RegExp(r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$')).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final _companyFantasy = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final Formularium<({String document, String extra, String name})> _individualForm = Formularium.form3(
    first: _individualName,
    second: _individualCpf,
    third: _individualBirth,
    valueCombiner: (String name, String cpf, String birth) => (name: name, document: cpf, extra: birth),
  );

  late final Formularium<({String document, String extra, String name})> _companyForm = Formularium.form3(
    first: _companyName,
    second: _companyCnpj,
    third: _companyFantasy,
    valueCombiner: (String name, String cnpj, String fantasy) => (name: name, document: cnpj, extra: fantasy),
  );

  late final _switchable = VariantFormularium<bool, ({String name, String document, String extra})>(
    variants: {true: _individualForm, false: _companyForm},
    selector: _isIndividual,
  );

  @override
  void dispose() {
    _individualNameController.dispose();
    _individualCpfController.dispose();
    _individualBirthController.dispose();
    _companyNameController.dispose();
    _companyCnpjController.dispose();
    _companyFantasyController.dispose();
    _isIndividual.dispose();
    _switchable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('07 — Formulário Alternável')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _isIndividual,
            builder: (context, isIndividual, child) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _TypeButton(
                        label: 'Pessoa Física',
                        selected: isIndividual,
                        onPressed: () => _isIndividual.value = true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TypeButton(
                        label: 'Pessoa Jurídica',
                        selected: !isIndividual,
                        onPressed: () => _isIndividual.value = false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _isIndividual,
            builder: (context, isIndividual, child) {
              if (isIndividual) {
                return Column(
                  children: [
                    FormFieldTile<String, String>(
                      key: ValueKey(_individualName),
                      field: _individualName,
                      label: 'Nome Completo',
                      hint: 'Digite seu nome',
                      controller: _individualNameController,
                    ),
                    const SizedBox(height: 16),
                    FormFieldTile<String, String>(
                      key: ValueKey(_individualCpf),
                      field: _individualCpf,
                      label: 'CPF',
                      hint: '000.000.000-00',
                      controller: _individualCpfController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    FormFieldTile<String, String>(
                      key: ValueKey(_individualBirth),
                      field: _individualBirth,
                      label: 'Data de Nascimento',
                      hint: 'dd/mm/aaaa',
                      controller: _individualBirthController,
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  FormFieldTile<String, String>(
                    key: ValueKey(_companyName),
                    field: _companyName,
                    label: 'Razão Social',
                    hint: 'Digite a razão social',
                    controller: _companyNameController,
                  ),
                  const SizedBox(height: 16),
                  FormFieldTile<String, String>(
                    key: ValueKey(_companyCnpj),
                    field: _companyCnpj,
                    label: 'CNPJ',
                    hint: '00.000.000/0000-00',
                    controller: _companyCnpjController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  FormFieldTile<String, String>(
                    key: ValueKey(_companyFantasy),
                    field: _companyFantasy,
                    label: 'Nome Fantasia',
                    hint: 'Digite o nome fantasia',
                    controller: _companyFantasyController,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          FormEntityBuilder<({String name, String document, String extra})>(
            entity: _switchable,
            builder: (context, entity, enabled, state, status, child) {
              final data = switch (status) {
                Valid(:final transformed) => transformed,
                _ => null,
              };

              return ElevatedButton.icon(
                onPressed: data != null
                    ? () {
                        final label = _isIndividual.value ? 'CPF' : 'CNPJ';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Nome: ${data.name}\n$label: ${data.document}\nExtra: ${data.extra}',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              );
            },
          ),
        ],
      ),
    ),
  );
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    style: selected
        ? null
        : FilledButton.styleFrom(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
    onPressed: onPressed,
    child: Text(label),
  );
}
