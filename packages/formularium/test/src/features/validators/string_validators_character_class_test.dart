import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Character Class', () {
    group('isAlphanumeric', () {
      test('valid', () async {
        final r = await v.isAlphanumeric()('abc123');
        expect(r.validation, isNull);
        expect(r.transformed, 'abc123');
      });

      test('invalid', () async {
        expect(
          (await v.isAlphanumeric()('abc-123')).validation,
          isA<NotAlphanumeric>(),
        );
      });
    });

    group('isAlpha', () {
      test('valid', () async {
        final r = await v.isAlpha()('abc');
        expect(r.validation, isNull);
        expect(r.transformed, 'abc');
      });

      test('invalid', () async {
        expect((await v.isAlpha()('abc1')).validation, isA<NotAlpha>());
      });
    });

    group('isAscii', () {
      test('valid', () async {
        final r = await v.isAscii()('hello');
        expect(r.validation, isNull);
        expect(r.transformed, 'hello');
      });

      test('non-ascii', () async {
        expect((await v.isAscii()('héllo')).validation, isA<NotAscii>());
      });
    });

    group('isNumeric', () {
      test('valid', () async {
        final r = await v.isNumeric(noSymbols: true)('123');
        expect(r.validation, isNull);
        expect(r.transformed, '123');
      });

      test('invalid', () async {
        final r = await v.isNumeric(noSymbols: true)('12.3');
        expect(r.validation, isA<NotNumeric>());
        final error = r.validation! as NotNumeric;
        expect(error.noSymbols, isTrue);
      });
    });

    group('isHexadecimal', () {
      test('valid', () async {
        final r = await v.isHexadecimal()('DEADBEEF');
        expect(r.validation, isNull);
        expect(r.transformed, 'DEADBEEF');
      });
    });

    group('isLowercase', () {
      test('valid lowercase', () async {
        final r = await v.isLowercase()('hello');
        expect(r.validation, isNull);
        expect(r.transformed, 'hello');
      });
      test('invalid uppercase', () async {
        expect((await v.isLowercase()('Hello')).validation, isA<NotLowercase>());
      });
    });

    group('isUppercase', () {
      test('valid', () async {
        final r = await v.isUppercase()('HELLO');
        expect(r.validation, isNull);
        expect(r.transformed, 'HELLO');
      });
    });

    group('isMultibyte', () {
      test('valid', () async {
        final r = await v.isMultibyte()('こんにちは');
        expect(r.validation, isNull);
        expect(r.transformed, 'こんにちは');
      });
      test('no multibyte', () async {
        expect((await v.isMultibyte()('hello')).validation, isA<NotMultibyte>());
      });
    });

    group('isFullWidth', () {
      test('valid', () async {
        final r = await v.isFullWidth()('ＡＢＣ');
        expect(r.validation, isNull);
        expect(r.transformed, 'ＡＢＣ');
      });
      test('no fullwidth', () async {
        expect((await v.isFullWidth()('ABC')).validation, isA<NotFullWidth>());
      });
    });

    group('isHalfWidth', () {
      test('valid', () async {
        final r = await v.isHalfWidth()('ABC');
        expect(r.validation, isNull);
        expect(r.transformed, 'ABC');
      });
      test('no halfwidth', () async {
        expect((await v.isHalfWidth()('ＡＢＣ')).validation, isA<NotHalfWidth>());
      });
    });

    group('isVariableWidth', () {
      test('valid mixed', () async {
        final r = await v.isVariableWidth()('AＢ');
        expect(r.validation, isNull);
        expect(r.transformed, 'AＢ');
      });
      test('only fullwidth', () async {
        expect((await v.isVariableWidth()('Ａ')).validation, isA<NotVariableWidth>());
      });
      test('only halfwidth', () async {
        expect((await v.isVariableWidth()('A')).validation, isA<NotVariableWidth>());
      });
    });

    group('isSurrogatePair', () {
      test('valid', () async {
        final r = await v.isSurrogatePair()('\u{1D11E}');
        expect(r.validation, isNull);
        expect(r.transformed, '\u{1D11E}');
      });
      test('no surrogate pair', () async {
        expect((await v.isSurrogatePair()('A')).validation, isA<NotSurrogatePair>());
      });
    });

    group('isByteLength', () {
      test('valid within range', () async {
        final r = await v.isByteLength(min: 1, max: 5)('hello');
        expect(r.validation, isNull);
        expect(r.transformed, 'hello');
      });
      test('too short', () async {
        final r = await v.isByteLength(min: 5)('hi');
        expect(r.validation, isA<ByteLengthExceeded>());
        final error = r.validation! as ByteLengthExceeded;
        expect(error.min, 5);
        expect(error.max, isNull);
      });
      test('too long', () async {
        final r = await v.isByteLength(max: 3)('hello');
        expect(r.validation, isA<ByteLengthExceeded>());
        final error = r.validation! as ByteLengthExceeded;
        expect(error.max, 3);
      });
    });

    test('isHexadecimal invalid', () async {
      expect((await v.isHexadecimal()('XYZ')).validation, isA<NotHexadecimal>());
    });

    test('isAscii non-ascii', () async {
      expect((await v.isAscii()('héllo')).validation, isA<NotAscii>());
    });

    test('isUppercase invalid', () async {
      expect((await v.isUppercase()('Hello')).validation, isA<NotUppercase>());
    });

    test('isLowercase invalid', () async {
      expect((await v.isLowercase()('Hello')).validation, isA<NotLowercase>());
    });

    test('isAlphanumeric with ignore', () async {
      final r = await v.isAlphanumeric(ignore: '-')('abc-123');
      expect(r.validation, isNull);
      expect(r.transformed, 'abc-123');
    });

    test('isAlpha with ignore', () async {
      final r = await v.isAlpha(ignore: '-')('abc-def');
      expect(r.validation, isNull);
      expect(r.transformed, 'abc-def');
    });
  });
}
