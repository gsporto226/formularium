import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

import 'package:formularium_example/widgets.dart';

class ProductFormExample extends StatefulWidget {
  const ProductFormExample({super.key});

  @override
  State<ProductFormExample> createState() => _ProductFormExampleState();
}

class _ProductFormExampleState extends State<ProductFormExample> {
  late final _nameController = TextEditingController();
  late final _priceController = TextEditingController();
  late final _quantityController = TextEditingController();

  late final nameField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final priceField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isNumeric().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final quantityField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isNumeric().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final Formularium<({String name, String price, String quantity, String total})> form = Formularium.form3(
    first: nameField,
    second: priceField,
    third: quantityField,
    valueCombiner: (String name, String price, String quantity) => (
      name: name,
      price: price,
      quantity: quantity,
      total: '${(double.tryParse(price) ?? 0) * (int.tryParse(quantity) ?? 0)}',
    ),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('04 — Cadastro de Produto')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FormFieldTile<String, String>(
            field: nameField,
            label: 'Nome do Produto',
            hint: 'Ex: Notebook',
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          FormFieldTile<String, String>(
            field: priceField,
            label: r'Preço (R$)',
            hint: 'Ex: 1999.90',
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          const SizedBox(height: 16),
          FormFieldTile<String, String>(
            field: quantityField,
            label: 'Quantidade',
            hint: 'Ex: 10',
            controller: _quantityController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          FormEntityBuilder<
            ({
              String name,
              String price,
              String quantity,
              String total,
            })
          >(
            entity: form,
            builder: (context, entity, enabled, state, status, child) {
              final data = switch (status) {
                Valid(:final transformed) => transformed,
                _ => null,
              };

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: data != null
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${data.name}: ${data.quantity}x R\$ ${data.price} = R\$ ${data.total}',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Cadastrar Produto'),
                  ),
                  if (data != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Resumo:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('📦 Produto: ${data.name}'),
                            Text(
                              '💰 Preço: R\$ ${data.price}',
                            ),
                            Text('🔢 Quantidade: ${data.quantity}'),
                            const Divider(),
                            Text(
                              '🛒 Total: R\$ ${data.total}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
