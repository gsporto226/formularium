import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/number_validation.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Converters', () {
    group('notEmpty', () {
      test('valid', () async {
        final r = await v.notEmpty()('hello');
        expect(r.validation, isNull);
        expect(r.transformed, 'hello');
      });

      test('empty', () async {
        final r = await v.notEmpty()('');
        expect(r.validation, isNotNull);
        expect(r.transformed, '');
      });
    });

    group('asInt', () {
      test('valid', () async {
        final r = await v.asInt()('42');
        expect(r.validation, isNull);
        expect(r.transformed, 42);
      });

      test('invalid', () async {
        final r = await v.asInt()('abc');
        expect(r.validation, isA<NotANumber>());
        final error = r.validation! as NotANumber;
        expect(error.value, 'abc');
        expect(r.transformed, 0);
      });
    });

    group('asDouble', () {
      test('valid decimal', () async {
        expect((await v.asDouble()('3.14')).transformed, 3.14);
      });

      test('invalid', () async {
        final r = await v.asDouble()('abc');
        expect(r.validation, isA<NotANumber>());
        final error = r.validation! as NotANumber;
        expect(error.value, 'abc');
      });
    });

    group('asBool', () {
      test('strict true', () async {
        expect((await v.asBool()('true')).transformed, true);
      });

      test('strict invalid', () async {
        final r = await v.asBool()('yes');
        expect(r.validation, isA<NotABoolean>());
        final error = r.validation! as NotABoolean;
        expect(error.value, 'yes');
      });

      test('loose true', () async {
        expect((await v.asBool(loose: true)('yes')).transformed, true);
      });

      test('loose false/no/0', () async {
        expect((await v.asBool(loose: true)('false')).transformed, false);
        expect((await v.asBool(loose: true)('no')).transformed, false);
        expect((await v.asBool(loose: true)('0')).transformed, false);
      });

      test('strict 1', () async {
        expect((await v.asBool()('1')).transformed, true);
      });

      test('strict 0', () async {
        expect((await v.asBool()('0')).transformed, false);
      });

      test('loose invalid', () async {
        final r = await v.asBool(loose: true)('maybe');
        expect(r.validation, isA<NotABoolean>());
        final error = r.validation! as NotABoolean;
        expect(error.value, 'maybe');
      });
    });

    group('asPort', () {
      test('valid', () async {
        expect((await v.asPort()('8080')).transformed, 8080);
      });

      test('invalid', () async {
        final r = await v.asPort()('abc');
        expect(r.validation, isA<InvalidPort>());
        final error = r.validation! as InvalidPort;
        expect(error.value, 'abc');
      });
    });
  });
}
