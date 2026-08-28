import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/date_time_validation.dart';
import 'package:formularium/features/validators/_enums/input_date_format.dart';
import 'package:formularium/features/validators/_utils/date_time_localizations.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/mocks.dart';

void main() {
  group('DateTimeLocalizations extension', () {
    test('localize should format DateTime with pattern', () async {
      final l10n = MockL10n();
      when(() => l10n.localeName).thenReturn('en_US');

      final date = DateTime(2024, 6, 15);
      final result = date.localize(l10n, pattern: 'yyyy/MM/dd');

      expect(result, '2024/06/15');
    });

    test('localize should use default pattern when not provided', () async {
      final l10n = MockL10n();
      when(() => l10n.localeName).thenReturn('en_US');

      final date = DateTime(2024, 6, 15);
      final result = date.localize(l10n);

      expect(result, 'June 15, 2024');
    });
  });

  group('DateBefore localize', () {
    test('should call l10n.date_time_field_before with formatted date', () async {
      final l10n = MockL10n();
      when(() => l10n.localeName).thenReturn('en_US');
      when(() => l10n.date_time_field_before(any())).thenReturn('before June 15, 2024');

      final context = mockContext(l10n);
      final ref = DateTime(2024, 6, 15);
      final v = DateBefore(ref);
      expect(v.localize(context), 'before June 15, 2024');
      verify(() => l10n.date_time_field_before(any())).called(1);
    });

    test('should use format pattern when provided', () async {
      final l10n = MockL10n();
      when(() => l10n.localeName).thenReturn('en_US');
      when(() => l10n.date_time_field_before(any())).thenReturn('before 2024');

      final context = mockContext(l10n);
      final ref = DateTime(2024, 6, 15);
      final v = DateBefore(ref, format: InputDateFormat.yyyy);
      expect(v.localize(context), 'before 2024');
    });
  });

  group('DateAfter localize', () {
    test('should call l10n.date_time_field_after with formatted date', () async {
      final l10n = MockL10n();
      when(() => l10n.localeName).thenReturn('en_US');
      when(() => l10n.date_time_field_after(any())).thenReturn('after June 15, 2024');

      final context = mockContext(l10n);
      final ref = DateTime(2024, 6, 15);
      final v = DateAfter(ref);
      expect(v.localize(context), 'after June 15, 2024');
    });
  });

  group('DateAfterInclusive localize', () {
    test('should call l10n.date_time_field_after_inclusive', () async {
      final l10n = MockL10n();
      when(() => l10n.localeName).thenReturn('en_US');
      when(() => l10n.date_time_field_after_inclusive(any())).thenReturn('on or after June 15, 2024');

      final context = mockContext(l10n);
      final ref = DateTime(2024, 6, 15);
      final v = DateAfterInclusive(ref);
      expect(v.localize(context), 'on or after June 15, 2024');
    });
  });

  group('DateBeforeInclusive localize', () {
    test('should call l10n.date_time_field_before_inclusive', () async {
      final l10n = MockL10n();
      when(() => l10n.localeName).thenReturn('en_US');
      when(() => l10n.date_time_field_before_inclusive(any())).thenReturn('on or before June 15, 2024');

      final context = mockContext(l10n);
      final ref = DateTime(2024, 6, 15);
      final v = DateBeforeInclusive(ref);
      expect(v.localize(context), 'on or before June 15, 2024');
    });
  });
}
