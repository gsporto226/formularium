import 'package:intl/intl.dart';

String decimal_field_value_too_big(String value) => Intl.message(
  'Valor maior que $value',
  name: 'decimal_field_value_too_big',
  args: [value],
  desc: 'Valor decimal excedeu o máximo permitido (value é o valor já formatado como moeda)',
);

String decimal_field_value_too_small(String value) => Intl.message(
  'Valor menor que $value',
  name: 'decimal_field_value_too_small',
  args: [value],
  desc: 'Valor decimal ficou abaixo do mínimo permitido (value é o valor já formatado como moeda)',
);
