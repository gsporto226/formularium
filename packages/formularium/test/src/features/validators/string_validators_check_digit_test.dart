import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Check Digit IDs', () {
    group('isISBN', () {
      test('valid ISBN-10 with hyphens', () async {
        final r = await v.isISBN()('0-306-40615-2');
        expect(r.validation, isNull);
        expect(r.transformed, '0-306-40615-2');
      });

      test('valid ISBN-10 without hyphens', () async {
        final r = await v.isISBN()('0306406152');
        expect(r.validation, isNull);
        expect(r.transformed, '0306406152');
      });

      test('valid ISBN-13', () async {
        final r = await v.isISBN()('978-0-306-40615-7');
        expect(r.validation, isNull);
        expect(r.transformed, '978-0-306-40615-7');
      });

      test('version 10 only valid', () async {
        final r = await v.isISBN(version: 10)('0306406152');
        expect(r.validation, isNull);
        expect(r.transformed, '0306406152');
      });

      test('version 10 only rejects ISBN-13', () async {
        final r = await v.isISBN(version: 10)('9780306406157');
        expect(r.validation, isA<InvalidIsbn>());
        final error = r.validation! as InvalidIsbn;
        expect(error.value, '9780306406157');
      });

      test('version 13 only valid', () async {
        final r = await v.isISBN(version: 13)('9780306406157');
        expect(r.validation, isNull);
        expect(r.transformed, '9780306406157');
      });

      test('version 13 only rejects ISBN-10', () async {
        final r = await v.isISBN(version: 13)('0306406152');
        expect(r.validation, isA<InvalidIsbn>());
        final error = r.validation! as InvalidIsbn;
        expect(error.value, '0306406152');
      });

      test('invalid ISBN digits', () async {
        final r = await v.isISBN()('1234567890');
        expect(r.validation, isA<InvalidIsbn>());
        final error = r.validation! as InvalidIsbn;
        expect(error.value, '1234567890');
      });

      test('invalid ISBN chars', () async {
        final r = await v.isISBN()('abcdefghij');
        expect(r.validation, isA<InvalidIsbn>());
        final error = r.validation! as InvalidIsbn;
        expect(error.value, 'abcdefghij');
      });
    });

    group('isEAN', () {
      test('valid EAN-13', () async {
        final r = await v.isEAN()('5901234123457');
        expect(r.validation, isNull);
        expect(r.transformed, '5901234123457');
      });
      test('valid EAN-8', () async {
        final r = await v.isEAN()('73513537');
        expect(r.validation, isNull);
        expect(r.transformed, '73513537');
      });
      test('type ean8 valid', () async {
        final r = await v.isEAN(type: 'ean8')('73513537');
        expect(r.validation, isNull);
        expect(r.transformed, '73513537');
      });
      test('type ean8 rejects ean13', () async {
        final r = await v.isEAN(type: 'ean8')('5901234123457');
        expect(r.validation, isA<InvalidEan>());
        final error = r.validation! as InvalidEan;
        expect(error.value, '5901234123457');
      });
      test('type ean13 valid', () async {
        final r = await v.isEAN(type: 'ean13')('5901234123457');
        expect(r.validation, isNull);
        expect(r.transformed, '5901234123457');
      });
      test('type ean13 rejects ean8', () async {
        final r = await v.isEAN(type: 'ean13')('73513537');
        expect(r.validation, isA<InvalidEan>());
        final error = r.validation! as InvalidEan;
        expect(error.value, '73513537');
      });
      test('invalid checksum', () async {
        final r = await v.isEAN()('1234567890123');
        expect(r.validation, isA<InvalidEan>());
        final error = r.validation! as InvalidEan;
        expect(error.value, '1234567890123');
      });
    });

    test('isEAN invalid digits', () async {
      final r = await v.isEAN()('abc');
      expect(r.validation, isA<InvalidEan>());
      final error = r.validation! as InvalidEan;
      expect(error.value, 'abc');
    });

    test('isEAN type ean13 with 8-digit', () async {
      final r = await v.isEAN(type: 'ean13')('73513537');
      expect(r.validation, isA<InvalidEan>());
      final error = r.validation! as InvalidEan;
      expect(error.value, '73513537');
    });

    test('isEAN type ean8 with 13-digit', () async {
      final r = await v.isEAN(type: 'ean8')('5901234123457');
      expect(r.validation, isA<InvalidEan>());
      final error = r.validation! as InvalidEan;
      expect(error.value, '5901234123457');
    });

    test('isEAN type ean8 invalid length', () async {
      final r = await v.isEAN(type: 'ean8')('1234567');
      expect(r.validation, isA<InvalidEan>());
      final error = r.validation! as InvalidEan;
      expect(error.value, '1234567');
    });
  });
}
