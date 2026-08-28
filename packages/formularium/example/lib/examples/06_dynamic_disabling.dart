import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/variant_formularium.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

import 'package:formularium_example/widgets.dart';

const _docTypes = ['RG', 'CPF', 'CNH', 'Passaporte', 'Outro'];

sealed class DocForm {
  const DocForm();
}

class StandardDoc extends DocForm {
  const StandardDoc({required this.docType});
  final String docType;
}

class OtherDoc extends DocForm {
  const OtherDoc({required this.docType, required this.description});
  final String docType;
  final String description;
}

class DynamicDisablingExample extends StatefulWidget {
  const DynamicDisablingExample({super.key});

  @override
  State<DynamicDisablingExample> createState() => _DynamicDisablingExampleState();
}

class _DynamicDisablingExampleState extends State<DynamicDisablingExample> {
  late final _otherDocController = TextEditingController();

  late final docTypeField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isIn(_docTypes).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final otherDocField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  final _variantSelector = ValueNotifier<Type>(StandardDoc);

  @override
  void initState() {
    super.initState();
    docTypeField.$status.addListener(_onDocTypeChanged);
  }

  void _onDocTypeChanged() {
    final isOther = switch (docTypeField.status) {
      Valid(:final transformed) => transformed == 'Outro',
      Invalid(:final transformed) => transformed == 'Outro',
      _ => false,
    };
    _variantSelector.value = isOther ? OtherDoc : StandardDoc;
    if (!isOther) {
      _otherDocController.clear();
      otherDocField.reset();
    }
  }

  late final Formularium<StandardDoc> _standardForm = Formularium.form1(
    first: docTypeField,
    valueCombiner: (docType) => StandardDoc(docType: docType),
  );

  late final Formularium<OtherDoc> _otherForm = Formularium.form2(
    first: docTypeField,
    second: otherDocField,
    valueCombiner: (docType, desc) => OtherDoc(docType: docType, description: desc),
  );

  late final form = VariantFormularium<Type, DocForm>(
    selector: _variantSelector,
    variants: {
      StandardDoc: _standardForm,
      OtherDoc: _otherForm,
    },
  );

  @override
  void dispose() {
    docTypeField.$status.removeListener(_onDocTypeChanged);
    _otherDocController.dispose();
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('06 — Desabilitação Dinâmica')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _DocTypeDropdown(field: docTypeField),
          const SizedBox(height: 16),
          ValueListenableBuilder<Type>(
            valueListenable: _variantSelector,
            builder: (context, variant, child) {
              if (variant != OtherDoc) {
                return const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Selecione "Outro" para digitar um tipo de documento personalizado.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                );
              }
              return FormFieldTile<String, String>(
                field: otherDocField,
                label: 'Descreva o documento',
                hint: 'Ex: Carteira de Estudante',
                controller: _otherDocController,
              );
            },
          ),
          const SizedBox(height: 24),
          FormEntityBuilder<DocForm>(
            entity: form,
            builder: (context, entity, enabled, state, status, child) {
              final data = switch (status) {
                Valid(:final transformed) => transformed,
                _ => null,
              };

              return ElevatedButton.icon(
                onPressed: data != null
                    ? () {
                        final doc = switch (data) {
                          StandardDoc(:final docType) => docType,
                          OtherDoc(:final description) => description,
                        };
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Documento selecionado: $doc'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.check),
                label: const Text('Confirmar'),
              );
            },
          ),
        ],
      ),
    ),
  );
}

class _DocTypeDropdown extends StatelessWidget {
  const _DocTypeDropdown({required this.field});

  final FormulariumFormField<String, String> field;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<FormFieldStatus<String>>(
    valueListenable: field.$status,
    builder: (context, status, child) {
      final currentValue = switch (status) {
        Valid(:final transformed) => transformed,
        Invalid(:final transformed) => transformed,
        _ => '',
      };

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tipo de Documento',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: !field.enabled ? Colors.grey : null,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: currentValue.isEmpty ? null : currentValue,
            isExpanded: true,
            hint: const Text('Selecione o tipo'),
            items: _docTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
            onChanged: (value) => field.value = value ?? '',
          ),
        ],
      );
    },
  );
}
