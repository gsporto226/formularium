import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_postal_code_validator.dart' show postalCodeLocales;
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Geographic', () {
    group('isLatLong', () {
      test('valid decimal', () async {
        final r = await v.isLatLong()('-23.5505, -46.6333');
        expect(r.validation, isNull);
        final ll = r.transformed;
        expect(ll.lat, closeTo(-23.5505, 0.001));
      });
      test('valid DMS', () async {
        final r = await v.isLatLong(checkDMS: true)("40° 26' 46\" N, 79° 58' 56\" W");
        expect(r.validation, isNull);
        expect(r.transformed.lat, closeTo(40.446, 0.01));
        expect(r.transformed.lng, closeTo(-79.982, 0.01));
      });
      test('invalid DMS', () async {
        final r = await v.isLatLong(checkDMS: true)('not,valid');
        expect(r.validation, isA<InvalidLatLong>());
        final error = r.validation! as InvalidLatLong;
        expect(error.value, 'not,valid');
      });
      test('lat out of range', () async {
        final r = await v.isLatLong()('100, 0');
        expect(r.validation, isA<InvalidLatLong>());
        final error = r.validation! as InvalidLatLong;
        expect(error.value, '100, 0');
      });
      test('lng out of range', () async {
        final r = await v.isLatLong()('0, 200');
        expect(r.validation, isA<InvalidLatLong>());
        final error = r.validation! as InvalidLatLong;
        expect(error.value, '0, 200');
      });
      test('invalid format', () async {
        final r = await v.isLatLong()('not,valid');
        expect(r.validation, isA<InvalidLatLong>());
        final error = r.validation! as InvalidLatLong;
        expect(error.value, 'not,valid');
      });
    });

    group('isPostalCode', () {
      final postalCodeFixtures = <String, ({List<String> valid, List<String> invalid})>{
        // Use real postal codes for each country
        'AD': (valid: ['AD100', 'AD999'], invalid: ['100', 'AD10', 'AD1000']),
        'AT': (valid: ['1010', '9999'], invalid: ['101', '10100', 'abcd']),
        'AU': (valid: ['2000', '9999'], invalid: ['200', '20000', 'abcd']),
        'AZ': (valid: ['AZ1000', 'AZ9999'], invalid: ['1000', 'AZ100', 'AZ10000']),
        'BA': (valid: ['71000', '89999'], invalid: ['61000', '91000', 'abcde']),
        'BD': (valid: ['1000', '8999', '9449'], invalid: ['0999', '9500', 'abcd']),
        'BE': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'BG': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'BR': (valid: ['01310-000', '01310000', '99999-999'], invalid: ['0131-000', 'abc', '']),
        'BY': (valid: ['210000', '249999'], invalid: ['200000', '250000', 'abcd']),
        'CA': (valid: ['K1A 0B1', 'V6B 4Y6', 'M5V2T6'], invalid: ['D1A 0B1', '12345', 'abc']),
        'CH': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'CN': (valid: ['010000', '710000', '990000'], invalid: ['000000', '080000', '1000000']),
        'CO': (valid: ['050001', '990001'], invalid: ['010001', '100001', 'abcdef']),
        'CZ': (valid: ['100 00', '10000', '999 99'], invalid: ['10 00', '100', 'abc']),
        'DE': (valid: ['10115', '99999'], invalid: ['1011', '101155', 'abcde']),
        'DK': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'DO': (valid: ['10101', '99999'], invalid: ['1010', '101010', 'abcde']),
        'DZ': (valid: ['10000', '99999'], invalid: ['1000', '100000', 'abcde']),
        'EE': (valid: ['10101', '99999'], invalid: ['1010', '101010', 'abcde']),
        'ES': (valid: ['08001', '52999'], invalid: ['53001', '60000', 'abcde']),
        'FI': (valid: ['00100', '99999'], invalid: ['0010', '001000', 'abcde']),
        'FR': (valid: ['01000', '95999', '97100'], invalid: ['96000', '00999', '00100']),
        'GB': (valid: ['SW1A 1AA', 'EC1A 1BB', 'GIR 0AA'], invalid: ['SW1A 1A', '12345', 'abc']),
        'GR': (valid: ['100 00', '10000', '999 99'], invalid: ['10 00', '100', 'abc']),
        'HR': (valid: ['10000', '59999'], invalid: ['09999', '60000', 'abcd']),
        'HT': (valid: ['HT1000', 'HT9999'], invalid: ['1000', 'HT100', 'HT10000']),
        'HU': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'ID': (valid: ['10110', '99999'], invalid: ['1011', '101100', 'abcde']),
        'IE': (valid: ['D01 F5P2', 'A65 F4E2'], invalid: ['O01 F5P2', '12345', 'abc']),
        'IL': (valid: ['10000', '1000000'], invalid: ['1000', '10000000', 'abcd']),
        'IN': (valid: ['110001', '999999'], invalid: ['100000', '290001', 'abcdef']),
        'IR': (valid: ['1416813456', '4416813456'], invalid: ['1111111111', '2416812345', 'abc']),
        'IS': (valid: ['101', '999'], invalid: ['10', '1000', 'abc']),
        'IT': (valid: ['00100', '99999'], invalid: ['0010', '001000', 'abcde']),
        'JP': (valid: ['100-0000', '999-9999'], invalid: ['1000-000', '1000000', 'abc']),
        'KE': (valid: ['10100', '99999'], invalid: ['1010', '101000', 'abcde']),
        'KR': (valid: ['10000', '100000'], invalid: ['1000', '1000000', 'abcd']),
        'LI': (valid: ['9485', '9497'], invalid: ['9484', '9498', '9500']),
        'LT': (valid: ['LT-10000', 'LT-99999'], invalid: ['10000', 'LT-1000', 'LT-100000']),
        'LU': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'LV': (valid: ['LV-1000', 'LV-9999'], invalid: ['1000', 'LV-100', 'LV-10000']),
        'LK': (valid: ['10100', '99999'], invalid: ['1010', '101000', 'abcde']),
        'MC': (valid: ['98000', '98099'], invalid: ['98100', '9800', 'abcde']),
        'MG': (valid: ['101', '999'], invalid: ['10', '1000', 'abc']),
        'MX': (valid: ['01000', '99999'], invalid: ['0100', '010000', 'abcde']),
        'MT': (valid: ['ABC 1000', 'ABC1000', 'XYZ9999'], invalid: ['AB 1000', '1000', 'abc']),
        'MY': (valid: ['10000', '99999'], invalid: ['1000', '100000', 'abcde']),
        'NL': (valid: ['1234 AB', '1234AB'], invalid: ['0123 AB', '1234 SD', 'abc']),
        'NO': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'NP': (valid: ['10000', '22999', '33999', '977'], invalid: ['09999', '20000', 'abc']),
        'NZ': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'PK': (valid: ['10000', '99999'], invalid: ['1000', '100000', 'abcde']),
        'PL': (valid: ['00-100', '99-999'], invalid: ['00100', '0-100', 'abc']),
        'PR': (valid: ['00601', '00999', '00601-1234'], invalid: ['00501', '01000', 'abc']),
        'PT': (valid: ['1000-000', '9999-999'], invalid: ['100-000', '10000-000', 'abc']),
        'RO': (valid: ['010101', '999999'], invalid: ['01010', '0101010', 'abcdef']),
        'RU': (valid: ['101000', '999999'], invalid: ['10100', '1010000', 'abcdef']),
        'SA': (valid: ['10000', '99999'], invalid: ['1000', '100000', 'abcde']),
        'SE': (valid: ['100 12', '10012', '999 99'], invalid: ['001 12', '100 1', 'abc']),
        'SG': (valid: ['100001', '999999'], invalid: ['10000', '1000000', 'abcdef']),
        'SI': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'SK': (valid: ['100 00', '10000', '999 99'], invalid: ['10 00', '100', 'abc']),
        'TH': (valid: ['10100', '99999'], invalid: ['1010', '101000', 'abcde']),
        'TN': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'TW': (valid: ['100', '10000', '10099'], invalid: ['10', '1000000', 'abc']),
        'UA': (valid: ['10000', '99999'], invalid: ['1000', '100000', 'abcde']),
        'US': (valid: ['90210', '90210-1234', '10001'], invalid: ['9021', '90210-123', 'abc']),
        'ZA': (valid: ['1000', '9999'], invalid: ['100', '10000', 'abcd']),
        'ZM': (valid: ['10100', '99999'], invalid: ['1010', '101000', 'abcde']),
      };

      for (final entry in postalCodeFixtures.entries) {
        final country = entry.key;
        final fixtures = entry.value;
        group(country, () {
          for (final valid in fixtures.valid) {
            test('valid: $valid', () async {
              final r = await v.isPostalCode(country)(valid);
              expect(r.validation, isNull);
              expect(r.transformed, valid);
            });
          }
          for (final invalid in fixtures.invalid) {
            test('invalid: $invalid', () async {
              final r = await v.isPostalCode(country)(invalid);
              expect(r.validation, isA<InvalidPostalCode>());
              final error = r.validation! as InvalidPostalCode;
              expect(error.value, invalid);
            });
          }
        });
      }
    });

    test('postalCodeLocales returns keys with minimum count', () async {
      expect(postalCodeLocales, contains('BR'));
      expect(postalCodeLocales.length, greaterThan(60));
    });

    test('isLatLong DMS lat out of range', () async {
      final r = await v.isLatLong(checkDMS: true)('200° 00′ 00″ N, 000° 00′ 00″ E');
      expect(r.validation, isA<InvalidLatLong>());
      final error = r.validation! as InvalidLatLong;
      expect(error.value, '200° 00′ 00″ N, 000° 00′ 00″ E');
    });

    test('isLatLong DMS minutes out of range', () async {
      final r = await v.isLatLong(checkDMS: true)("40° 60' 00\" N, 000° 00' 00\" E");
      expect(r.validation, isA<InvalidLatLong>());
      final error = r.validation! as InvalidLatLong;
      expect(error.value, "40° 60' 00\" N, 000° 00' 00\" E");
    });

    test('isLatLong DMS longitude out of range', () async {
      final r = await v.isLatLong(checkDMS: true)("40° 00' 00\" N, 200° 00' 00\" E");
      expect(r.validation, isA<InvalidLatLong>());
      final error = r.validation! as InvalidLatLong;
      expect(error.value, "40° 00' 00\" N, 200° 00' 00\" E");
    });
  });
}
