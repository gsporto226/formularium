import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'decimal_localizations.dart';

/// Delegate que sincroniza `Intl.defaultLocale` com o locale do Flutter antes
/// das localizações serem resolvidas.
class FormulariumDecimalLocalizationsDelegate
    extends LocalizationsDelegate<IFormulariumDecimalLocalizations> {
  /// Cria o delegate.
  const FormulariumDecimalLocalizationsDelegate();

  @override
  Future<IFormulariumDecimalLocalizations> load(Locale locale) async {
    await initFormulariumDecimalL10n(Intl.canonicalizedLocale(locale.toString()));
    return fdL10n;
  }

  @override
  bool isSupported(Locale locale) =>
      const <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(FormulariumDecimalLocalizationsDelegate old) => false;
}
