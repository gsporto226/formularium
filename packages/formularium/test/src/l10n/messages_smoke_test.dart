// test/src/l10n/messages_smoke_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:formularium/l10n/messages_all.dart';
import 'package:formularium/l10n/intl_messages.dart';

void main() {
  test('pt (template) messages resolve', () async {
    Intl.defaultLocale = 'pt';
    await initializeMessages('pt');
    expect(validation_not_a_number, 'Não é um número válido');
  });
  test('en messages resolve', () async {
    Intl.defaultLocale = 'en';
    await initializeMessages('en');
    expect(validation_not_a_number, 'Not a valid number');
  });
}
