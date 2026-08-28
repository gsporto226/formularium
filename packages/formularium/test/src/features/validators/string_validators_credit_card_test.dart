import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';
import 'package:formularium/features/validators/_validators/string_validators.dart';

void main() {
  final v = StringValidators.instance;

  group('StringValidators - Credit Card', () {
    group('isCreditCard', () {
      test('valid Visa', () async {
        final r = await v.isCreditCard()('4111111111111111');
        expect(r.validation, isNull);
        expect(r.transformed, '4111111111111111');
      });
      test('valid Mastercard', () async {
        final r = await v.isCreditCard()('5555555555554444');
        expect(r.validation, isNull);
        expect(r.transformed, '5555555555554444');
      });
      test('valid Amex', () async {
        final r = await v.isCreditCard()('378282246310005');
        expect(r.validation, isNull);
        expect(r.transformed, '378282246310005');
      });
      test('valid Discover', () async {
        final r = await v.isCreditCard()('6011111111111117');
        expect(r.validation, isNull);
        expect(r.transformed, '6011111111111117');
      });
      test('valid Diners Club', () async {
        final r = await v.isCreditCard()('30569309025904');
        expect(r.validation, isNull);
        expect(r.transformed, '30569309025904');
      });
      test('valid JCB', () async {
        final r = await v.isCreditCard()('3530111333300000');
        expect(r.validation, isNull);
        expect(r.transformed, '3530111333300000');
      });
      test('valid Mastercard 51', () async {
        final r = await v.isCreditCard(provider: 'mastercard')('5100000000000008');
        expect(r.validation, isNull);
        expect(r.transformed, '5100000000000008');
      });
      test('valid Mastercard 2221', () async {
        final r = await v.isCreditCard(provider: 'mastercard')('2221000000000009');
        expect(r.validation, isNull);
        expect(r.transformed, '2221000000000009');
      });
      test('valid Amex', () async {
        final r = await v.isCreditCard(provider: 'amex')('340000000000009');
        expect(r.validation, isNull);
        expect(r.transformed, '340000000000009');
      });
      test('valid Discover 6011', () async {
        final r = await v.isCreditCard(provider: 'discover')('6011000000000004');
        expect(r.validation, isNull);
        expect(r.transformed, '6011000000000004');
      });
      test('valid Discover 644', () async {
        final r = await v.isCreditCard(provider: 'discover')('6440000000000005');
        expect(r.validation, isNull);
        expect(r.transformed, '6440000000000005');
      });
      test('valid Diners Club 300', () async {
        final r = await v.isCreditCard(provider: 'dinersclub')('30000000000004');
        expect(r.validation, isNull);
        expect(r.transformed, '30000000000004');
      });
      test('valid Diners Club 36', () async {
        final r = await v.isCreditCard(provider: 'dinersclub')('36000000000008');
        expect(r.validation, isNull);
        expect(r.transformed, '36000000000008');
      });
      test('valid JCB', () async {
        final r = await v.isCreditCard(provider: 'jcb')('3528000000000007');
        expect(r.validation, isNull);
        expect(r.transformed, '3528000000000007');
      });
      test('valid UnionPay 622126', () async {
        final r = await v.isCreditCard(provider: 'unionpay')('6221260000000000');
        expect(r.validation, isNull);
        expect(r.transformed, '6221260000000000');
      });
      test('valid UnionPay 624', () async {
        final r = await v.isCreditCard(provider: 'unionpay')('6240000000000007');
        expect(r.validation, isNull);
        expect(r.transformed, '6240000000000007');
      });
      test('valid UnionPay 6282', () async {
        final r = await v.isCreditCard(provider: 'unionpay')('6282000000000006');
        expect(r.validation, isNull);
        expect(r.transformed, '6282000000000006');
      });
      test('with provider match', () async {
        final r = await v.isCreditCard(provider: 'visa')('4111111111111111');
        expect(r.validation, isNull);
        expect(r.transformed, '4111111111111111');
      });
      test('provider mismatch', () async {
        final r = await v.isCreditCard(provider: 'amex')('4111111111111111');
        expect(r.validation, isA<InvalidCreditCard>());
        final error = r.validation! as InvalidCreditCard;
        expect(error.provider, 'amex');
      });
      test('invalid Luhn', () async {
        final r = await v.isCreditCard()('4111111111111112');
        expect(r.validation, isA<InvalidCreditCard>());
        final error = r.validation! as InvalidCreditCard;
        expect(error.provider, isNull);
      });
      test('too short', () async {
        final r = await v.isCreditCard()('123');
        expect(r.validation, isA<InvalidCreditCard>());
        final error = r.validation! as InvalidCreditCard;
        expect(error.provider, isNull);
      });
    });
  });
}
