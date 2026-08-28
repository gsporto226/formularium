// test/decimal_localizations_test.dart
import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium_decimal/src/decimal_localizations.dart';
import 'package:formularium_decimal/src/decimal_validation.dart';
import 'package:intl/intl.dart';

void main() {
  tearDown(resetFdL10n);
  test('en: too-big message resolves via Intl.defaultLocale', () async {
    await initFormulariumDecimalL10n('en');
    final formatted = DecimalFormatter(NumberFormat.currency(locale: 'en', symbol: r'R$'))
        .format(Decimal.parse('1234.56'));
    expect(fdL10n.decimal_field_value_too_big(formatted), 'Value greater than $formatted');
  });
  test('pt: too-small message', () async {
    await initFormulariumDecimalL10n('pt');
    final formatted = DecimalFormatter(NumberFormat.currency(locale: 'pt', symbol: r'R$'))
        .format(Decimal.parse('10'));
    expect(fdL10n.decimal_field_value_too_small(formatted), 'Valor menor que $formatted');
  });
  test('en: DecimalTooBig.localize assembles message', () async {
    await initFormulariumDecimalL10n('en');
    final formatted = DecimalFormatter(NumberFormat.currency(locale: 'en', symbol: r'R$'))
        .format(Decimal.parse('100'));
    expect(DecimalValidation.max(Decimal.parse('100')).localize(), 'Value greater than $formatted');
  });
  test('en: DecimalTooSmall.localize assembles message', () async {
    await initFormulariumDecimalL10n('en');
    final formatted = DecimalFormatter(NumberFormat.currency(locale: 'en', symbol: r'R$'))
        .format(Decimal.parse('100'));
    expect(DecimalValidation.min(Decimal.parse('100')).localize(), 'Value smaller than $formatted');
  });
}
