import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';
import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import '../../helpers/test_utils.dart';

void main() {
  group('FormFieldValidator', () {
    group('sync validation', () {
      test('should return ValidationPending initially', () {
        final validator = FormFieldValidator<String, String>(
          fn: (v) => Validation(transformed: v, validation: null),
          type: 'error',
          invalidates: true,
        );
        expect(validator.result, isA<ValidationPending<String>>());
      });

      test('should return ValidationDone with transformed value', () {
        final validator = FormFieldValidator<String, String>(
          fn: (v) => Validation(transformed: '${v}_ok', validation: null),
          type: 'error',
          invalidates: true,
        );
        final ValidationDone<String> result = (validator..value('input')).result as ValidationDone<String>;
        expect(result.transformed, 'input_ok');
        expect(result.validation, isNull);
      });

      test('should return ValidationDone with validation bundle when fn returns validation', () {
        final validator = FormFieldValidator<String, String>(
          fn: (_) => Validation(transformed: 'fail', validation: TestValidation.reason),
          type: 'error',
          invalidates: true,
        );
        final done = (validator..value('input')).result as ValidationDone<String>;
        expect(done.transformed, 'fail');
        expect(done.validation, isA<ValidationBundle>());
        expect(done.validation!.type, 'error');
        expect(done.validation!.validation, TestValidation.reason);
      });

      test('should use warning type in bundle', () {
        final validator = FormFieldValidator<String, String>(
          fn: (_) => Validation(transformed: 'warn', validation: TestValidation.reason),
          type: 'warning',
          invalidates: false,
        );
        final result = (validator..value('input')).result;
        expect((result as ValidationDone).validation!.type, 'warning');
      });
    });

    group('async validation', () {
      test('should return ValidationValidating while async is in progress', () {
        final completer = Completer<Validation<String>>();
        final validator = FormFieldValidator<String, String>(
          fn: (_) => completer.future,
          type: 'error',
          invalidates: true,
        );
        expect((validator..value('input')).result, isA<ValidationValidating<String>>());
      });

      test('should return ValidationDone after async completes', () async {
        final completer = Completer<Validation<String>>();
        final validator = FormFieldValidator<String, String>(
          fn: (_) => completer.future,
          type: 'error',
          invalidates: true,
        );
        expect((validator..value('input')).result, isA<ValidationValidating<String>>());

        final done = Completer<void>();
        validator.addListener(() {
          if (validator.result is ValidationDone<String>) done.complete();
        });
        completer.complete(Validation(transformed: 'async_ok', validation: null));
        await done.future;

        final result = validator.result;
        expect(result, isA<ValidationDone<String>>());
        expect((result as ValidationDone).transformed, 'async_ok');
      });

      test('should throw ValidationFNShouldNeverThrowError on async error', () async {
        final validator = FormFieldValidator<String, String>(
          fn: (_) => Future.error(Exception('async error')),
          type: 'error',
          invalidates: true,
        );
        final errorCompleter = Completer<void>();
        await runZonedGuarded(
          () async {
            validator.value('input');
            // Wait for the async error to propagate through the zone
            await errorCompleter.future;
          },
          (error, stack) {
            expect(error, isA<ValidationFNShouldNeverThrowError>());
            errorCompleter.complete();
          },
        );
      });

      test('should ignore stale async results', () async {
        final staleCompleter = Completer<Validation<String>>();
        final currentCompleter = Completer<Validation<String>>();
        var callCount = 0;
        final validator = FormFieldValidator<String, String>(
          fn: (_) {
            callCount++;
            return callCount == 1 ? staleCompleter.future : currentCompleter.future;
          },
          type: 'error',
          invalidates: true,
        );
        expect((validator..value('first')).result, isA<ValidationValidating<String>>());
        expect((validator..value('second')).result, isA<ValidationValidating<String>>());

        staleCompleter.complete(Validation(transformed: 'stale', validation: null));
        // Wait for the stale microtask to be processed (it will be ignored)
        await null;
        // Stale result should be ignored — second generation is still pending
        expect(validator.result, isA<ValidationValidating<String>>());

        final done = Completer<void>();
        validator.addListener(() {
          if (validator.result is ValidationDone<String>) done.complete();
        });
        currentCompleter.complete(Validation(transformed: 'current', validation: null));
        await done.future;
        expect(validator.result, isA<ValidationDone<String>>());
        expect((validator.result as ValidationDone).transformed, 'current');
      });
    });

    group('validate()', () {
      test('should notify listeners', () {
        final validator = FormFieldValidator<String, String>(
          fn: (v) => Validation(transformed: v, validation: null),
          type: 'error',
          invalidates: true,
        );
        var notified = false;
        validator
          ..value('input')
          ..addListener(() {
            notified = true;
          })
          ..validate();
        expect(notified, true);
      });

      test('should not notify if generation unchanged', () {
        final validator = FormFieldValidator<String, String>(
          fn: (v) => Validation(transformed: v, validation: null),
          type: 'error',
          invalidates: true,
        );
        var notifyCount = 0;
        validator
          ..addListener(() {
            notifyCount++;
          })
          ..value('input')
          ..validate();
        expect(notifyCount, 1);
        // Second call does not notify (no new generation)
        validator.validate();
        expect(notifyCount, 1);
      });
    });

    group('reset()', () {
      test('should reset to ValidationPending', () {
        final validator = FormFieldValidator<String, String>(
          fn: (v) => Validation(transformed: v, validation: null),
          type: 'error',
          invalidates: true,
        );
        expect((validator..value('input')).result, isA<ValidationDone<String>>());
        expect((validator..reset()).result, isA<ValidationPending<String>>());
      });
    });

    group('ValidationBundle', () {
      test('should create with type and validation', () {
        const bundle = ValidationBundle(type: 'error', validation: TestValidation.reason);
        expect(bundle.type, 'error');
        expect(bundle.validation, TestValidation.reason);
      });

      test('equality', () {
        const a = ValidationBundle(type: 'error', validation: TestValidation.reason);
        const b = ValidationBundle(type: 'error', validation: TestValidation.reason);
        const c = ValidationBundle(type: 'warning', validation: TestValidation.reason);
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });

      test('hashCode', () {
        const a = ValidationBundle(type: 'error', validation: TestValidation.reason);
        const b = ValidationBundle(type: 'error', validation: TestValidation.reason);
        expect(a.hashCode, equals(b.hashCode));
      });
    });

    group('ValidationFNShouldNeverThrowError', () {
      test('should create with message, original error and stack', () {
        final originalError = Exception('test error');
        final originalStack = StackTrace.current;
        final error = ValidationFNShouldNeverThrowError(
          'Custom message',
          originalError,
          originalStack,
        );
        expect(error.message, 'Custom message');
        expect(error.originalError, originalError);
        expect(error.originalStack, originalStack);
      });
    });
  });
}
