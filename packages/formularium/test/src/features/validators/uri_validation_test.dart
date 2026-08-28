import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/uri_validation.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  group('UriValidation', () {
    test('InvalidUrl localize should return validation_invalid_url', () async {
      final validation = InvalidUrl('not-a-url');
      final l10n = MockL10n();
      addTearDown(resetF10n);
      mockL10n(l10n);

      when(() => l10n.validation_invalid_url('not-a-url')).thenReturn('URL inválida');

      final result = validation.localize();
      expect(result, 'URL inválida');
      verify(() => l10n.validation_invalid_url('not-a-url')).called(1);
    });
  });
}
