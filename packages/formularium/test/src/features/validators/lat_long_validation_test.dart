import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/lat_long_validation.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  group('LatLongValidation', () {
    test('InvalidLatLong localize should return validation_invalid_lat_long', () async {
      final validation = InvalidLatLong('999,999');
      final l10n = MockL10n();
      addTearDown(resetF10n);
      mockL10n(l10n);

      when(() => l10n.validation_invalid_lat_long('999,999')).thenReturn('coordenada inválida');

      final result = validation.localize();
      expect(result, 'coordenada inválida');
      verify(() => l10n.validation_invalid_lat_long('999,999')).called(1);
    });
  });
}
