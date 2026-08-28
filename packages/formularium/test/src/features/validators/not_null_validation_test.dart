import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/not_null_validation.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  group('RequiredValidation', () {
    test('localize delegates to l10n.required_field_label', () async {
      const validation = RequiredValidation();
      final l10n = MockL10n();
      addTearDown(resetF10n);
      mockL10n(l10n);

      when(() => l10n.required_field_label).thenReturn('Campo obrigatório');

      final result = validation.localize();
      expect(result, 'Campo obrigatório');
      verify(() => l10n.required_field_label).called(1);
    });
  });
}
