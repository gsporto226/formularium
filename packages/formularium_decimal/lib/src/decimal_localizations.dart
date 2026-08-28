import 'package:concierge/context_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:formularium_decimal/l10n/generated/app_localizations.dart';

/// Extension para recuperar as localizações decimais do [IContext].
extension FormulariumDecimalL10n on IContext {
  /// As localizações para mensagens de validação de campos decimais.
  IFormulariumDecimalLocalizations get fdL10n => get<IFormulariumDecimalLocalizations>();
}

/// Interface de localização para mensagens de validação de campos decimais.
abstract interface class IFormulariumDecimalLocalizations {
  /// Mensagem exibida quando o valor do campo decimal é muito grande.
  // ignore: non_constant_identifier_names - snake_case for i18n interpolation key
  String decimal_field_value_too_big(String value);

  /// Mensagem exibida quando o valor do campo decimal é muito pequeno.
  // ignore: non_constant_identifier_names - snake_case for i18n interpolation key
  String decimal_field_value_too_small(String value);

  /// O identificador de localidade para formatação numérica.
  String get localeName;
}

/// Ponte padrão que expõe o [AppLocalizations] gerado por gen-l10n sob o
/// contrato [IFormulariumDecimalLocalizations].
class FormulariumDecimalLocalizations implements IFormulariumDecimalLocalizations {
  /// Cria uma ponte sobre a instância gerada [app].
  const FormulariumDecimalLocalizations(this._app);

  final AppLocalizations _app;

  /// Delegate padrão para uso em `MaterialApp.localizationsDelegates`.
  static const LocalizationsDelegate<FormulariumDecimalLocalizations> delegate =
      _FormulariumDecimalLocalizationsDelegate();

  /// Obtém as localizações do [context] embrulhadas na ponte.
  static FormulariumDecimalLocalizations of(BuildContext context) =>
      FormulariumDecimalLocalizations(AppLocalizations.of(context));

  @override
  String decimal_field_value_too_big(String value) => _app.decimal_field_value_too_big(value);

  @override
  String decimal_field_value_too_small(String value) => _app.decimal_field_value_too_small(value);

  @override
  String get localeName => _app.localeName;
}

/// Delegate que carrega um [FormulariumDecimalLocalizations] embrulhando o
/// [AppLocalizations] gerado.
class _FormulariumDecimalLocalizationsDelegate
    extends LocalizationsDelegate<FormulariumDecimalLocalizations> {
  const _FormulariumDecimalLocalizationsDelegate();

  @override
  Future<FormulariumDecimalLocalizations> load(Locale locale) async =>
      FormulariumDecimalLocalizations(await AppLocalizations.delegate.load(locale));

  @override
  bool isSupported(Locale locale) => AppLocalizations.delegate.isSupported(locale);

  @override
  bool shouldReload(_FormulariumDecimalLocalizationsDelegate old) => false;
}