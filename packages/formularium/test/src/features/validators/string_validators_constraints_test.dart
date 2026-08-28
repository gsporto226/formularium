import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Constraints', () {
    group('length', () {
      test('valid range', () async {
        final r = await v.length(min: 2, max: 5)('hello');
        expect(r.validation, isNull);
        expect(r.transformed, 'hello');
      });

      test('discrete valid', () async {
        final r = await v.length(discreteLengths: [2, 4])('ab');
        expect(r.validation, isNull);
        expect(r.transformed, 'ab');
      });
      test('discrete invalid', () async {
        final r = await v.length(discreteLengths: [2, 4])('abc');
        expect(r.validation, isA<StringLengthMismatch>());
        final error = r.validation! as StringLengthMismatch;
        expect(error.discrete, [2, 4]);
      });
    });

    group('matches', () {
      test('valid', () async {
        final r = await v.matches(RegExp(r'^\d+$'))('123');
        expect(r.validation, isNull);
        expect(r.transformed, '123');
      });

      test('invalid', () async {
        final r = await v.matches(RegExp(r'^\d+$'))('abc');
        expect(r.validation, isA<PatternMismatch>());
        final error = r.validation! as PatternMismatch;
        expect(error.pattern, r'^\d+$');
      });
    });

    group('isIn', () {
      test('valid', () async {
        final r = await v.isIn(['a', 'b'])('a');
        expect(r.validation, isNull);
        expect(r.transformed, 'a');
      });

      test('invalid', () async {
        expect((await v.isIn(['a', 'b'])('c')).validation, isA<NotInList>());
      });
    });

    group('contains', () {
      test('valid', () async {
        final r = await v.contains('world')('hello world');
        expect(r.validation, isNull);
        expect(r.transformed, 'hello world');
      });
    });

    group('equals', () {
      test('valid', () async {
        final r = await v.equals('hello')('hello');
        expect(r.validation, isNull);
        expect(r.transformed, 'hello');
      });
    });

    test('matches with Pattern string', () async {
      final r = await v.matches('hello')('hello world');
      expect(r.validation, isNull);
      expect(r.transformed, 'hello world');
    });

    test('matches with Pattern string no match', () async {
      final r = await v.matches('xyz')('hello world');
      expect(r.validation, isA<PatternMismatch>());
      final error = r.validation! as PatternMismatch;
      expect(error.pattern, 'xyz');
    });

    test('contains with ignoreCase', () async {
      final r = await v.contains('WORLD', ignoreCase: true)('Hello World');
      expect(r.validation, isNull);
      expect(r.transformed, 'Hello World');
    });

    test('contains with minOccurrences', () async {
      final r = await v.contains('a', minOccurrences: 2)('abc');
      expect(r.validation, isA<MustContain>());
      final error = r.validation! as MustContain;
      expect(error.seed, 'a');
    });

    test('equals when not equal', () async {
      final r = await v.equals('hello')('world');
      expect(r.validation, isA<MustEqual>());
      final error = r.validation! as MustEqual;
      expect(error.comparison, 'hello');
    });

    test('length exceeded max', () async {
      final r = await v.length(max: 2)('hello');
      expect(r.validation, isA<StringLengthExceeded>());
      final error = r.validation! as StringLengthExceeded;
      expect(error.max, 2);
    });
  });
}
