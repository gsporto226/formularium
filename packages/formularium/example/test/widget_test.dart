import 'package:flutter_test/flutter_test.dart';
import 'package:formularium_example/main.dart';

void main() {
  testWidgets('App renders menu with 7 examples', (tester) async {
    await tester.pumpWidget(const FormulariumExampleApp());

    // Verifica o título
    expect(find.text('Formularium — Exemplos'), findsOneWidget);

    // Verifica que todos os 7 exemplos aparecem
    expect(find.text('01 — Formulário Básico'), findsOneWidget);
    expect(find.text('02 — Formulário de Login'), findsOneWidget);
    expect(find.text('03 — Formulário de Perfil'), findsOneWidget);
    expect(find.text('04 — Cadastro de Produto'), findsOneWidget);
    expect(find.text('05 — Visibilidade Dinâmica'), findsOneWidget);
    expect(find.text('06 — Desabilitação Dinâmica'), findsOneWidget);
    expect(find.text('07 — Formulário Alternável'), findsOneWidget);
  });

  testWidgets('Can navigate to BasicFormExample', (tester) async {
    await tester.pumpWidget(const FormulariumExampleApp());

    // Toca no primeiro exemplo
    await tester.tap(find.text('01 — Formulário Básico'));
    await tester.pumpAndSettle();

    // Verifica que navegou para a tela correta
    expect(find.text('01 — Formulário Básico'), findsOneWidget);
    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Enviar'), findsOneWidget);
  });
}
