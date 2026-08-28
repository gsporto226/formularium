import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Encoding', () {
    group('isBase64', () {
      test('valid', () async {
        final r = await v.isBase64()('dGVzdA==');
        expect(r.validation, isNull);
        expect(r.transformed, 'dGVzdA==');
      });
    });

    group('isBase32', () {
      test('valid JBSWY3DP', () async {
        final r = await v.isBase32()('JBSWY3DP');
        expect(r.validation, isNull);
        expect(r.transformed, 'JBSWY3DP');
      });
      test('valid NBSWY3DP', () async {
        final r = await v.isBase32()('NBSWY3DP');
        expect(r.validation, isNull);
        expect(r.transformed, 'NBSWY3DP');
      });
      test('empty', () async {
        final r = await v.isBase32()('');
        expect(r.validation, isA<InvalidBase32>());
        final error = r.validation! as InvalidBase32;
        expect(error.value, '');
      });
      test('invalid chars with exclamation', () async {
        final r = await v.isBase32()('ABC!');
        expect(r.validation, isA<InvalidBase32>());
        final error = r.validation! as InvalidBase32;
        expect(error.value, 'ABC!');
      });
      test('invalid chars with digit 0', () async {
        final r = await v.isBase32()('ABC0');
        expect(r.validation, isA<InvalidBase32>());
        final error = r.validation! as InvalidBase32;
        expect(error.value, 'ABC0');
      });
    });

    group('isBase58', () {
      test('valid', () async {
        final r = await v.isBase58()('1A1zP1e');
        expect(r.validation, isNull);
        expect(r.transformed, '1A1zP1e');
      });
      test('empty', () async {
        final r = await v.isBase58()('');
        expect(r.validation, isA<InvalidBase58>());
        final error = r.validation! as InvalidBase58;
        expect(error.value, '');
      });
      test('invalid chars 0OIl', () async {
        final r = await v.isBase58()('0OIl');
        expect(r.validation, isA<InvalidBase58>());
        final error = r.validation! as InvalidBase58;
        expect(error.value, '0OIl');
      });
      test('invalid chars with symbol', () async {
        final r = await v.isBase58()('abc!');
        expect(r.validation, isA<InvalidBase58>());
        final error = r.validation! as InvalidBase58;
        expect(error.value, 'abc!');
      });
    });

    group('isHexadecimal', () {
      test('valid', () async {
        final r = await v.isHexadecimal()('DEADBEEF');
        expect(r.validation, isNull);
        expect(r.transformed, 'DEADBEEF');
      });
    });

    group('isOctal', () {
      test('valid', () async {
        var r = await v.isOctal()('123');
        expect(r.validation, isNull);
        expect(r.transformed, '123');
        r = await v.isOctal()('0');
        expect(r.validation, isNull);
        expect(r.transformed, '0');
        r = await v.isOctal()('777');
        expect(r.validation, isNull);
        expect(r.transformed, '777');
      });
      test('invalid', () async {
        expect((await v.isOctal()('891')).validation, isA<NotOctal>());
        expect((await v.isOctal()('abc')).validation, isA<NotOctal>());
      });
    });

    test('isBase64 empty', () async {
      final r = await v.isBase64()('');
      expect(r.validation, isA<NotBase64>());
      final error = r.validation! as NotBase64;
      expect(error.value, '');
    });

    test('isBase64 invalid chars', () async {
      final r = await v.isBase64()('!!!');
      expect(r.validation, isA<NotBase64>());
      final error = r.validation! as NotBase64;
      expect(error.value, '!!!');
    });

    test('isBase64 wrong padding length', () async {
      final r = await v.isBase64()('AAA');
      expect(r.validation, isA<NotBase64>());
      final error = r.validation! as NotBase64;
      expect(error.value, 'AAA');
    });

    test('isBase64 invalid padding position', () async {
      final r = await v.isBase64()('A=A=');
      expect(r.validation, isA<NotBase64>());
      final error = r.validation! as NotBase64;
      expect(error.value, 'A=A=');
    });

    test('isBase64 urlSafe', () async {
      final r = await v.isBase64(urlSafe: true)('dGVzdA==');
      expect(r.validation, isNull);
      expect(r.transformed, 'dGVzdA==');
    });

    test('isHexadecimal invalid', () async {
      expect((await v.isHexadecimal()('XYZ')).validation, isA<NotHexadecimal>());
    });

    test('isBase32 short invalid', () async {
      final r = await v.isBase32()('A');
      expect(r.validation, isA<InvalidBase32>());
      final error = r.validation! as InvalidBase32;
      expect(error.value, 'A');
    });
  });
}
