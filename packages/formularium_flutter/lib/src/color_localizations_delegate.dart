import 'package:flutter/widgets.dart';
import 'package:formularium_flutter/src/color_localizations.dart';
import 'package:intl/intl.dart';

/// Sincroniza o locale do MaterialApp com `Intl.defaultLocale`.
class FormulariumFlutterLocalizationsDelegate
    extends LocalizationsDelegate<IFormulariumFlutterLocalizations> {
  /// Cria um delegate constante.
  const FormulariumFlutterLocalizationsDelegate();

  @override
  Future<IFormulariumFlutterLocalizations> load(Locale locale) async {
    await initFormulariumFlutterL10n(Intl.canonicalizedLocale(locale.toString()));
    return ffL10n;
  }

  @override
  bool isSupported(Locale locale) =>
      const ['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(covariant FormulariumFlutterLocalizationsDelegate old) => false;
}
