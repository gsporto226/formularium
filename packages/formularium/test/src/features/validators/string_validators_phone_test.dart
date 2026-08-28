import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_phone_validator.dart' show phoneLocales;
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Phone', () {
    group('isMobilePhone', () {
      // Representative sample from all major regions
      final phoneFixtures = <String, List<String>>{
        'pt-BR': ['+5511999999999', '11999999999'],
        'en-US': ['+14155552671', '(415) 555-2671'],
        'en-GB': ['+447911123456'],
        'de-DE': ['+4915123456789'],
        'fr-FR': ['+33612345678'],
        'es-ES': ['+34612345678'],
        'it-IT': ['+393331234567'],
        'ja-JP': ['+819012345678'],
        'zh-CN': ['+8613912345678'],
        'ko-KR': ['+821012345678'],
        'ru-RU': ['+79123456789'],
        'ar-SA': ['+966512345678'],
        'en-IN': ['+919876543210'],
        'en-AU': ['+61412345678'],
        'en-ZA': ['+27821234567'],
        'es-MX': ['+5215512345678'],
        'es-AR': ['+5491123456789'],
        'nl-NL': ['+31612345678'],
        'en-NG': ['+2348123456789'],
      };

      for (final entry in phoneFixtures.entries) {
        final locale = entry.key;
        group(locale, () {
          for (final valid in entry.value) {
            test('valid: $valid', () async {
              final r = await v.isMobilePhone(locale: locale)(valid);
              expect(r.validation, isNull);
              expect(r.transformed, valid);
            });
          }
        });
      }

      test('invalid pt-BR', () async {
        final r = await v.isMobilePhone(locale: 'pt-BR')('123');
        expect(r.validation, isA<InvalidPhone>());
        final error = r.validation! as InvalidPhone;
        expect(error.value, '123');
      });
      test('invalid en-US', () async {
        final r = await v.isMobilePhone(locale: 'en-US')('notaphone');
        expect(r.validation, isA<InvalidPhone>());
        final error = r.validation! as InvalidPhone;
        expect(error.value, 'notaphone');
      });

      test('strictMode requires +', () async {
        final r = await v.isMobilePhone(locale: 'pt-BR', strictMode: true)('11999999999');
        expect(r.validation, isA<InvalidPhone>());
        final error = r.validation! as InvalidPhone;
        expect(error.value, '11999999999');
      });

      test('locales list matches first', () async {
        final r = await v.isMobilePhone(locales: ['pt-BR', 'en-US'])('+5511999999999');
        expect(r.validation, isNull);
        expect(r.transformed, '+5511999999999');
      });

      test('locales list no match', () async {
        final r = await v.isMobilePhone(locales: ['fr-FR', 'de-DE'])('123');
        expect(r.validation, isA<InvalidPhone>());
        final error = r.validation! as InvalidPhone;
        expect(error.value, '123');
      });

      test('unknown locale rejects', () async {
        final r = await v.isMobilePhone(locale: 'xx-XX')('12345');
        expect(r.validation, isA<InvalidPhone>());
        final error = r.validation! as InvalidPhone;
        expect(error.value, '12345');
      });

      test('any locale matches known pattern', () async {
        final r = await v.isMobilePhone()('+5511999999999');
        expect(r.validation, isNull);
        expect(r.transformed, '+5511999999999');
      });

      test('any locale no match', () async {
        final r = await v.isMobilePhone()('!!!');
        expect(r.validation, isA<InvalidPhone>());
        final error = r.validation! as InvalidPhone;
        expect(error.value, '!!!');
      });

      test('strictMode with locale list rejects without +', () async {
        final r = await v.isMobilePhone(locales: ['pt-BR'], strictMode: true)('11999999999');
        expect(r.validation, isA<InvalidPhone>());
        final error = r.validation! as InvalidPhone;
        expect(error.value, '11999999999');
      });
    });

    test('phoneLocales returns locale keys with minimum count', () async {
      expect(phoneLocales, contains('pt-BR'));
      expect(phoneLocales, contains('en-US'));
      expect(phoneLocales.length, greaterThan(150));
    });
  });
}
