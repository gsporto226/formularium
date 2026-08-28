// test/src/features/validators/f_l10n_resolution_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

void main() {
  tearDown(resetF10n);
  test('en resolves via Intl.defaultLocale', () async {
    await initFormulariumL10n('en');
    expect(fL10n.validation_not_a_number, 'Not a valid number');
  });
  test('pt resolves', () async {
    await initFormulariumL10n('pt');
    expect(fL10n.validation_not_a_number, 'Não é um número válido');
  });
  test('test override hook works', () async {
    await initFormulariumL10n('en');
    fL10n = _FixedL10n();
    expect(fL10n.validation_not_a_number, 'fixed');
    resetF10n();
    expect(fL10n.validation_not_a_number, 'Not a valid number');
  });
}

class _FixedL10n implements IFormulariumLocalizations {
  @override
  dynamic noSuchMethod(Invocation i) => 'fixed';
}
