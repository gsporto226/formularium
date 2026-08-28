import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Network', () {
    group('isURL', () {
      test('valid', () async {
        final r = await v.isURL()('https://example.com');
        expect(r.validation, isNull);
        expect(r.transformed, isA<Uri>());
      });
      test('requireProtocol missing', () async {
        final r = await v.isURL(requireProtocol: true)('example.com');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'example.com');
      });
      test('requirePort', () async {
        final r = await v.isURL(requirePort: true, protocols: ['unknown'])('unknown://example.com');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'unknown://example.com');
      });
      test('disallowAuth', () async {
        final r = await v.isURL(disallowAuth: true)('https://user:pass@example.com');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'https://user:pass@example.com');
      });
      test('disallowFragments', () async {
        final r = await v.isURL(allowFragments: false)('https://example.com#section');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'https://example.com#section');
      });
      test('disallowQueryComponents', () async {
        final r = await v.isURL(allowQueryComponents: false)('https://example.com?q=1');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'https://example.com?q=1');
      });
      test('hostBlacklist', () async {
        final r = await v.isURL(hostBlacklist: ['blocked.com'])('https://blocked.com');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'https://blocked.com');
      });
      test('hostWhitelist', () async {
        final r = await v.isURL(hostWhitelist: ['allowed.com'])('https://other.com');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'https://other.com');
      });
      test('exceeds max length', () async {
        final r = await v.isURL(maxAllowedLength: 20)('https://very-long-url.example.com');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'https://very-long-url.example.com');
      });
      test('invalid scheme', () async {
        final r = await v.isURL(protocols: ['https'])('http://example.com');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'http://example.com');
      });
      test('requires host', () async {
        final r = await v.isURL(requireProtocol: true)('ftp://');
        expect(r.validation, isA<InvalidUrl>());
        final error = r.validation! as InvalidUrl;
        expect(error.value, 'ftp://');
      });
      test('protocolRelativeUrls', () async {
        final r = await v.isURL(allowProtocolRelativeUrls: true)('//example.com');
        expect(r.validation, isNull);
        expect(r.transformed, isA<Uri>());
      });
    });

    group('isIP', () {
      test('valid v4', () async {
        final r = await v.isIP()('192.168.1.1');
        expect(r.validation, isNull);
        expect(r.transformed, '192.168.1.1');
      });
      test('valid v6 loopback', () async {
        final r = await v.isIP()('::1');
        expect(r.validation, isNull);
        expect(r.transformed, '::1');
      });
      test('valid v6 address', () async {
        final r = await v.isIP()('2001:db8::1');
        expect(r.validation, isNull);
        expect(r.transformed, '2001:db8::1');
      });
      test('version 4 only valid', () async {
        final r = await v.isIP(version: 4)('8.8.8.8');
        expect(r.validation, isNull);
        expect(r.transformed, '8.8.8.8');
      });
      test('version 4 only rejects v6', () async {
        final r = await v.isIP(version: 4)('::1');
        expect(r.validation, isA<InvalidIp>());
        final error = r.validation! as InvalidIp;
        expect(error.value, '::1');
      });
      test('version 6 only valid', () async {
        final r = await v.isIP(version: 6)('::1');
        expect(r.validation, isNull);
        expect(r.transformed, '::1');
      });
      test('version 6 only rejects v4', () async {
        final r = await v.isIP(version: 6)('192.168.1.1');
        expect(r.validation, isA<InvalidIp>());
        final error = r.validation! as InvalidIp;
        expect(error.value, '192.168.1.1');
      });
      test('invalid octets', () async {
        final r = await v.isIP()('999.999.999.999');
        expect(r.validation, isA<InvalidIp>());
        final error = r.validation! as InvalidIp;
        expect(error.value, '999.999.999.999');
      });
      test('invalid format', () async {
        final r = await v.isIP()('not-an-ip');
        expect(r.validation, isA<InvalidIp>());
        final error = r.validation! as InvalidIp;
        expect(error.value, 'not-an-ip');
      });
    });

    group('isMACAddress', () {
      test('valid colon', () async {
        final r = await v.isMACAddress()('00:1A:2B:3C:4D:5E');
        expect(r.validation, isNull);
        expect(r.transformed, '00:1A:2B:3C:4D:5E');
      });
      test('valid hyphen', () async {
        final r = await v.isMACAddress()('00-1A-2B-3C-4D-5E');
        expect(r.validation, isNull);
        expect(r.transformed, '00-1A-2B-3C-4D-5E');
      });
      test('noColons', () async {
        final r = await v.isMACAddress(noColons: true)('001A2B3C4D5E');
        expect(r.validation, isNull);
        expect(r.transformed, '001A2B3C4D5E');
      });
      test('invalid format', () async {
        final r = await v.isMACAddress()('not-mac');
        expect(r.validation, isA<InvalidMacAddress>());
        final error = r.validation! as InvalidMacAddress;
        expect(error.value, 'not-mac');
      });
      test('invalid too long', () async {
        final r = await v.isMACAddress()('00:1A:2B:3C:4D:5E:6F');
        expect(r.validation, isA<InvalidMacAddress>());
        final error = r.validation! as InvalidMacAddress;
        expect(error.value, '00:1A:2B:3C:4D:5E:6F');
      });
    });

    test('isIP invalid version', () async {
      final r = await v.isIP(version: 7)('192.168.1.1');
      expect(r.validation, isA<InvalidIp>());
      final error = r.validation! as InvalidIp;
      expect(error.value, '192.168.1.1');
    });

    test('isURL no scheme unparseable', () async {
      final r = await v.isURL()('???');
      expect(r.validation, isA<InvalidUrl>());
      final error = r.validation! as InvalidUrl;
      expect(error.value, '???');
    });
  });
}
