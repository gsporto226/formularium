import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/boolean_validation.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  group('BooleanValidation', () {
    test('NotABoolean localize should return validation_not_a_boolean', () async {
      final validation = NotABoolean('abc');
      final l10n = MockL10n();
      addTearDown(resetF10n);
      mockL10n(l10n);

      when(() => l10n.validation_not_a_boolean('abc')).thenReturn('abc não é um booleano');

      final result = validation.localize();
      expect(result, 'abc não é um booleano');
      verify(() => l10n.validation_not_a_boolean('abc')).called(1);
    });
  });
}
