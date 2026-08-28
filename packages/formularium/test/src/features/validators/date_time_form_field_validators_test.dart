import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/date_time_validation.dart';
import 'package:formularium/features/validators/_enums/input_date_format.dart';
import 'package:formularium/features/validators/_validators/date_time_form_field_validators.dart';

void main() {
  final v = DateTimeFormFieldValidators.instance;

  group('DateTimeFormFieldValidators', () {
    group('after', () {
      final ref = DateTime(2024, 6, 15);

      test('should return valid when value is after reference', () async {
        final r = await v.after(ref)(DateTime(2024, 7));
        expect(r.validation, isNull);
        expect(r.transformed, DateTime(2024, 7));
      });

      test('should return error when value is before reference', () async {
        final r = await v.after(ref)(DateTime(2024, 5));
        expect(r.validation, isA<DateAfter>());
        final error = r.validation! as DateAfter;
        expect(error.reference, ref);
        expect(r.transformed, ref);
      });

      test('should return error when value equals reference', () async {
        final r = await v.after(ref)(ref);
        expect(r.validation, isA<DateAfter>());
        final error = r.validation! as DateAfter;
        expect(error.reference, ref);
      });

      test('inclusive should accept equal value', () async {
        final r = await v.after(ref, inclusive: true)(ref);
        expect(r.validation, isNull);
        expect(r.transformed, ref);
      });

      test('inclusive should reject before', () async {
        final r = await v.after(ref, inclusive: true)(DateTime(2024, 5));
        expect(r.validation, isA<DateAfterInclusive>());
        final error = r.validation! as DateAfterInclusive;
        expect(error.reference, ref);
      });
    });

    group('before', () {
      final ref = DateTime(2024, 6, 15);

      test('should return valid when value is before reference', () async {
        final r = await v.before(ref)(DateTime(2024, 5));
        expect(r.validation, isNull);
        expect(r.transformed, DateTime(2024, 5));
      });

      test('should return error when value is after reference', () async {
        final r = await v.before(ref)(DateTime(2024, 7));
        expect(r.validation, isA<DateBefore>());
        final error = r.validation! as DateBefore;
        expect(error.reference, ref);
        expect(r.transformed, ref);
      });

      test('inclusive should accept equal value', () async {
        final r = await v.before(ref, inclusive: true)(ref);
        expect(r.validation, isNull);
        expect(r.transformed, ref);
      });

      test('inclusive should reject after', () async {
        final r = await v.before(ref, inclusive: true)(DateTime(2024, 7));
        expect(r.validation, isA<DateBeforeInclusive>());
        final error = r.validation! as DateBeforeInclusive;
        expect(error.reference, ref);
      });
    });

    group('isDate', () {
      test('should parse valid date string', () async {
        final r = await v.isDate(format: InputDateFormat.ddMMyyyy)('15/06/2024');
        expect(r.validation, isNull);
        expect(r.transformed, isA<DateTime>());
      });

      test('should return invalid for invalid date string', () async {
        final r = await v.isDate(format: InputDateFormat.ddMMyyyy)('not-a-date');
        expect(r.validation, isA<DateInvalid>());
        expect(r.transformed, isA<DateTime>());
      });
    });

    group('isISO8601', () {
      test('should parse valid ISO8601', () async {
        final r = await v.isISO8601()('2024-06-15T10:30:00Z');
        expect(r.validation, isNull);
        expect(r.transformed, DateTime.utc(2024, 6, 15, 10, 30));
      });

      test('should parse valid ISO8601 without time', () async {
        final r = await v.isISO8601()('2024-06-15');
        expect(r.validation, isNull);
        expect(r.transformed, DateTime(2024, 6, 15));
      });

      test('should reject invalid string', () async {
        final r = await v.isISO8601()('not-a-date');
        expect(r.validation, isA<DateInvalid>());
      });

      test('strict should reject invalid date', () async {
        final r = await v.isISO8601(strict: true)('2024-13-01');
        expect(r.validation, isA<DateInvalid>());
      });

      test('strict should accept valid date', () async {
        final r = await v.isISO8601(strict: true)('2024-06-15');
        expect(r.validation, isNull);
        expect(r.transformed, DateTime(2024, 6, 15));
      });

      test('leap year strict should accept Feb 29', () async {
        final r = await v.isISO8601(strict: true)('2024-02-29');
        expect(r.validation, isNull);
        expect(r.transformed, DateTime(2024, 2, 29));
      });

      test('non-leap year strict should reject Feb 29', () async {
        final r = await v.isISO8601(strict: true)('2023-02-29');
        expect(r.validation, isA<DateInvalid>());
      });

      test('non-strict should reject via _isValidDate when parse fails', () async {
        final r = await v.isISO8601()('');
        expect(r.validation, isA<DateInvalid>());
      });

      test('strictSeparator should reject space separator', () async {
        final r = await v.isISO8601(strictSeparator: true)('2024-06-15 10:30:00');
        expect(r.validation, isA<DateInvalid>());
      });
    });

    group('isRFC3339', () {
      test('should parse valid RFC3339', () async {
        final r = await v.isRFC3339()('2024-06-15T10:30:00Z');
        expect(r.validation, isNull);
        expect(r.transformed, DateTime.utc(2024, 6, 15, 10, 30));
      });

      test('should reject space separator', () async {
        final r = await v.isRFC3339()('2024-06-15 10:30:00');
        expect(r.validation, isA<DateInvalid>());
      });

      test('should reject invalid month', () async {
        final r = await v.isRFC3339()('2024-13-01T00:00:00Z');
        expect(r.validation, isA<DateInvalid>());
      });
    });

    group('isTime', () {
      test('hour24 default_ valid', () async {
        final r = await v.isTime()('14:30');
        expect(r.validation, isNull);
        expect(r.transformed.hour, 14);
        expect(r.transformed.minute, 30);
      });

      test('hour24 default_ invalid', () async {
        final r = await v.isTime()('25:00');
        expect(r.validation, isA<InvalidTime>());
        final error = r.validation! as InvalidTime;
        expect(error.value, '25:00');
        expect(error.hourFormat, 'hour24');
        expect(error.mode, 'default_');
      });

      test('hour24 withSeconds valid', () async {
        final r = await v.isTime(mode: TimeMode.withSeconds)('14:30:45');
        expect(r.validation, isNull);
        expect(r.transformed.second, 45);
      });

      test('hour24 withOptionalSeconds valid without seconds', () async {
        final r = await v.isTime(mode: TimeMode.withOptionalSeconds)('14:30');
        expect(r.validation, isNull);
        expect(r.transformed.second, isNull);
      });

      test('hour24 withOptionalSeconds valid with seconds', () async {
        final r = await v.isTime(mode: TimeMode.withOptionalSeconds)('14:30:45');
        expect(r.validation, isNull);
        expect(r.transformed.second, 45);
      });

      test('hour12 default_ valid with AM', () async {
        final r = await v.isTime(hourFormat: HourFormat.hour12)('02:30 PM');
        expect(r.validation, isNull);
        expect(r.transformed.hour, 2);
        expect(r.transformed.minute, 30);
      });

      test('hour12 default_ invalid', () async {
        final r = await v.isTime(hourFormat: HourFormat.hour12)('25:00');
        expect(r.validation, isA<InvalidTime>());
        final error = r.validation! as InvalidTime;
        expect(error.value, '25:00');
        expect(error.hourFormat, 'hour12');
        expect(error.mode, 'default_');
      });

      test('hour12 withSeconds valid', () async {
        final r = await v.isTime(hourFormat: HourFormat.hour12, mode: TimeMode.withSeconds)('02:30:45 PM');
        expect(r.validation, isNull);
        expect(r.transformed.second, 45);
      });

      test('hour12 withOptionalSeconds valid with seconds', () async {
        final r = await v.isTime(hourFormat: HourFormat.hour12, mode: TimeMode.withOptionalSeconds)('02:30:45 AM');
        expect(r.validation, isNull);
        expect(r.transformed.second, 45);
      });

      test('hour12 withOptionalSeconds valid without seconds', () async {
        final r = await v.isTime(hourFormat: HourFormat.hour12, mode: TimeMode.withOptionalSeconds)('02:30 AM');
        expect(r.validation, isNull);
        expect(r.transformed.second, isNull);
      });

      test('hour12 PM valid with seconds', () async {
        final r = await v.isTime(hourFormat: HourFormat.hour12, mode: TimeMode.withSeconds)('02:30:45 PM');
        expect(r.validation, isNull);
        expect(r.transformed.hour, 2);
        expect(r.transformed.minute, 30);
        expect(r.transformed.second, 45);
      });

      test('hour12 AM valid', () async {
        final r = await v.isTime(hourFormat: HourFormat.hour12)('02:30 AM');
        expect(r.validation, isNull);
        expect(r.transformed.hour, 2);
        expect(r.transformed.minute, 30);
      });

      test('hour24 withSeconds invalid seconds > 59', () async {
        final r = await v.isTime(mode: TimeMode.withSeconds)('14:30:60');
        expect(r.validation, isA<InvalidTime>());
        final error = r.validation! as InvalidTime;
        expect(error.value, '14:30:60');
        expect(error.hourFormat, 'hour24');
        expect(error.mode, 'withSeconds');
      });

      test('hour24 withSeconds invalid minutes > 59', () async {
        final r = await v.isTime(mode: TimeMode.withSeconds)('14:61:00');
        expect(r.validation, isA<InvalidTime>());
        final error = r.validation! as InvalidTime;
        expect(error.value, '14:61:00');
        expect(error.hourFormat, 'hour24');
        expect(error.mode, 'withSeconds');
      });

      test('hour12 withSeconds invalid seconds > 59', () async {
        final r = await v.isTime(hourFormat: HourFormat.hour12, mode: TimeMode.withSeconds)('02:30:60 PM');
        expect(r.validation, isA<InvalidTime>());
        final error = r.validation! as InvalidTime;
        expect(error.value, '02:30:60 PM');
        expect(error.hourFormat, 'hour12');
        expect(error.mode, 'withSeconds');
      });

      test('hour12 upper case AM/PM variants', () async {
        final r1 = await v.isTime(hourFormat: HourFormat.hour12)('02:30 am');
        expect(r1.validation, isNull);
        expect(r1.transformed.hour, 2);
        expect(r1.transformed.minute, 30);
        final r2 = await v.isTime(hourFormat: HourFormat.hour12)('02:30 pm');
        expect(r2.validation, isNull);
        expect(r2.transformed.hour, 2);
        expect(r2.transformed.minute, 30);
      });

      test('hour24 leading zero required', () async {
        final r = await v.isTime()('2:30');
        expect(r.validation, isA<InvalidTime>());
        final error = r.validation! as InvalidTime;
        expect(error.value, '2:30');
        expect(error.hourFormat, 'hour24');
        expect(error.mode, 'default_');
      });
    });
  });
}
