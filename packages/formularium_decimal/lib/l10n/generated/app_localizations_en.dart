// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String decimal_field_value_too_big(String value) {
    return 'Value greater than $value';
  }

  @override
  String decimal_field_value_too_small(String value) {
    return 'Value smaller than $value';
  }
}
