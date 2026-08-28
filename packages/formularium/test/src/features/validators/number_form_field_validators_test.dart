import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/number_validation.dart';
import 'package:formularium/features/validators/_validators/number_form_field_validators.dart';

void main() {
  final v = NumberFormFieldValidators.instance;

  group('NumberFormFieldValidators', () {
    group('max', () {
      test('should return valid when value <= max', () async {
        final r = await v.max(100)(50);
        expect(r.validation, isNull);
        expect(r.transformed, 50);
      });

      test('should return clamped value with error when value > max', () async {
        final r = await v.max(100)(150);
        expect(r.validation, isA<NumberTooBig>());
        final error = r.validation! as NumberTooBig;
        expect(error.maxValue, 100);
        expect(r.transformed, 100);
      });
    });

    group('min', () {
      test('should return valid when value >= min', () async {
        final r = await v.min(10)(20);
        expect(r.validation, isNull);
        expect(r.transformed, 20);
      });

      test('should return clamped value with error when value < min', () async {
        final r = await v.min(10)(5);
        expect(r.validation, isA<NumberTooSmall>());
        final error = r.validation! as NumberTooSmall;
        expect(error.minValue, 10);
        expect(r.transformed, 10);
      });
    });

    group('greaterThan', () {
      test('should return valid when value > threshold', () async {
        final r = await v.greaterThan(10)(20);
        expect(r.validation, isNull);
        expect(r.transformed, 20);
      });

      test('should return min value error when value <= threshold', () async {
        final r = await v.greaterThan(10)(5);
        expect(r.validation, isA<NumberTooSmall>());
        final error = r.validation! as NumberTooSmall;
        expect(error.minValue, 10);
        expect(r.transformed, 5);
      });
    });

    group('lessThan', () {
      test('should return valid when value < threshold', () async {
        final r = await v.lessThan(10)(5);
        expect(r.validation, isNull);
        expect(r.transformed, 5);
      });

      test('should return max value error when value >= threshold', () async {
        final r = await v.lessThan(10)(15);
        expect(r.validation, isA<NumberTooBig>());
        final error = r.validation! as NumberTooBig;
        expect(error.maxValue, 10);
        expect(r.transformed, 15);
      });
    });

    group('range', () {
      test('should return valid when value in range', () async {
        final r = await v.range(10, 100)(50);
        expect(r.validation, isNull);
        expect(r.transformed, 50);
      });

      test('should return min error when value < min', () async {
        final r = await v.range(10, 100)(5);
        expect(r.validation, isA<NumberTooSmall>());
        final error = r.validation! as NumberTooSmall;
        expect(error.minValue, 10);
        expect(r.transformed, 10);
      });

      test('should return max error when value > max', () async {
        final r = await v.range(10, 100)(150);
        expect(r.validation, isA<NumberTooBig>());
        final error = r.validation! as NumberTooBig;
        expect(error.maxValue, 100);
        expect(r.transformed, 100);
      });
    });

    group('divisibleBy', () {
      test('should return valid when divisible', () async {
        final r = await v.divisibleBy(3)(9);
        expect(r.validation, isNull);
        expect(r.transformed, 9);
      });

      test('should return NotDivisible when not divisible', () async {
        final r = await v.divisibleBy(3)(10);
        expect(r.validation, isA<NotDivisible>());
        final error = r.validation! as NotDivisible;
        expect(error.divisor, 3);
        expect(r.transformed, 10);
      });
    });

    group('positive', () {
      test('should return valid when positive', () async {
        final r = await v.positive()(5);
        expect(r.validation, isNull);
        expect(r.transformed, 5);
      });

      test('should return error when not positive', () async {
        final r = await v.positive()(0);
        expect(r.validation, isA<NumberTooSmall>());
        final error = r.validation! as NumberTooSmall;
        expect(error.minValue, 0);
      });
    });

    group('negative', () {
      test('should return valid when negative', () async {
        final r = await v.negative()(-5);
        expect(r.validation, isNull);
        expect(r.transformed, -5);
      });

      test('should return error when not negative', () async {
        final r = await v.negative()(0);
        expect(r.validation, isA<NumberTooBig>());
        final error = r.validation! as NumberTooBig;
        expect(error.maxValue, 0);
      });
    });
  });
}
