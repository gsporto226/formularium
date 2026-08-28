import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockL10n l10n;

  setUp(() {
    l10n = MockL10n();
    addTearDown(resetF10n);
    mockL10n(l10n);
  });

  group('NotABoolean', () {
    test('localize', () async {
      when(() => l10n.validation_not_a_boolean('abc')).thenReturn('não booleano');
      final result = NotABoolean('abc').localize();
      expect(result, 'não booleano');
      verify(() => l10n.validation_not_a_boolean('abc')).called(1);
    });
  });

  group('InvalidPort', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_port('99999')).thenReturn('porta inválida');
      final result = InvalidPort('99999').localize();
      expect(result, 'porta inválida');
      verify(() => l10n.validation_invalid_port('99999')).called(1);
    });
  });

  group('InvalidUrl', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_url('bad')).thenReturn('URL inválida');
      final result = InvalidUrl('bad').localize();
      expect(result, 'URL inválida');
      verify(() => l10n.validation_invalid_url('bad')).called(1);
    });
  });

  group('InvalidLatLong', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_lat_long('0,0')).thenReturn('coordenada inválida');
      final result = InvalidLatLong('0,0').localize();
      expect(result, 'coordenada inválida');
      verify(() => l10n.validation_invalid_lat_long('0,0')).called(1);
    });
  });

  group('InvalidEmail', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_email('a')).thenReturn('email inválido');
      final result = InvalidEmail('a').localize();
      expect(result, 'email inválido');
      verify(() => l10n.validation_invalid_email('a')).called(1);
    });
  });

  group('InvalidUuid', () {
    test('localize with version', () async {
      when(() => l10n.validation_invalid_uuid('4')).thenReturn('UUID inválido');
      final result = InvalidUuid('4').localize();
      expect(result, 'UUID inválido');
      verify(() => l10n.validation_invalid_uuid('4')).called(1);
    });
    test('localize without version', () async {
      when(() => l10n.validation_invalid_uuid(null)).thenReturn('UUID inválido');
      final result = InvalidUuid(null).localize();
      expect(result, 'UUID inválido');
      verify(() => l10n.validation_invalid_uuid(null)).called(1);
    });
  });

  group('InvalidSemVer', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_semver('a.b.c')).thenReturn('semver inválido');
      final result = InvalidSemVer('a.b.c').localize();
      expect(result, 'semver inválido');
      verify(() => l10n.validation_invalid_semver('a.b.c')).called(1);
    });
  });

  group('InvalidJwt', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_jwt('xxx')).thenReturn('JWT inválido');
      final result = InvalidJwt('xxx').localize();
      expect(result, 'JWT inválido');
      verify(() => l10n.validation_invalid_jwt('xxx')).called(1);
    });
  });

  group('InvalidSlug', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_slug('A B')).thenReturn('slug inválido');
      final result = InvalidSlug('A B').localize();
      expect(result, 'slug inválido');
      verify(() => l10n.validation_invalid_slug('A B')).called(1);
    });
  });

  group('NotBase64', () {
    test('localize', () async {
      when(() => l10n.validation_not_base64('!!!')).thenReturn('não é base64');
      final result = NotBase64('!!!').localize();
      expect(result, 'não é base64');
      verify(() => l10n.validation_not_base64('!!!')).called(1);
    });
  });

  group('InvalidMimeType', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_mime_type('x/y')).thenReturn('mime inválido');
      final result = InvalidMimeType('x/y').localize();
      expect(result, 'mime inválido');
      verify(() => l10n.validation_invalid_mime_type('x/y')).called(1);
    });
  });

  group('InvalidLocale', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_locale('xyz')).thenReturn('locale inválido');
      final result = InvalidLocale('xyz').localize();
      expect(result, 'locale inválido');
      verify(() => l10n.validation_invalid_locale('xyz')).called(1);
    });
  });

  group('InvalidCreditCard', () {
    test('localize with provider', () async {
      when(() => l10n.validation_invalid_credit_card('visa')).thenReturn('cartão inválido');
      final result = InvalidCreditCard('visa').localize();
      expect(result, 'cartão inválido');
      verify(() => l10n.validation_invalid_credit_card('visa')).called(1);
    });
    test('localize without provider', () async {
      when(() => l10n.validation_invalid_credit_card(null)).thenReturn('cartão inválido');
      final result = InvalidCreditCard(null).localize();
      expect(result, 'cartão inválido');
      verify(() => l10n.validation_invalid_credit_card(null)).called(1);
    });
  });

  group('WeakPassword', () {
    test('localize', () async {
      when(() => l10n.validation_weak_password(10, 50)).thenReturn('senha fraca');
      final result = WeakPassword(
        score: 10,
        minScore: 50,
        minLength: 8,
        hasLength: true,
        hasLowercase: false,
        hasUppercase: true,
        hasNumbers: false,
        hasSymbols: true,
      ).localize();
      expect(result, 'senha fraca');
      verify(() => l10n.validation_weak_password(10, 50)).called(1);
    });
  });

  group('InvalidMongoId', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_mongo_id('abc')).thenReturn('mongo id inválido');
      final result = InvalidMongoId('abc').localize();
      expect(result, 'mongo id inválido');
      verify(() => l10n.validation_invalid_mongo_id('abc')).called(1);
    });
  });

  group('InvalidHash', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_hash('md5')).thenReturn('hash inválido');
      final result = InvalidHash('md5').localize();
      expect(result, 'hash inválido');
      verify(() => l10n.validation_invalid_hash('md5')).called(1);
    });
  });

  group('InvalidImei', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_imei('abc')).thenReturn('IMEI inválido');
      final result = InvalidImei('abc').localize();
      expect(result, 'IMEI inválido');
      verify(() => l10n.validation_invalid_imei('abc')).called(1);
    });
  });

  group('NotAlphanumeric', () {
    test('localize', () async {
      when(() => l10n.validation_not_alphanumeric).thenReturn('não alfanumérico');
      final result = const NotAlphanumeric().localize();
      expect(result, 'não alfanumérico');
      verify(() => l10n.validation_not_alphanumeric).called(1);
    });
  });

  group('NotAlpha', () {
    test('localize', () async {
      when(() => l10n.validation_not_alpha).thenReturn('não alfabético');
      final result = const NotAlpha().localize();
      expect(result, 'não alfabético');
      verify(() => l10n.validation_not_alpha).called(1);
    });
  });

  group('NotAscii', () {
    test('localize', () async {
      when(() => l10n.validation_not_ascii).thenReturn('não ascii');
      final result = const NotAscii().localize();
      expect(result, 'não ascii');
      verify(() => l10n.validation_not_ascii).called(1);
    });
  });

  group('NotNumeric', () {
    test('localize with default', () async {
      when(() => l10n.validation_not_numeric(false)).thenReturn('não numérico');
      final result = NotNumeric(false).localize();
      expect(result, 'não numérico');
      verify(() => l10n.validation_not_numeric(false)).called(1);
    });
    test('localize with noSymbols', () async {
      when(() => l10n.validation_not_numeric(true)).thenReturn('não numérico');
      final result = NotNumeric(true).localize();
      expect(result, 'não numérico');
      verify(() => l10n.validation_not_numeric(true)).called(1);
    });
  });

  group('NotHexadecimal', () {
    test('localize', () async {
      when(() => l10n.validation_not_hexadecimal).thenReturn('não hexadecimal');
      final result = const NotHexadecimal().localize();
      expect(result, 'não hexadecimal');
      verify(() => l10n.validation_not_hexadecimal).called(1);
    });
  });

  group('NotLowercase', () {
    test('localize', () async {
      when(() => l10n.validation_not_lowercase).thenReturn('não minúsculo');
      final result = const NotLowercase().localize();
      expect(result, 'não minúsculo');
      verify(() => l10n.validation_not_lowercase).called(1);
    });
  });

  group('NotUppercase', () {
    test('localize', () async {
      when(() => l10n.validation_not_uppercase).thenReturn('não maiúsculo');
      final result = const NotUppercase().localize();
      expect(result, 'não maiúsculo');
      verify(() => l10n.validation_not_uppercase).called(1);
    });
  });

  group('StringLengthExceeded', () {
    test('localize with both min and max', () async {
      when(() => l10n.validation_string_length_exceeded(2, 10)).thenReturn('tamanho excedido');
      final result = StringLengthExceeded(2, 10).localize();
      expect(result, 'tamanho excedido');
      verify(() => l10n.validation_string_length_exceeded(2, 10)).called(1);
    });
    test('localize with only min', () async {
      when(() => l10n.validation_string_length_exceeded(2, null)).thenReturn('tamanho excedido');
      final result = StringLengthExceeded(2, null).localize();
      expect(result, 'tamanho excedido');
      verify(() => l10n.validation_string_length_exceeded(2, null)).called(1);
    });
  });

  group('StringLengthMismatch', () {
    test('localize', () async {
      when(() => l10n.validation_string_length_mismatch([2, 4])).thenReturn('tamanho incorreto');
      final result = StringLengthMismatch([2, 4]).localize();
      expect(result, 'tamanho incorreto');
      verify(() => l10n.validation_string_length_mismatch([2, 4])).called(1);
    });
  });

  group('PatternMismatch', () {
    test('localize', () async {
      when(() => l10n.validation_pattern_mismatch(r'\d+')).thenReturn('padrão não corresponde');
      final result = PatternMismatch(r'\d+').localize();
      expect(result, 'padrão não corresponde');
      verify(() => l10n.validation_pattern_mismatch(r'\d+')).called(1);
    });
  });

  group('NotInList', () {
    test('localize', () async {
      when(() => l10n.validation_not_in_list).thenReturn('não está na lista');
      final result = const NotInList().localize();
      expect(result, 'não está na lista');
      verify(() => l10n.validation_not_in_list).called(1);
    });
  });

  group('MustContain', () {
    test('localize', () async {
      when(() => l10n.validation_must_contain('abc')).thenReturn('deve conter abc');
      final result = MustContain('abc').localize();
      expect(result, 'deve conter abc');
      verify(() => l10n.validation_must_contain('abc')).called(1);
    });
  });

  group('MustEqual', () {
    test('localize', () async {
      when(() => l10n.validation_must_equal('abc')).thenReturn('deve ser igual a abc');
      final result = MustEqual('abc').localize();
      expect(result, 'deve ser igual a abc');
      verify(() => l10n.validation_must_equal('abc')).called(1);
    });
  });

  group('InvalidPhone', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_phone('abc')).thenReturn('telefone inválido');
      final result = InvalidPhone('abc').localize();
      expect(result, 'telefone inválido');
      verify(() => l10n.validation_invalid_phone('abc')).called(1);
    });
  });

  group('InvalidJson', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_json('{bad}')).thenReturn('json inválido');
      final result = InvalidJson('{bad}').localize();
      expect(result, 'json inválido');
      verify(() => l10n.validation_invalid_json('{bad}')).called(1);
    });
  });

  group('InvalidMacAddress', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_mac_address('xx:xx')).thenReturn('MAC inválido');
      final result = InvalidMacAddress('xx:xx').localize();
      expect(result, 'MAC inválido');
      verify(() => l10n.validation_invalid_mac_address('xx:xx')).called(1);
    });
  });

  group('NotOctal', () {
    test('localize', () async {
      when(() => l10n.validation_not_octal).thenReturn('não octal');
      final result = const NotOctal().localize();
      expect(result, 'não octal');
      verify(() => l10n.validation_not_octal).called(1);
    });
  });

  group('ByteLengthExceeded', () {
    test('localize', () async {
      when(() => l10n.validation_byte_length_exceeded(1, 5)).thenReturn('bytes excedido');
      final result = ByteLengthExceeded(1, 5).localize();
      expect(result, 'bytes excedido');
      verify(() => l10n.validation_byte_length_exceeded(1, 5)).called(1);
    });
  });

  group('NotMultibyte', () {
    test('localize', () async {
      when(() => l10n.validation_not_multibyte).thenReturn('não multibyte');
      final result = const NotMultibyte().localize();
      expect(result, 'não multibyte');
      verify(() => l10n.validation_not_multibyte).called(1);
    });
  });

  group('NotFullWidth', () {
    test('localize', () async {
      when(() => l10n.validation_not_full_width).thenReturn('não full-width');
      final result = const NotFullWidth().localize();
      expect(result, 'não full-width');
      verify(() => l10n.validation_not_full_width).called(1);
    });
  });

  group('NotHalfWidth', () {
    test('localize', () async {
      when(() => l10n.validation_not_half_width).thenReturn('não half-width');
      final result = const NotHalfWidth().localize();
      expect(result, 'não half-width');
      verify(() => l10n.validation_not_half_width).called(1);
    });
  });

  group('NotVariableWidth', () {
    test('localize', () async {
      when(() => l10n.validation_not_variable_width).thenReturn('não variable-width');
      final result = const NotVariableWidth().localize();
      expect(result, 'não variable-width');
      verify(() => l10n.validation_not_variable_width).called(1);
    });
  });

  group('NotSurrogatePair', () {
    test('localize', () async {
      when(() => l10n.validation_not_surrogate_pair).thenReturn('não surrogate pair');
      final result = const NotSurrogatePair().localize();
      expect(result, 'não surrogate pair');
      verify(() => l10n.validation_not_surrogate_pair).called(1);
    });
  });

  group('InvalidIp', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_ip('999.999.999.999')).thenReturn('IP inválido');
      final result = InvalidIp('999.999.999.999').localize();
      expect(result, 'IP inválido');
      verify(() => l10n.validation_invalid_ip('999.999.999.999')).called(1);
    });
  });

  group('InvalidPostalCode', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_postal_code('abc')).thenReturn('CEP inválido');
      final result = InvalidPostalCode('abc').localize();
      expect(result, 'CEP inválido');
      verify(() => l10n.validation_invalid_postal_code('abc')).called(1);
    });
  });

  group('InvalidIsbn', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_isbn('abc')).thenReturn('ISBN inválido');
      final result = InvalidIsbn('abc').localize();
      expect(result, 'ISBN inválido');
      verify(() => l10n.validation_invalid_isbn('abc')).called(1);
    });
  });

  group('InvalidEan', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_ean('abc')).thenReturn('EAN inválido');
      final result = InvalidEan('abc').localize();
      expect(result, 'EAN inválido');
      verify(() => l10n.validation_invalid_ean('abc')).called(1);
    });
  });

  group('InvalidBase32', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_base32('abc')).thenReturn('Base32 inválido');
      final result = InvalidBase32('abc').localize();
      expect(result, 'Base32 inválido');
      verify(() => l10n.validation_invalid_base32('abc')).called(1);
    });
  });

  group('InvalidBase58', () {
    test('localize', () async {
      when(() => l10n.validation_invalid_base58('abc')).thenReturn('Base58 inválido');
      final result = InvalidBase58('abc').localize();
      expect(result, 'Base58 inválido');
      verify(() => l10n.validation_invalid_base58('abc')).called(1);
    });
  });
}
