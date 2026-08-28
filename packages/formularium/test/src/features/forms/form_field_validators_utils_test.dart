import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/forms/_utils/form_field_validators.dart';
import '../../helpers/test_utils.dart';

void main() {
  final validators = FormFieldValidators.instance;

  group('FormFieldValidators', () {
    group('identityValidator', () {
      test('should return input value as transformed', () {
        final validator = validators.identityValidator<String>();
        final result = validator('hello');
        expect(result, isA<Validation<String>>());
        expect((result as Validation).transformed, 'hello');
      });

      test('should work with any type', () {
        final validator = validators.identityValidator<int>();
        final result = validator(42);
        expect(result, isA<Validation<int>>());
        expect((result as Validation).transformed, 42);
      });
    });

    group('multiple', () {
      test('should pass through all valid validators', () {
        final validator = validators.multiple<String, String>(
          validators: [
            (v) => Validation(transformed: '${v}_a', validation: null),
            (v) => Validation(transformed: '${v}_b', validation: null),
          ],
          selector: (values) => values.join('-'),
        );
        final result = validator('x');
        expect(result, isA<Validation<String>>());
        expect((result as Validation).transformed, 'x_a-x_b');
      });

      test('should stop and return first failure', () {
        final validator = validators.multiple<String, String>(
          validators: [
            (_) => Validation(transformed: 'err', validation: TestValidation.reason),
            (_) => Validation(transformed: 'should_not_run', validation: null),
          ],
          selector: (values) => values.join('-'),
        );
        final result = validator('x');
        expect(result, isA<Validation<String>>());
        expect(
          (result as Validation).validation,
          TestValidation.reason,
        );
      });

      test('should collect warnings and return first as failure', () {
        final validator = validators.multiple<String, String>(
          validators: [
            (_) => Validation(transformed: 'warn1', validation: TestValidation.reason),
            (_) => Validation(transformed: 'warn2', validation: TestValidation.other),
          ],
          selector: (values) => values.join('-'),
        );
        final result = validator('x');
        expect(result, isA<Validation<String>>());
        expect(
          (result as Validation).validation,
          TestValidation.reason,
        );
        expect((result as Validation).transformed, 'warn1-warn2');
      });
    });

    group('serial', () {
      test('should chain valid validators', () {
        final validator = validators.serial<String>([
          (v) => Validation(transformed: '${v}_a', validation: null),
          (v) => Validation(transformed: '${v}_b', validation: null),
        ]);
        final result = validator('x');
        expect(result, isA<Validation<String>>());
        expect((result as Validation).transformed, 'x_a_b');
      });

      test('should collect all warnings and return first failure with final transformed', () {
        final validator = validators.serial<String>([
          (v) => Validation(transformed: '${v}_a', validation: TestValidation.reason),
          (_) => Validation(transformed: 'all_validators_run', validation: null),
        ]);
        final result = validator('x');
        expect(result, isA<Validation<String>>());
        expect(
          (result as Validation).validation,
          TestValidation.reason,
        );
        expect((result as Validation).transformed, 'all_validators_run');
      });

      test('should return first warning with accumulated value when all warn', () {
        final validator = validators.serial<String>([
          (v) => Validation(transformed: '${v}_a', validation: TestValidation.reason),
          (v) => Validation(transformed: '${v}_b', validation: TestValidation.other),
        ]);
        final result = validator('x');
        expect(result, isA<Validation<String>>());
        expect(
          (result as Validation).validation,
          TestValidation.reason,
        );
        expect((result as Validation).transformed, 'x_a_b');
      });
    });

    group('chain', () {
      test('should chain two valid validators', () {
        final validator = validators.chain<String, int, String>(
          first: (v) => Validation(transformed: v.length, validation: null),
          second: (v) => Validation(transformed: 'len=$v', validation: null),
        );
        final result = validator('hello');
        expect(result, isA<Validation<String>>());
        expect((result as Validation).transformed, 'len=5');
      });

      test('should return first failure even if second succeeds', () {
        final validator = validators.chain<String, int, String>(
          first: (_) => Validation(transformed: 0, validation: TestValidation.reason),
          second: (v) => Validation(transformed: 'should_wrap', validation: null),
        );
        final result = validator('x');
        expect(result, isA<Validation<String>>());
        expect(
          (result as Validation).validation,
          TestValidation.reason,
        );
        expect((result as Validation).transformed, 'should_wrap');
      });

      test('should return first failure when both fail', () {
        final validator = validators.chain<String, int, String>(
          first: (_) => Validation(transformed: 0, validation: TestValidation.reason),
          second: (_) => Validation(transformed: 'err', validation: TestValidation.other),
        );
        final result = validator('x');
        expect(result, isA<Validation<String>>());
        expect(
          (result as Validation).validation,
          TestValidation.reason,
        );
        expect((result as Validation).transformed, 'err');
      });
    });

    group('chain extension', () {
      test('should chain a validator with another', () {
        final first = validators.identityValidator<String>();
        final second = validators.identityValidator<String>();
        final chained = first.chain(second);
        final result = chained('hello');
        expect(result, isA<Validation<String>>());
        expect((result as Validation).transformed, 'hello');
      });
    });

    group('map', () {
      test('should map input value before validation', () {
        final validator = validators.map<String, String, int, int>(
          validator: (v) => Validation(transformed: v * 2, validation: null),
          valueMapper: (v) => v.length,
        );
        final result = validator('abc');
        expect(result, isA<Validation<int>>());
        expect((result as Validation).transformed, 6);
      });

      test('should propagate failure', () {
        final validator = validators.map<String, String, int, int>(
          validator: (_) => Validation(transformed: 0, validation: TestValidation.reason),
          valueMapper: (v) => v.length,
        );
        final result = validator('abc');
        expect(result, isA<Validation<int>>());
        expect(
          (result as Validation).validation,
          TestValidation.reason,
        );
      });
    });

    group('conditional', () {
      test('should run validator when predicate is true', () {
        final validator = validators.conditional<String, String>(
          validator: (v) => Validation(transformed: '${v}_validated', validation: null),
          predicate: (v) => v.isNotEmpty,
        );
        final result = validator('hello');
        expect(result, isA<Validation<String?>>());
        expect((result as Validation).transformed, 'hello_validated');
      });

      test('should return null valid when predicate is false', () {
        final validator = validators.conditional<String, String>(
          validator: (v) => Validation(transformed: '${v}_validated', validation: null),
          predicate: (v) => v.isNotEmpty,
        );
        final result = validator('');
        expect(result, isA<Validation<dynamic>>());
        expect((result as Validation).transformed, isNull);
      });

      test('should propagate failure when predicate is true and validator fails', () {
        final validator = validators.conditional<String, String>(
          validator: (_) => Validation(transformed: 'fail', validation: TestValidation.reason),
          predicate: (v) => v.isNotEmpty,
        );
        final result = validator('x');
        expect(result, isA<Validation<String>>());
        expect(
          (result as Validation).validation,
          TestValidation.reason,
        );
      });
    });
    group('multiple async', () {
      test('should handle mixed sync and async validators', () async {
        final validator = validators.multiple<String, String>(
          validators: [
            (v) => Validation(transformed: '${v}_sync', validation: null),
            (v) => Future.value(Validation(transformed: '${v}_async', validation: null)),
          ],
          selector: (values) => values.join('-'),
        );
        final result = validator('x');
        expect(result, isA<Future<Validation<String>>>());
        final completed = await result;
        expect((completed as Validation).transformed, 'x_sync-x_async');
      });

      test('should return first failure with mixed async', () async {
        final validator = validators.multiple<String, String>(
          validators: [
            (_) => Future.value(Validation(transformed: 'fail', validation: TestValidation.reason)),
            (_) => Future.value(Validation(transformed: 'ok', validation: null)),
          ],
          selector: (values) => values.join('-'),
        );
        final result = await validator('x');
        expect((result as Validation).validation, TestValidation.reason);
      });
    });

    group('serial async', () {
      test('should chain async validators', () async {
        final validator = validators.serial<String>([
          (v) => Future.value(Validation(transformed: '${v}_a', validation: null)),
          (v) => Future.value(Validation(transformed: '${v}_b', validation: null)),
        ]);
        final result = await validator('x');
        expect((result as Validation).transformed, 'x_a_b');
      });

      test('should stop and return first async failure', () async {
        final validator = validators.serial<String>([
          (_) => Future.value(Validation(transformed: 'err', validation: TestValidation.reason)),
          (_) => Validation(transformed: 'should_not_run', validation: null),
        ]);
        final result = await validator('x');
        expect((result as Validation).validation, TestValidation.reason);
      });
    });

    group('chain async first', () {
      test('should chain async first with sync second', () async {
        final validator = validators.chain<String, int, String>(
          first: (v) => Future.value(Validation(transformed: v.length, validation: null)),
          second: (v) => Validation(transformed: 'len=$v', validation: null),
        );
        final result = await validator('hello');
        expect((result as Validation).transformed, 'len=5');
      });

      test('should chain async first with warning and sync second', () async {
        final validator = validators.chain<String, int, String>(
          first: (v) => Future.value(Validation(transformed: v.length, validation: TestValidation.reason)),
          second: (v) => Validation(transformed: 'warn=$v', validation: null),
        );
        final result = await validator('hi');
        expect((result as Validation).validation, TestValidation.reason);
        expect((result as Validation).transformed, 'warn=2');
      });

      test('should chain async first with warning and async second', () async {
        final validator = validators.chain<String, int, String>(
          first: (v) => Future.value(Validation(transformed: v.length, validation: TestValidation.reason)),
          second: (v) => Future.value(Validation(transformed: 'warn=$v', validation: null)),
        );
        final result = await validator('hello');
        expect((result as Validation).validation, TestValidation.reason);
        expect((result as Validation).transformed, 'warn=5');
      });

      test('should chain sync first with async second that has warning', () async {
        final validator = validators.chain<String, int, String>(
          first: (_) => Validation(transformed: 0, validation: TestValidation.reason),
          second: (v) => Future.value(Validation(transformed: 'warn=$v', validation: null)),
        );
        final result = await validator('x');
        expect((result as Validation).validation, TestValidation.reason);
        expect((result as Validation).transformed, 'warn=0');
      });
    });
  });
}
