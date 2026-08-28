import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/date_time_validation.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockL10n l10n;

  setUp(() {
    l10n = MockL10n();
    addTearDown(resetF10n);
    mockL10n(l10n);
  });

  group('DateInvalid', () {
    test('should delegate to l10n.date_invalid', () async {
      when(() => l10n.date_invalid).thenReturn('data inválida');
      const v = DateInvalid();
      final result = v.localize();
      expect(result, 'data inválida');
      verify(() => l10n.date_invalid).called(1);
    });
  });

  group('InvalidTime', () {
    test('should delegate to l10n.validation_invalid_time', () async {
      when(() => l10n.validation_invalid_time('25:00', 'hour24', 'default_')).thenReturn('horário inválido');
      final v = InvalidTime(value: '25:00', hourFormat: 'hour24', mode: 'default_');
      final result = v.localize();
      expect(result, 'horário inválido');
      verify(() => l10n.validation_invalid_time('25:00', 'hour24', 'default_')).called(1);
    });
  });
}
