import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Email', () {
    group('isEmail', () {
      test('valid', () async {
        final r = await v.isEmail()('test@example.com');
        expect(r.validation, isNull);
        expect(r.transformed, 'test@example.com');
      });
      test('invalid', () async {
        final r = await v.isEmail()('notanemail');
        expect(r.validation, isA<InvalidEmail>());
        final error = r.validation! as InvalidEmail;
        expect(error.value, 'notanemail');
      });
      test('allowDisplayName', () async {
        final r = await v.isEmail(allowDisplayName: true)('John <john@example.com>');
        expect(r.validation, isNull);
        expect(r.transformed, 'John <john@example.com>');
      });
      test('requireDisplayName missing', () async {
        final r = await v.isEmail(requireDisplayName: true)('john@example.com');
        expect(r.validation, isA<InvalidEmail>());
        final error = r.validation! as InvalidEmail;
        expect(error.value, 'john@example.com');
      });
      test('allowUtf8LocalPart false', () async {
        final r = await v.isEmail(allowUtf8LocalPart: false)('test@example.com');
        expect(r.validation, isNull);
        expect(r.transformed, 'test@example.com');
      });
      test('allowIpDomain', () async {
        final r = await v.isEmail(allowIpDomain: true)('test@[192.168.1.1]');
        expect(r.validation, isNull);
        expect(r.transformed, 'test@[192.168.1.1]');
      });
      test('hostBlacklist', () async {
        final r = await v.isEmail(hostBlacklist: ['blocked.com'])('test@blocked.com');
        expect(r.validation, isA<InvalidEmail>());
        final error = r.validation! as InvalidEmail;
        expect(error.value, 'test@blocked.com');
      });
      test('hostWhitelist', () async {
        final r = await v.isEmail(hostWhitelist: ['allowed.com'])('test@other.com');
        expect(r.validation, isA<InvalidEmail>());
        final error = r.validation! as InvalidEmail;
        expect(error.value, 'test@other.com');
      });
      test('blacklistedChars', () async {
        final r = await v.isEmail(blacklistedChars: '!')('test!@example.com');
        expect(r.validation, isA<InvalidEmail>());
        final error = r.validation! as InvalidEmail;
        expect(error.value, 'test!@example.com');
      });
    });

    test('isEmail localPart too long', () async {
      final longLocal = 'a' * 65;
      final email = '$longLocal@example.com';
      final r = await v.isEmail()(email);
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, email);
    });

    test('isEmail consecutive dots', () async {
      final r = await v.isEmail()('test..test@example.com');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'test..test@example.com');
    });

    test('isEmail starts with dot', () async {
      final r = await v.isEmail()('.test@example.com');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, '.test@example.com');
    });

    test('isEmail ends with dot', () async {
      final r = await v.isEmail()('test.@example.com');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'test.@example.com');
    });

    test('isEmail ignoreMaxLength', () async {
      final longEmail = '${'a' * 200}@${'b' * 50}.com';
      final r = await v.isEmail(ignoreMaxLength: true)(longEmail);
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, longEmail);
    });

    test('isEmail ignoreMaxLength reaches parse', () async {
      final longEmail = '${'a' * 10}@${'b' * 240}.com';
      final r = await v.isEmail(ignoreMaxLength: true)(longEmail);
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, longEmail);
    });

    test('isEmail requireDisplayName with displayName', () async {
      final r = await v.isEmail(requireDisplayName: true)('John <john@example.com>');
      expect(r.validation, isNull);
      expect(r.transformed, 'John <john@example.com>');
    });

    test('isEmail allowUtf8LocalPart false rejects utf8', () async {
      final r = await v.isEmail(allowUtf8LocalPart: false)('testé@example.com');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'testé@example.com');
    });

    test('isEmail hostBlacklist with RegExp', () async {
      final r = await v.isEmail(hostBlacklist: [RegExp(r'example\.com$')])('test@example.com');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'test@example.com');
    });

    test('isEmail hostWhitelist with RegExp', () async {
      final r = await v.isEmail(hostWhitelist: [RegExp(r'\.com$')])('test@example.org');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'test@example.org');
    });

    test('isEmail domain single part', () async {
      final r = await v.isEmail()('test@com');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'test@com');
    });

    test('isEmail TLD too short', () async {
      final r = await v.isEmail()('test@example.x');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'test@example.x');
    });

    test('isEmail part too long', () async {
      final longLocal = 'test@${'a' * 64}.com';
      final r = await v.isEmail()(longLocal);
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, longLocal);
    });

    test('isEmail hyphen at start of part', () async {
      final r = await v.isEmail()('test@-example.com');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'test@-example.com');
    });

    test('isEmail hyphen at end of part', () async {
      final r = await v.isEmail()('test@example-.com');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'test@example-.com');
    });

    test('isEmail allowIpDomain with IPv6', () async {
      final r = await v.isEmail(allowIpDomain: true)('test@[2001:db8::1]');
      expect(r.validation, isNull);
      expect(r.transformed, 'test@[2001:db8::1]');
    });

    test('isEmail domain with space', () async {
      final r = await v.isEmail()('test@exa mple.com');
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, 'test@exa mple.com');
    });

    test('isEmail too long > 254', () async {
      final longEmail = '${'a' * 250}@b.com';
      final r = await v.isEmail()(longEmail);
      expect(r.validation, isA<InvalidEmail>());
      final error = r.validation! as InvalidEmail;
      expect(error.value, longEmail);
    });
  });
}
