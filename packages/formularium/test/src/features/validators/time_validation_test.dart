import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/time_validation.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  group('TimeValidation', () {
    test('InvalidTime localize should return validation_invalid_time', () async {
      final validation = InvalidTime(value: '25:00', hourFormat: 'hour24', mode: 'default_');
      final l10n = MockL10n();
      addTearDown(resetF10n);
      mockL10n(l10n);

      when(() => l10n.validation_invalid_time('25:00', 'hour24', 'default_')).thenReturn('horário inválido');

      final result = validation.localize();
      expect(result, 'horário inválido');
      verify(() => l10n.validation_invalid_time('25:00', 'hour24', 'default_')).called(1);
    });
  });
}
