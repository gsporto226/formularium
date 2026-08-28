import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/time_validation.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  group('TimeValidation', () {
    test('InvalidTime localize should return validation_invalid_time', () async {
      final validation = InvalidTime(value: '25:00', hourFormat: 'hour24', mode: 'default_');
      final l10n = MockL10n();
      final context = mockContext(l10n);

      when(() => l10n.validation_invalid_time('25:00', 'hour24', 'default_')).thenReturn('horário inválido');

      final result = validation.localize(context);
      expect(result, 'horário inválido');
      verify(() => l10n.validation_invalid_time('25:00', 'hour24', 'default_')).called(1);
    });
  });
}
