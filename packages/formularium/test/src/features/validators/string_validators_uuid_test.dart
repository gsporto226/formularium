import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - UUID', () {
    group('isUUID', () {
      test('valid v4', () async {
        final r = await v.isUUID()('550e8400-e29b-41d4-a716-446655440000');
        expect(r.validation, isNull);
        expect(r.transformed, '550e8400-e29b-41d4-a716-446655440000');
      });

      test('invalid', () async {
        final r = await v.isUUID()('xyz');
        expect(r.validation, isA<InvalidUuid>());
        final error = r.validation! as InvalidUuid;
        expect(error.version, isNull);
      });
    });

    test('isUUID v4 valid', () async {
      final r = await v.isUUID(version: '4')('550e8400-e29b-41d4-a716-446655440000');
      expect(r.validation, isNull);
      expect(r.transformed, '550e8400-e29b-41d4-a716-446655440000');
    });

    test('isUUID nil', () async {
      final r = await v.isUUID(version: 'nil')('00000000-0000-0000-0000-000000000000');
      expect(r.validation, isNull);
      expect(r.transformed, '00000000-0000-0000-0000-000000000000');
    });

    test('isUUID max', () async {
      final r = await v.isUUID(version: 'max')('ffffffff-ffff-ffff-ffff-ffffffffffff');
      expect(r.validation, isNull);
      expect(r.transformed, 'ffffffff-ffff-ffff-ffff-ffffffffffff');
    });

    test('isUUID v1', () async {
      final r = await v.isUUID(version: '1')('b691c99c-7fc5-11e8-adc0-fa7ae01bbebc');
      expect(r.validation, isNull);
      expect(r.transformed, 'b691c99c-7fc5-11e8-adc0-fa7ae01bbebc');
    });

    test('isUUID v2', () async {
      final r = await v.isUUID(version: '2')('b691c99c-7fc5-21e8-adc0-fa7ae01bbebc');
      expect(r.validation, isNull);
      expect(r.transformed, 'b691c99c-7fc5-21e8-adc0-fa7ae01bbebc');
    });

    test('isUUID v3', () async {
      final r = await v.isUUID(version: '3')('b691c99c-7fc5-31e8-adc0-fa7ae01bbebc');
      expect(r.validation, isNull);
      expect(r.transformed, 'b691c99c-7fc5-31e8-adc0-fa7ae01bbebc');
    });

    test('isUUID v5', () async {
      final r = await v.isUUID(version: '5')('b691c99c-7fc5-51e8-adc0-fa7ae01bbebc');
      expect(r.validation, isNull);
      expect(r.transformed, 'b691c99c-7fc5-51e8-adc0-fa7ae01bbebc');
    });

    test('isUUID version mismatch', () async {
      final r = await v.isUUID(version: '4')('b691c99c-7fc5-11e8-adc0-fa7ae01bbebc');
      expect(r.validation, isA<InvalidUuid>());
      final error = r.validation! as InvalidUuid;
      expect(error.version, '4');
    });

    test('isUUID loose', () async {
      final r = await v.isUUID(version: 'loose')('abc123');
      expect(r.validation, isNull);
      expect(r.transformed, 'abc123');
    });

    test('isUUID v6', () async {
      final r = await v.isUUID(version: '6')('b691c99c-7fc5-61e8-adc0-fa7ae01bbebc');
      expect(r.validation, isNull);
      expect(r.transformed, 'b691c99c-7fc5-61e8-adc0-fa7ae01bbebc');
    });

    test('isUUID v7', () async {
      final r = await v.isUUID(version: '7')('b691c99c-7fc5-71e8-adc0-fa7ae01bbebc');
      expect(r.validation, isNull);
      expect(r.transformed, 'b691c99c-7fc5-71e8-adc0-fa7ae01bbebc');
    });

    test('isUUID v8', () async {
      final r = await v.isUUID(version: '8')('b691c99c-7fc5-81e8-adc0-fa7ae01bbebc');
      expect(r.validation, isNull);
      expect(r.transformed, 'b691c99c-7fc5-81e8-adc0-fa7ae01bbebc');
    });
  });
}
