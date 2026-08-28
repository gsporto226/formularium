import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/lat_long_validation.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  group('LatLongValidation', () {
    test('InvalidLatLong localize should return validation_invalid_lat_long', () async {
      final validation = InvalidLatLong('999,999');
      final l10n = MockL10n();
      final context = mockContext(l10n);

      when(() => l10n.validation_invalid_lat_long('999,999')).thenReturn('coordenada inválida');

      final result = validation.localize(context);
      expect(result, 'coordenada inválida');
      verify(() => l10n.validation_invalid_lat_long('999,999')).called(1);
    });
  });
}
