import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Transformations', () {
    group('escape', () {
      test('escapes HTML', () async {
        expect((await v.escape()('<script>')).transformed, '&lt;script&gt;');
        expect((await v.escape()('a&b')).transformed, 'a&amp;b');
      });
      test('plain text unchanged', () async {
        expect((await v.escape()('hello')).transformed, 'hello');
      });
    });

    group('unescape', () {
      test('unescapes HTML', () async {
        expect((await v.unescape()('&lt;script&gt;')).transformed, '<script>');
        expect((await v.unescape()('a&amp;b')).transformed, 'a&b');
      });
      test('numeric entities', () async {
        expect((await v.unescape()('&#x27;')).transformed, "'");
        expect((await v.unescape()('&#60;')).transformed, '<');
      });
      test('plain text unchanged', () async {
        expect((await v.unescape()('hello')).transformed, 'hello');
      });
    });

    group('stripLow', () {
      test('removes control chars', () async {
        expect((await v.stripLow()('a\x00b\x01c')).transformed, 'abc');
      });
      test('keeps newlines when flag set', () async {
        expect((await v.stripLow(keepNewLines: true)('a\nb\x00c')).transformed, 'a\nbc');
      });
      test('normal text unchanged', () async {
        expect((await v.stripLow()('hello world')).transformed, 'hello world');
      });
    });

    group('whitelist', () {
      test('keeps whitelisted chars', () async {
        expect((await v.whitelist('abc')('abc123')).transformed, 'abc');
      });
      test('empty result', () async {
        expect((await v.whitelist('abc')('123')).transformed, '');
      });
    });

    group('blacklist', () {
      test('removes blacklisted chars', () async {
        expect((await v.blacklist('abc')('abc123')).transformed, '123');
      });
      test('unchanged when no match', () async {
        expect((await v.blacklist('abc')('123')).transformed, '123');
      });
    });
  });
}
