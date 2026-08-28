// formularium_localizations_delegate.dart
import 'package:flutter/widgets.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:intl/intl.dart';

/// Sincroniza o locale do MaterialApp com `Intl.defaultLocale`.
class FormulariumLocalizationsDelegate
    extends LocalizationsDelegate<IFormulariumLocalizations> {
  const FormulariumLocalizationsDelegate();

  @override
  Future<IFormulariumLocalizations> load(Locale locale) async {
    await initFormulariumL10n(Intl.canonicalizedLocale(locale.toString()));
    return fL10n;
  }

  @override
  bool isSupported(Locale locale) =>
      const ['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(covariant FormulariumLocalizationsDelegate old) => false;
}
