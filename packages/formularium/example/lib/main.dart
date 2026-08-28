import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:formularium/features/validators/_interfaces/formularium_localizations_delegate.dart';
import 'package:formularium/formularium.dart';
import 'package:formularium_example/examples/01_basic_form.dart';
import 'package:formularium_example/examples/02_login_form.dart';
import 'package:formularium_example/examples/03_profile_form.dart';
import 'package:formularium_example/examples/04_product_form.dart';
import 'package:formularium_example/examples/05_dynamic_visibility.dart';
import 'package:formularium_example/examples/06_dynamic_disabling.dart';
import 'package:formularium_example/examples/07_switchable_form.dart';
import 'package:formularium_example/examples/08_complete_supplier_registration.dart';
import 'package:formularium_example/examples/09_async_validation.dart';

void main() => runApp(const FormulariumExampleApp());

/// App de exemplo do pacote formularium.
///
/// Apresenta um menu com 7 exemplos demonstrando os recursos
/// principais da biblioteca.
class FormulariumExampleApp extends StatelessWidget {
  /// Cria o app de exemplos.
  const FormulariumExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Formularium — Exemplos',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorSchemeSeed: Colors.blue,
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: const ExampleMenu(),
    localizationsDelegates: const [
      FormulariumLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('pt'), Locale('en')],
  );
}

/// Menu principal com a lista de exemplos.
class ExampleMenu extends StatelessWidget {
  /// Cria o menu de exemplos.
  const ExampleMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const examples =
        <
          ({
            String title,
            String subtitle,
            Widget page,
          })
        >[
          (
            title: '01 — Formulário Básico',
            subtitle: 'Nome + Email com validação básica',
            page: BasicFormExample(),
          ),
          (
            title: '02 — Formulário de Login',
            subtitle: 'Email + Senha forte',
            page: LoginFormExample(),
          ),
          (
            title: '03 — Formulário de Perfil',
            subtitle: 'Data, Telefone e CEP',
            page: ProfileFormExample(),
          ),
          (
            title: '04 — Cadastro de Produto',
            subtitle: 'Preço e quantidade com validação numérica',
            page: ProductFormExample(),
          ),
          (
            title: '05 — Visibilidade Dinâmica',
            subtitle: 'Checkbox que mostra/esconde campo',
            page: DynamicVisibilityExample(),
          ),
          (
            title: '06 — Desabilitação Dinâmica',
            subtitle: 'Dropdown que habilita/desabilita campo',
            page: DynamicDisablingExample(),
          ),
          (
            title: '07 — Formulário Alternável',
            subtitle: 'VariantFormularium — PF/PJ',
            page: SwitchableFormExample(),
          ),
          (
            title: '08 — Cadastro Completo',
            subtitle: 'Todos os padrões combinados',
            page: CompleteSupplierRegistrationExample(),
          ),
          (
            title: '09 — Validação Assíncrona',
            subtitle: 'serial() com Future — username/email',
            page: AsyncValidationExample(),
          ),
        ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formularium — Exemplos'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: examples.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final example = examples[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(example.title),
            subtitle: Text(example.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => example.page,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
