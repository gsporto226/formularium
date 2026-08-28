// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String decimal_field_value_too_big(String value) {
    return 'Valor maior que $value';
  }

  @override
  String decimal_field_value_too_small(String value) {
    return 'Valor menor que $value';
  }
}
