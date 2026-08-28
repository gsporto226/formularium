import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/date_time_validation.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockL10n l10n;
  late MockContext context;

  setUp(() {
    l10n = MockL10n();
    context = mockContext(l10n);
  });

  group('DateInvalid', () {
    test('should delegate to l10n.date_invalid', () async {
      when(() => l10n.date_invalid).thenReturn('data inválida');
      const v = DateInvalid();
      final result = v.localize(context);
      expect(result, 'data inválida');
      verify(() => l10n.date_invalid).called(1);
    });
  });

  group('InvalidTime', () {
    test('should delegate to l10n.validation_invalid_time', () async {
      when(() => l10n.validation_invalid_time('25:00', 'hour24', 'default_')).thenReturn('horário inválido');
      final v = InvalidTime(value: '25:00', hourFormat: 'hour24', mode: 'default_');
      final result = v.localize(context);
      expect(result, 'horário inválido');
      verify(() => l10n.validation_invalid_time('25:00', 'hour24', 'default_')).called(1);
    });
  });
}
