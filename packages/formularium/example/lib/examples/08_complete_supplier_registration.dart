import 'package:flutter/material.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_extensions/form_field_validators_extension.dart';
import 'package:formularium/features/forms/_implementations/formularium.dart';
import 'package:formularium/features/forms/_implementations/formularium_form_field.dart';
import 'package:formularium/features/forms/_implementations/variant_formularium.dart';
import 'package:formularium/features/forms/_widgets/form_entity_builder.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

import 'package:formularium_example/widgets.dart';

const _pagamentoTipos = ['À vista', '30 dias', '60 dias', '90 dias', 'Outro'];
const _ufLista = [
  'AC',
  'AL',
  'AP',
  'AM',
  'BA',
  'CE',
  'DF',
  'ES',
  'GO',
  'MA',
  'MT',
  'MS',
  'MG',
  'PA',
  'PB',
  'PR',
  'PE',
  'PI',
  'RJ',
  'RN',
  'RS',
  'RO',
  'RR',
  'SC',
  'SP',
  'SE',
  'TO',
  'Outro',
];

class CompleteSupplierRegistrationExample extends StatefulWidget {
  const CompleteSupplierRegistrationExample({super.key});

  @override
  State<CompleteSupplierRegistrationExample> createState() => _CompleteSupplierRegistrationExampleState();
}

class _CompleteSupplierRegistrationExampleState extends State<CompleteSupplierRegistrationExample> {
  final ValueNotifier<bool> _isPf = ValueNotifier(true);
  final ValueNotifier<bool> _hasAddress = ValueNotifier(false);
  final _pagamentoVariant = ValueNotifier<Type>(StandardPagamento);
  final _ufVariant = ValueNotifier<Type>(StandardUf);

  // --- Controllers ---
  late final _prodNameCtrl = TextEditingController();
  late final _prodPriceCtrl = TextEditingController();
  late final _prodQtyCtrl = TextEditingController();
  late final _pfNameCtrl = TextEditingController();
  late final _pfCpfCtrl = TextEditingController();
  late final _pfBirthCtrl = TextEditingController();
  late final _pjNameCtrl = TextEditingController();
  late final _pjCnpjCtrl = TextEditingController();
  late final _pjFantasyCtrl = TextEditingController();
  late final _emailCtrl = TextEditingController();
  late final _phoneCtrl = TextEditingController();
  late final _passwordCtrl = TextEditingController();
  late final _cepCtrl = TextEditingController();
  late final _streetCtrl = TextEditingController();
  late final _numberCtrl = TextEditingController();
  late final _neighborhoodCtrl = TextEditingController();
  late final _cityCtrl = TextEditingController();
  late final _otherUfCtrl = TextEditingController();
  late final _otherPagamentoCtrl = TextEditingController();

  // --- Product Fields (ex01 + ex04) ---
  late final prodName = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final prodPrice = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isNumeric().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final prodQty = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isNumeric().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final Formularium<({String name, String price, String quantity, String total})> _prodForm = Formularium.form3(
    first: prodName,
    second: prodPrice,
    third: prodQty,
    valueCombiner: (String name, String price, String qty) => (
      name: name,
      price: price,
      quantity: qty,
      total: '${(double.tryParse(price) ?? 0) * (int.tryParse(qty) ?? 0)}',
    ),
  );

  // --- PF Fields (ex07) ---
  late final pfName = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final pfCpf = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.matches(RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$')).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final pfBirth = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.matches(RegExp(r'^\d{2}/\d{2}/\d{4}$')).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  // --- PJ Fields (ex07) ---
  late final pjName = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final pjCnpj = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.matches(RegExp(r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$')).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final pjFantasy = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  // --- Shared Contact Fields (ex01, ex02, ex03) ---
  late final emailField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isEmail().error(),
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
  late final passwordField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isStrongPassword().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  // --- Supplier Variant Form (PF/PJ - ex07) ---
  late final Formularium<({String document, String email, String extra, String name, String password, String phone})>
  _pfForm = Formularium.form6(
    first: pfName,
    second: pfCpf,
    third: pfBirth,
    fourth: emailField,
    fifth: phoneField,
    sixth: passwordField,
    valueCombiner: (name, cpf, birth, email, phone, password) => (
      name: name,
      document: cpf,
      extra: birth.substring(0, 10),
      email: email,
      phone: phone,
      password: password,
    ),
  );

  late final Formularium<({String document, String email, String extra, String name, String password, String phone})>
  _pjForm = Formularium.form6(
    first: pjName,
    second: pjCnpj,
    third: pjFantasy,
    fourth: emailField,
    fifth: phoneField,
    sixth: passwordField,
    valueCombiner: (name, cnpj, fantasy, email, phone, password) => (
      name: name,
      document: cnpj,
      extra: fantasy,
      phone: phone,
      email: email,
      password: password,
    ),
  );

  late final _supplierForm =
      VariantFormularium<
        bool,
        ({
          String name,
          String document,
          String phone,
          String email,
          String password,
          String extra,
        })
      >(
        selector: _isPf,
        variants: {
          true: _pfForm,
          false: _pjForm,
        },
      );

  // --- Address Fields (ex03 + ex05) ---
  late final cepField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isPostalCode('BR').error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final streetField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final numberField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final neighborhoodField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final cityField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final ufField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isIn(_ufLista).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final otherUfField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final Formularium<({String cep, String city, String neighborhood, String number, String street, String uf})>
  _addressForm = Formularium.form6(
    first: cepField,
    second: streetField,
    third: numberField,
    fourth: neighborhoodField,
    fifth: cityField,
    sixth: ufField,
    valueCombiner: (cep, street, number, neighborhood, city, uf) => (
      cep: cep,
      street: street,
      number: number,
      neighborhood: neighborhood,
      city: city,
      uf: uf,
    ),
    enabled: false,
  );

  // --- Payment Terms (ex06) ---
  late final pagamentoField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.isIn(_pagamentoTipos).error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );
  late final otherPagamentoField = FormulariumFormField<String, String>(
    initialValue: '',
    validator: StringValidators.instance.notEmpty().error(),
    enabled: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    focusNode: null,
  );

  late final Formularium<({String descricao, String tipo})> _stdPagamentoForm = Formularium.form1(
    first: pagamentoField,
    valueCombiner: (tipo) => (tipo: tipo, descricao: ''),
  );
  late final Formularium<({String descricao, String tipo})> _otherPagamentoForm = Formularium.form2(
    first: pagamentoField,
    second: otherPagamentoField,
    valueCombiner: (tipo, desc) => (tipo: tipo, descricao: desc),
  );

  late final _pagamentoForm =
      VariantFormularium<
        Type,
        ({
          String tipo,
          String descricao,
        })
      >(
        selector: _pagamentoVariant,
        variants: {
          StandardPagamento: _stdPagamentoForm,
          OtherPagamento: _otherPagamentoForm,
        },
      );

  @override
  void initState() {
    super.initState();
    _hasAddress.addListener(_onAddressChanged);
    pagamentoField.$status.addListener(_onPagamentoChanged);
    ufField.$status.addListener(_onUfChanged);
  }

  void _onAddressChanged() {
    _addressForm.enabled = _hasAddress.value;
  }

  void _onPagamentoChanged() {
    final isOther = switch (pagamentoField.status) {
      Valid(:final transformed) => transformed == 'Outro',
      Invalid(:final transformed) => transformed == 'Outro',
      _ => false,
    };
    _pagamentoVariant.value = isOther ? OtherPagamento : StandardPagamento;
    if (!isOther) {
      _otherPagamentoCtrl.clear();
      otherPagamentoField.reset();
    }
  }

  void _onUfChanged() {
    final isOther = switch (ufField.status) {
      Valid(:final transformed) => transformed == 'Outro',
      Invalid(:final transformed) => transformed == 'Outro',
      _ => false,
    };
    _ufVariant.value = isOther ? OtherUf : StandardUf;
    if (!isOther) {
      _otherUfCtrl.clear();
      otherUfField.reset();
    }
  }

  @override
  void dispose() {
    _hasAddress.removeListener(_onAddressChanged);
    pagamentoField.$status.removeListener(_onPagamentoChanged);
    ufField.$status.removeListener(_onUfChanged);
    _prodNameCtrl.dispose();
    _prodPriceCtrl.dispose();
    _prodQtyCtrl.dispose();
    _pfNameCtrl.dispose();
    _pfCpfCtrl.dispose();
    _pfBirthCtrl.dispose();
    _pjNameCtrl.dispose();
    _pjCnpjCtrl.dispose();
    _pjFantasyCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _cepCtrl.dispose();
    _streetCtrl.dispose();
    _numberCtrl.dispose();
    _neighborhoodCtrl.dispose();
    _cityCtrl.dispose();
    _otherUfCtrl.dispose();
    _otherPagamentoCtrl.dispose();
    _isPf.dispose();
    _hasAddress.dispose();
    _pagamentoVariant.dispose();
    _ufVariant.dispose();
    _supplierForm.dispose();
    _addressForm.dispose();
    _pagamentoForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('08 — Cadastro Completo')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Produto', Icons.inventory_2),
          _buildProductSection(),
          const Divider(height: 32),
          _buildSectionHeader('Fornecedor', Icons.business),
          _buildPfPjToggle(),
          const SizedBox(height: 16),
          _buildSupplierFields(),
          const SizedBox(height: 16),
          _buildContactFields(),
          const Divider(height: 32),
          _buildSectionHeader('Endereço de Entrega', Icons.local_shipping),
          _buildAddressToggle(),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _hasAddress,
            builder: (context, hasAddress, _) {
              if (!hasAddress) return const SizedBox.shrink();
              return _buildAddressFields();
            },
          ),
          const Divider(height: 32),
          _buildSectionHeader('Condição de Pagamento', Icons.payment),
          _buildPaymentSection(),
          const Divider(height: 32),
          _buildSubmitSection(),
        ],
      ),
    ),
  );

  Widget _buildSectionHeader(String title, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  // ─── Product Section (ex01 + ex04) ───────────────────────────────

  Widget _buildProductSection() => Column(
    children: [
      FormFieldTile<String, String>(
        field: prodName,
        label: 'Nome do Produto',
        hint: 'Ex: Notebook Dell',
        controller: _prodNameCtrl,
      ),
      const SizedBox(height: 12),
      FormFieldTile<String, String>(
        field: prodPrice,
        label: r'Preço Unitário (R$)',
        hint: 'Ex: 2499.90',
        controller: _prodPriceCtrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
      const SizedBox(height: 12),
      FormFieldTile<String, String>(
        field: prodQty,
        label: 'Quantidade',
        hint: 'Ex: 5',
        controller: _prodQtyCtrl,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 12),
      FormEntityBuilder(
        entity: _prodForm,
        builder: (context, entity, enabled, state, status, child) {
          final data = switch (status) {
            Valid(:final transformed) => transformed,
            _ => null,
          };
          if (data == null) return const SizedBox.shrink();
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${data.name}: ${data.quantity}x R\$${data.price} = R\$${data.total}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Text(
                    'Total: R\$${data.total}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );

  // ─── Supplier Section (ex07 + VariantFormularium) ──────────────

  Widget _buildPfPjToggle() => ValueListenableBuilder<bool>(
    valueListenable: _isPf,
    builder: (context, isPf, _) => Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: 'Pessoa Física',
                icon: Icons.person,
                selected: isPf,
                onPressed: () {
                  if (!isPf) _isPf.value = true;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ToggleButton(
                label: 'Pessoa Jurídica',
                icon: Icons.business,
                selected: !isPf,
                onPressed: () {
                  if (isPf) _isPf.value = false;
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildSupplierFields() => ValueListenableBuilder<bool>(
    valueListenable: _isPf,
    builder: (context, isPf, _) {
      if (isPf) {
        return Column(
          children: [
            FormFieldTile<String, String>(
              key: ValueKey(pfName),
              field: pfName,
              label: 'Nome Completo',
              hint: 'Digite o nome do fornecedor',
              controller: _pfNameCtrl,
            ),
            const SizedBox(height: 12),
            FormFieldTile<String, String>(
              key: ValueKey(pfCpf),
              field: pfCpf,
              label: 'CPF',
              hint: '000.000.000-00',
              controller: _pfCpfCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            FormFieldTile<String, String>(
              key: ValueKey(pfBirth),
              field: pfBirth,
              label: 'Data de Nascimento',
              hint: 'dd/mm/aaaa',
              controller: _pfBirthCtrl,
            ),
          ],
        );
      }
      return Column(
        children: [
          FormFieldTile<String, String>(
            key: ValueKey(pjName),
            field: pjName,
            label: 'Razão Social',
            hint: 'Digite a razão social',
            controller: _pjNameCtrl,
          ),
          const SizedBox(height: 12),
          FormFieldTile<String, String>(
            key: ValueKey(pjCnpj),
            field: pjCnpj,
            label: 'CNPJ',
            hint: '00.000.000/0000-00',
            controller: _pjCnpjCtrl,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          FormFieldTile<String, String>(
            key: ValueKey(pjFantasy),
            field: pjFantasy,
            label: 'Nome Fantasia',
            hint: 'Digite o nome fantasia',
            controller: _pjFantasyCtrl,
          ),
        ],
      );
    },
  );

  // ─── Contact (ex01, ex02, ex03) ─────────────────────────────────

  Widget _buildContactFields() => Column(
    children: [
      FormFieldTile<String, String>(
        field: emailField,
        label: 'Email',
        hint: 'fornecedor@exemplo.com',
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 12),
      FormFieldTile<String, String>(
        field: phoneField,
        label: 'Telefone',
        hint: '(11) 91234-5678',
        controller: _phoneCtrl,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 12),
      FormFieldTile<String, String>(
        field: passwordField,
        label: 'Senha de Acesso',
        hint: 'Mínimo 8 caracteres',
        controller: _passwordCtrl,
        obscureText: true,
        errorBuilder: (status) => PasswordStrengthIndicator(status: status),
      ),
    ],
  );

  // ─── Address Section (ex03 + ex05) ─────────────────────────────

  Widget _buildAddressToggle() => ValueListenableBuilder<bool>(
    valueListenable: _hasAddress,
    builder: (context, hasAddress, _) => CheckboxListTile(
      title: const Text('Endereço de entrega diferente?'),
      subtitle: const Text('Informe o endereço para entrega do pedido'),
      value: hasAddress,
      onChanged: (v) => _hasAddress.value = v ?? false,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    ),
  );

  Widget _buildAddressFields() => Column(
    children: [
      FormFieldTile<String, String>(
        field: cepField,
        label: 'CEP',
        hint: '12345-678',
        controller: _cepCtrl,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 12),
      FormFieldTile<String, String>(
        field: streetField,
        label: 'Logradouro',
        hint: 'Rua, Avenida...',
        controller: _streetCtrl,
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: FormFieldTile<String, String>(
              field: numberField,
              label: 'Número',
              hint: 'Ex: 100',
              controller: _numberCtrl,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: FormFieldTile<String, String>(
              field: neighborhoodField,
              label: 'Bairro',
              hint: 'Centro',
              controller: _neighborhoodCtrl,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            flex: 3,
            child: FormFieldTile<String, String>(
              field: cityField,
              label: 'Cidade',
              hint: 'São Paulo',
              controller: _cityCtrl,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: _buildUfDropdown(),
          ),
        ],
      ),
    ],
  );

  Widget _buildUfDropdown() => _FormDropdown(
    label: 'UF',
    field: ufField,
    hint: 'UF',
    items: _ufLista,
    onChanged: (value) {
      if (value == 'Outro') {
        _ufVariant.value = OtherUf;
      } else {
        _ufVariant.value = StandardUf;
        _otherUfCtrl.clear();
        otherUfField.reset();
      }
    },
  );

  // ─── Payment Section (ex06) ────────────────────────────────────

  Widget _buildPaymentSection() => Column(
    children: [
      _FormDropdown(
        label: 'Condição de Pagamento',
        field: pagamentoField,
        hint: 'Selecione',
        items: _pagamentoTipos,
      ),
      const SizedBox(height: 12),
      ValueListenableBuilder<Type>(
        valueListenable: _pagamentoVariant,
        builder: (context, variant, _) {
          if (variant != OtherPagamento) return const SizedBox.shrink();
          return FormFieldTile<String, String>(
            field: otherPagamentoField,
            label: 'Descreva a condição',
            hint: 'Ex: 45 dias com entrada',
            controller: _otherPagamentoCtrl,
          );
        },
      ),
    ],
  );

  // ─── Submit Section ────────────────────────────────────────────

  Widget _buildSubmitSection() => Column(
    children: [
      FormEntityBuilder(
        entity: _supplierForm,
        builder: (context, entity, enabled, state, status, child) {
          final allValid = status is Valid;

          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: allValid ? _onSubmit : null,
              icon: const Icon(Icons.check_circle),
              label: const Text('Finalizar Cadastro'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 8),
      ValueListenableBuilder<bool>(
        valueListenable: _isPf,
        builder: (context, isPf, _) => Text(
          isPf ? 'Fornecedor será cadastrado como PF' : 'Fornecedor será cadastrado como PJ',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );

  void _onSubmit() {
    final isPf = _isPf.value;

    final pfValid = switch (pfName.status) {
      Valid(:final transformed) => transformed,
      _ => '',
    };
    final docValid = switch (isPf ? pfCpf.status : pjCnpj.status) {
      Valid(:final transformed) => transformed,
      _ => '',
    };

    final email = switch (emailField.status) {
      Valid(:final transformed) => transformed,
      _ => '',
    };
    final phone = switch (phoneField.status) {
      Valid(:final transformed) => transformed,
      _ => '',
    };

    final hasAddr = _hasAddress.value;
    final cep = switch (cepField.status) {
      Valid(:final transformed) => transformed,
      _ => '',
    };
    final street = switch (streetField.status) {
      Valid(:final transformed) => transformed,
      _ => '',
    };
    final city = switch (cityField.status) {
      Valid(:final transformed) => transformed,
      _ => '',
    };

    final tipoPf = isPf ? 'PF' : 'PJ';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cadastro Realizado'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tipo: $tipoPf'),
              Text('Nome: $pfValid'),
              Text('Documento: $docValid'),
              Text('Email: $email'),
              Text('Telefone: $phone'),
              if (hasAddr) ...[
                const Divider(),
                const Text('Endereço:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('CEP: $cep'),
                Text('Logradouro: $street'),
                Text('Cidade: $city'),
              ],
            ],
          ),
        ),
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

// ─── Helper Widgets ──────────────────────────────────────────────

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    style: selected
        ? null
        : FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
    onPressed: onPressed,
    icon: Icon(icon, size: 18),
    label: Text(label, style: const TextStyle(fontSize: 13)),
  );
}

class _FormDropdown extends StatelessWidget {
  const _FormDropdown({
    required this.label,
    required this.field,
    required this.hint,
    required this.items,
    this.onChanged,
  });

  final String label;
  final FormulariumFormField<String, String> field;
  final String hint;
  final List<String> items;
  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<FormFieldStatus<String>>(
    valueListenable: field.$status,
    builder: (context, status, _) {
      final currentValue = switch (status) {
        Valid(:final transformed) => transformed,
        Invalid(:final transformed) => transformed,
        _ => '',
      };

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: currentValue.isEmpty ? null : currentValue,
            isExpanded: true,
            hint: Text(hint),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (value) {
              field.value = value ?? '';
              onChanged?.call(value ?? '');
            },
          ),
        ],
      );
    },
  );
}

class StandardPagamento {
  const StandardPagamento();
}

class OtherPagamento {
  const OtherPagamento();
}

class StandardUf {
  const StandardUf();
}

class OtherUf {
  const OtherUf();
}
