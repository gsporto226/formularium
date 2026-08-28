import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Password', () {
    group('isStrongPassword', () {
      test('strong enough', () async {
        final r = await v.isStrongPassword()('Abcd1234!');
        expect(r.validation, isNull);
        expect(r.transformed, 'Abcd1234!');
      });

      test('too weak', () async {
        final r = await v.isStrongPassword(minLength: 80)('a');
        expect(r.validation, isA<WeakPassword>());
        final error = r.validation! as WeakPassword;
        expect(error.score, lessThan(error.minScore));
      });

      test('strong enough with custom requirements', () async {
        final r = await v.isStrongPassword(minLength: 6, minSymbols: 0)('Abcde1');
        expect(r.validation, isNull);
        expect(r.transformed, 'Abcde1');
      });

      test('too short', () async {
        final r = await v.isStrongPassword(minLength: 10)('Ab1!');
        expect(r.validation, isA<WeakPassword>());
        final error = r.validation! as WeakPassword;
        expect(error.score, lessThan(error.minScore));
      });

      test('missing uppercase', () async {
        final r = await v.isStrongPassword(minNumbers: 0, minSymbols: 0)('abcdef1');
        expect(r.validation, isA<WeakPassword>());
        final error = r.validation! as WeakPassword;
        expect(error.score, lessThan(error.minScore));
      });

      test('missing lowercase', () async {
        final r = await v.isStrongPassword(minNumbers: 0, minSymbols: 0)('ABCDEF1');
        expect(r.validation, isA<WeakPassword>());
        final error = r.validation! as WeakPassword;
        expect(error.score, lessThan(error.minScore));
      });

      test('missing number when required', () async {
        final r = await v.isStrongPassword(minSymbols: 0)('Abcdef!');
        expect(r.validation, isA<WeakPassword>());
        final error = r.validation! as WeakPassword;
        expect(error.score, lessThan(error.minScore));
      });

      test('missing symbol when required', () async {
        final r = await v.isStrongPassword()('Abcd1234');
        expect(r.validation, isA<WeakPassword>());
        final error = r.validation! as WeakPassword;
        expect(error.score, lessThan(error.minScore));
      });

      test('meets exact minimums', () async {
        final r = await v.isStrongPassword()('Abcd123!');
        expect(r.validation, isNull);
        expect(r.transformed, 'Abcd123!');
      });

      test('very weak with high minimums', () async {
        final r = await v.isStrongPassword(minLength: 20, pointsPerUnique: 10)('a');
        expect(r.validation, isA<WeakPassword>());
        final error = r.validation! as WeakPassword;
        expect(error.score, lessThan(error.minScore));
      });
    });
  });
}
