import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/number_validation.dart';
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

  group('NumberTooBig', () {
    test('localize', () async {
      when(() => l10n.number_field_value_too_big('100')).thenReturn('máx 100');
      final validation = NumberTooBig(100);
      final result = validation.localize();
      expect(result, 'máx 100');
      verify(() => l10n.number_field_value_too_big('100')).called(1);
    });
  });

  group('NumberTooSmall', () {
    test('localize', () async {
      when(() => l10n.number_field_value_too_small('10')).thenReturn('mín 10');
      final validation = NumberTooSmall(10);
      final result = validation.localize();
      expect(result, 'mín 10');
      verify(() => l10n.number_field_value_too_small('10')).called(1);
    });
  });

  group('NotANumber', () {
    test('localize', () async {
      when(() => l10n.validation_not_a_number).thenReturn('não é número');
      final validation = NotANumber(value: 'abc');
      expect(validation.value, 'abc');
      final result = validation.localize();
      expect(result, 'não é número');
      verify(() => l10n.validation_not_a_number).called(1);
    });
  });

  group('NotDivisible', () {
    test('localize', () async {
      when(() => l10n.number_field_not_divisible('3')).thenReturn('não divisível por 3');
      final validation = NotDivisible(3);
      final result = validation.localize();
      expect(result, 'não divisível por 3');
      verify(() => l10n.number_field_not_divisible('3')).called(1);
    });
  });

  group('NotPositive', () {
    test('localize', () async {
      when(() => l10n.number_field_not_positive).thenReturn('não positivo');
      const validation = NotPositive();
      final result = validation.localize();
      expect(result, 'não positivo');
      verify(() => l10n.number_field_not_positive).called(1);
    });
  });

  group('NotNegative', () {
    test('localize', () async {
      when(() => l10n.number_field_not_negative).thenReturn('não negativo');
      const validation = NotNegative();
      final result = validation.localize();
      expect(result, 'não negativo');
      verify(() => l10n.number_field_not_negative).called(1);
    });
  });
}
