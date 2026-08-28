import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @date_time_field_before.
  ///
  /// In pt, this message translates to:
  /// **'Deve ser antes de {date}'**
  String date_time_field_before(String date);

  /// No description provided for @date_time_field_after.
  ///
  /// In pt, this message translates to:
  /// **'Deve ser depois de {date}'**
  String date_time_field_after(String date);

  /// No description provided for @date_time_field_before_inclusive.
  ///
  /// In pt, this message translates to:
  /// **'Deve ser antes ou em {date}'**
  String date_time_field_before_inclusive(String date);

  /// No description provided for @date_time_field_after_inclusive.
  ///
  /// In pt, this message translates to:
  /// **'Deve ser depois ou em {date}'**
  String date_time_field_after_inclusive(String date);

  /// No description provided for @number_field_value_too_big.
  ///
  /// In pt, this message translates to:
  /// **'Valor maior que {number}'**
  String number_field_value_too_big(String number);

  /// No description provided for @number_field_value_too_small.
  ///
  /// In pt, this message translates to:
  /// **'Valor menor que {number}'**
  String number_field_value_too_small(String number);

  /// No description provided for @validation_not_a_number.
  ///
  /// In pt, this message translates to:
  /// **'Não é um número válido'**
  String get validation_not_a_number;

  /// No description provided for @number_field_not_divisible.
  ///
  /// In pt, this message translates to:
  /// **'Não é divisível por {divisor}'**
  String number_field_not_divisible(String divisor);

  /// No description provided for @number_field_not_positive.
  ///
  /// In pt, this message translates to:
  /// **'Deve ser positivo'**
  String get number_field_not_positive;

  /// No description provided for @number_field_not_negative.
  ///
  /// In pt, this message translates to:
  /// **'Deve ser negativo'**
  String get number_field_not_negative;

  /// No description provided for @validation_not_a_boolean.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um booleano válido'**
  String validation_not_a_boolean(String value);

  /// No description provided for @validation_invalid_port.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é uma porta válida'**
  String validation_invalid_port(String value);

  /// No description provided for @validation_invalid_url.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é uma URL válida'**
  String validation_invalid_url(String value);

  /// No description provided for @validation_invalid_lat_long.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é latitude/longitude válida'**
  String validation_invalid_lat_long(String value);

  /// No description provided for @validation_invalid_email.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um email válido'**
  String validation_invalid_email(String value);

  /// No description provided for @validation_invalid_uuid.
  ///
  /// In pt, this message translates to:
  /// **'UUID inválido {version}'**
  String validation_invalid_uuid(String version);

  /// No description provided for @validation_invalid_semver.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é uma versão semântica válida'**
  String validation_invalid_semver(String value);

  /// No description provided for @validation_invalid_jwt.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um JWT válido'**
  String validation_invalid_jwt(String value);

  /// No description provided for @validation_invalid_slug.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um slug válido'**
  String validation_invalid_slug(String value);

  /// No description provided for @validation_not_base64.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é Base64 válido'**
  String validation_not_base64(String value);

  /// No description provided for @validation_invalid_mime_type.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um MIME type válido'**
  String validation_invalid_mime_type(String value);

  /// No description provided for @validation_invalid_locale.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é uma localidade válida'**
  String validation_invalid_locale(String value);

  /// No description provided for @validation_invalid_credit_card.
  ///
  /// In pt, this message translates to:
  /// **'Cartão de crédito inválido {provider}'**
  String validation_invalid_credit_card(String provider);

  /// No description provided for @validation_weak_password.
  ///
  /// In pt, this message translates to:
  /// **'Senha fraca ({score}/{minScore})'**
  String validation_weak_password(int score, int minScore);

  /// No description provided for @validation_invalid_mongo_id.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um MongoId válido'**
  String validation_invalid_mongo_id(String value);

  /// No description provided for @validation_invalid_hash.
  ///
  /// In pt, this message translates to:
  /// **'Hash {algorithm} inválido'**
  String validation_invalid_hash(String algorithm);

  /// No description provided for @validation_invalid_imei.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um IMEI válido'**
  String validation_invalid_imei(String value);

  /// No description provided for @validation_invalid_phone.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um telefone válido'**
  String validation_invalid_phone(String value);

  /// No description provided for @validation_invalid_json.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é JSON válido'**
  String validation_invalid_json(String value);

  /// No description provided for @validation_invalid_mac_address.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é MAC address válido'**
  String validation_invalid_mac_address(String value);

  /// No description provided for @validation_not_octal.
  ///
  /// In pt, this message translates to:
  /// **'Não é octal válido'**
  String get validation_not_octal;

  /// No description provided for @validation_byte_length_exceeded.
  ///
  /// In pt, this message translates to:
  /// **'Comprimento em bytes deve ser entre {min} e {max}'**
  String validation_byte_length_exceeded(int min, int max);

  /// No description provided for @validation_not_multibyte.
  ///
  /// In pt, this message translates to:
  /// **'Não é multibyte'**
  String get validation_not_multibyte;

  /// No description provided for @validation_not_full_width.
  ///
  /// In pt, this message translates to:
  /// **'Não é full-width'**
  String get validation_not_full_width;

  /// No description provided for @validation_not_half_width.
  ///
  /// In pt, this message translates to:
  /// **'Não é half-width'**
  String get validation_not_half_width;

  /// No description provided for @validation_not_variable_width.
  ///
  /// In pt, this message translates to:
  /// **'Não é variable-width'**
  String get validation_not_variable_width;

  /// No description provided for @validation_not_surrogate_pair.
  ///
  /// In pt, this message translates to:
  /// **'Não é surrogate pair'**
  String get validation_not_surrogate_pair;

  /// No description provided for @validation_invalid_ip.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um IP válido'**
  String validation_invalid_ip(String value);

  /// No description provided for @validation_invalid_postal_code.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um CEP válido'**
  String validation_invalid_postal_code(String value);

  /// No description provided for @validation_invalid_isbn.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um ISBN válido'**
  String validation_invalid_isbn(String value);

  /// No description provided for @validation_invalid_ean.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um EAN válido'**
  String validation_invalid_ean(String value);

  /// No description provided for @validation_invalid_base32.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é Base32 válido'**
  String validation_invalid_base32(String value);

  /// No description provided for @validation_invalid_base58.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é Base58 válido'**
  String validation_invalid_base58(String value);

  /// No description provided for @validation_not_alphanumeric.
  ///
  /// In pt, this message translates to:
  /// **'Não é alfanumérico'**
  String get validation_not_alphanumeric;

  /// No description provided for @validation_not_alpha.
  ///
  /// In pt, this message translates to:
  /// **'Não é alfabético'**
  String get validation_not_alpha;

  /// No description provided for @validation_not_ascii.
  ///
  /// In pt, this message translates to:
  /// **'Não é ASCII'**
  String get validation_not_ascii;

  /// No description provided for @validation_not_numeric.
  ///
  /// In pt, this message translates to:
  /// **'Não é numérico'**
  String validation_not_numeric(bool noSymbols);

  /// No description provided for @validation_not_hexadecimal.
  ///
  /// In pt, this message translates to:
  /// **'Não é hexadecimal'**
  String get validation_not_hexadecimal;

  /// No description provided for @validation_not_lowercase.
  ///
  /// In pt, this message translates to:
  /// **'Não está em minúsculas'**
  String get validation_not_lowercase;

  /// No description provided for @validation_not_uppercase.
  ///
  /// In pt, this message translates to:
  /// **'Não está em maiúsculas'**
  String get validation_not_uppercase;

  /// No description provided for @validation_string_length_exceeded.
  ///
  /// In pt, this message translates to:
  /// **'Comprimento deve ser entre {min} e {max}'**
  String validation_string_length_exceeded(int min, int max);

  /// No description provided for @validation_string_length_mismatch.
  ///
  /// In pt, this message translates to:
  /// **'Comprimento deve ser um de: {discrete}'**
  String validation_string_length_mismatch(List<int> discrete);

  /// No description provided for @validation_pattern_mismatch.
  ///
  /// In pt, this message translates to:
  /// **'Não corresponde ao padrão: {pattern}'**
  String validation_pattern_mismatch(String pattern);

  /// No description provided for @validation_not_in_list.
  ///
  /// In pt, this message translates to:
  /// **'Valor não está na lista permitida'**
  String get validation_not_in_list;

  /// No description provided for @validation_must_contain.
  ///
  /// In pt, this message translates to:
  /// **'Deve conter \"{seed}\"'**
  String validation_must_contain(String seed);

  /// No description provided for @validation_must_equal.
  ///
  /// In pt, this message translates to:
  /// **'Deve ser igual a \"{comparison}\"'**
  String validation_must_equal(String comparison);

  /// No description provided for @validation_invalid_time.
  ///
  /// In pt, this message translates to:
  /// **'\"{value}\" não é um horário válido (formato {hourFormat}, modo {mode})'**
  String validation_invalid_time(String value, String hourFormat, String mode);

  /// No description provided for @date_invalid.
  ///
  /// In pt, this message translates to:
  /// **'Data inválida'**
  String get date_invalid;

  /// No description provided for @required_field_label.
  ///
  /// In pt, this message translates to:
  /// **'Campo obrigatório'**
  String get required_field_label;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
