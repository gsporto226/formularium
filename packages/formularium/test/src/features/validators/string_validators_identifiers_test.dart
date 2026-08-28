import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Identifiers', () {
    group('isSemVer', () {
      test('valid', () async {
        final r = await v.isSemVer()('1.2.3');
        expect(r.validation, isNull);
        expect(r.transformed, '1.2.3');
      });

      test('invalid', () async {
        final r = await v.isSemVer()('abc');
        expect(r.validation, isA<InvalidSemVer>());
        final error = r.validation! as InvalidSemVer;
        expect(error.value, 'abc');
      });
    });

    group('isJWT', () {
      test('valid', () async {
        final r = await v.isJWT()(
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U',
        );
        expect(r.validation, isNull);
        expect(
          r.transformed,
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U',
        );
      });
    });

    group('isSlug', () {
      test('valid', () async {
        final r = await v.isSlug()('hello-world');
        expect(r.validation, isNull);
        expect(r.transformed, 'hello-world');
      });

      test('invalid', () async {
        final r = await v.isSlug()('Hello World');
        expect(r.validation, isA<InvalidSlug>());
        final error = r.validation! as InvalidSlug;
        expect(error.value, 'Hello World');
      });
    });

    group('isMimeType', () {
      test('valid', () async {
        final r = await v.isMimeType()('text/plain');
        expect(r.validation, isNull);
        expect(r.transformed, 'text/plain');
      });
    });

    group('isLocale', () {
      test('valid', () async {
        final r = await v.isLocale()('en-US');
        expect(r.validation, isNull);
        expect(r.transformed, 'en-US');
      });

      test('invalid', () async {
        final r = await v.isLocale()('toolong');
        expect(r.validation, isA<InvalidLocale>());
        final error = r.validation! as InvalidLocale;
        expect(error.value, 'toolong');
      });
    });

    group('isMongoId', () {
      test('valid', () async {
        final r = await v.isMongoId()('507f1f77bcf86cd799439011');
        expect(r.validation, isNull);
        expect(r.transformed, '507f1f77bcf86cd799439011');
      });
    });

    group('isMD5', () {
      test('valid', () async {
        final r = await v.isMD5()('d41d8cd98f00b204e9800998ecf8427e');
        expect(r.validation, isNull);
        expect(r.transformed, 'd41d8cd98f00b204e9800998ecf8427e');
      });
    });

    group('isHash', () {
      test('valid sha256', () async {
        final r = await v.isHash('sha256')('e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');
        expect(r.validation, isNull);
        expect(r.transformed, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');
      });
    });

    group('isIMEI', () {
      test('valid', () async {
        final r = await v.isIMEI()('490154203237518');
        expect(r.validation, isNull);
        expect(r.transformed, '490154203237518');
      });
      test('allowHyphens', () async {
        final r = await v.isIMEI(allowHyphens: true)('490154-203237518');
        expect(r.validation, isNull);
        expect(r.transformed, '490154-203237518');
      });
      test('invalid length', () async {
        final r = await v.isIMEI()('123');
        expect(r.validation, isA<InvalidImei>());
        final error = r.validation! as InvalidImei;
        expect(error.value, '123');
      });
      test('invalid Luhn', () async {
        final r = await v.isIMEI()('490154203237519');
        expect(r.validation, isA<InvalidImei>());
        final error = r.validation! as InvalidImei;
        expect(error.value, '490154203237519');
      });
    });

    group('isJSON', () {
      test('valid object', () async {
        final r = await v.isJson()('{"a":1}');
        expect(r.validation, isNull);
        expect(r.transformed, '{"a":1}');
      });
      test('valid array', () async {
        final r = await v.isJson()('[1,2,3]');
        expect(r.validation, isNull);
        expect(r.transformed, '[1,2,3]');
      });
      test('valid string primitive', () async {
        final r = await v.isJson()('"string"');
        expect(r.validation, isNull);
        expect(r.transformed, '"string"');
      });
      test('valid number primitive', () async {
        final r = await v.isJson()('123');
        expect(r.validation, isNull);
        expect(r.transformed, '123');
      });
      test('valid boolean primitive', () async {
        final r = await v.isJson()('true');
        expect(r.validation, isNull);
        expect(r.transformed, 'true');
      });
      test('valid null primitive', () async {
        final r = await v.isJson()('null');
        expect(r.validation, isNull);
        expect(r.transformed, 'null');
      });
      test('invalid object', () async {
        final r = await v.isJson()('{bad}');
        expect(r.validation, isA<InvalidJson>());
        final error = r.validation! as InvalidJson;
        expect(error.value, '{bad}');
      });
      test('invalid undefined', () async {
        final r = await v.isJson()('undefined');
        expect(r.validation, isA<InvalidJson>());
        final error = r.validation! as InvalidJson;
        expect(error.value, 'undefined');
      });
    });

    test('isJWT invalid parts', () async {
      final r = await v.isJWT()('abc.def');
      expect(r.validation, isA<InvalidJwt>());
      final error = r.validation! as InvalidJwt;
      expect(error.value, 'abc.def');
    });

    test('isJWT empty part', () async {
      final r = await v.isJWT()('abc..def');
      expect(r.validation, isA<InvalidJwt>());
      final error = r.validation! as InvalidJwt;
      expect(error.value, 'abc..def');
    });

    test('isHash unknown algorithm', () async {
      final r = await v.isHash('unknown')('abc');
      expect(r.validation, isA<InvalidHash>());
      final error = r.validation! as InvalidHash;
      expect(error.algorithm, 'unknown');
    });

    test('isHash wrong length', () async {
      final r = await v.isHash('md5')('abc');
      expect(r.validation, isA<InvalidHash>());
      final error = r.validation! as InvalidHash;
      expect(error.algorithm, 'md5');
    });

    test('isMimeType invalid', () async {
      final r = await v.isMimeType()('notvalid');
      expect(r.validation, isA<InvalidMimeType>());
      final error = r.validation! as InvalidMimeType;
      expect(error.value, 'notvalid');
    });

    test('isMongoId invalid', () async {
      final r = await v.isMongoId()('xyz');
      expect(r.validation, isA<InvalidMongoId>());
      final error = r.validation! as InvalidMongoId;
      expect(error.value, 'xyz');
    });

    test('isJWT decode fail', () async {
      final r = await v.isJWT()('eyJ.!!!.eyJ');
      expect(r.validation, isA<InvalidJwt>());
      final error = r.validation! as InvalidJwt;
      expect(error.value, 'eyJ.!!!.eyJ');
    });
  });
}
