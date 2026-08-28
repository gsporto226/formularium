import 'package:intl/intl.dart';

String validation_invalid_color(String value) => Intl.message(
  '"$value" não é uma cor válida',
  name: 'validation_invalid_color',
  args: [value],
  desc: 'Entrada não é uma cor válida (value é a cor informada)',
);
