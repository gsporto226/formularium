// test/current_l10n_test.dart
import 'package:formularium_localization/formularium_localization.dart';
import 'package:test/test.dart';

void main() {
  group('CurrentL10n', () {
    test('resolves from resolve() when no override', () {
      final holder = CurrentL10n<String>(() => 'resolved');
      expect(holder.value, 'resolved');
    });
    test('returns override when set', () {
      final holder = CurrentL10n<String>(() => 'resolved')..value = 'overridden';
      expect(holder.value, 'overridden');
    });
    test('reset() returns to resolve()', () {
      final holder = CurrentL10n<String>(() => 'resolved')..value = 'overridden';
      holder.reset();
      expect(holder.value, 'resolved');
    });
  });

  group('ILocalizable', () {
    test('localizes with no arguments', () {
      expect(const Fake().localize(), 'fake');
    });
  });
}

class Fake implements ILocalizable {
  const Fake();
  @override
  String localize() => 'fake';
}
