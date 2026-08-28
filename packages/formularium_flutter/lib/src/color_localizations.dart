import 'package:concierge/context_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:formularium_flutter/l10n/generated/app_localizations.dart';

/// Interface de localização para mensagens de validação do formularium flutter.
abstract interface class IFormulariumFlutterLocalizations {
  /// Retorna a mensagem de erro localizada para uma cor [value] inválida.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_color(String value);
}

/// Extensão que fornece acesso tipado a [IFormulariumFlutterLocalizations] a
/// partir de [IContext].
extension FormulariumFlutterL10n on IContext {
  /// Recupera a instância de [IFormulariumFlutterLocalizations] do contexto.
  IFormulariumFlutterLocalizations get ffL10n => get<IFormulariumFlutterLocalizations>();
}

/// Ponte padrão que expõe o [AppLocalizations] gerado por gen-l10n sob o
/// contrato [IFormulariumFlutterLocalizations].
class FormulariumFlutterLocalizations implements IFormulariumFlutterLocalizations {
  /// Cria uma ponte sobre a instância gerada [app].
  const FormulariumFlutterLocalizations(this._app);

  final AppLocalizations _app;

  /// Delegate padrão para uso em `MaterialApp.localizationsDelegates`.
  static const LocalizationsDelegate<FormulariumFlutterLocalizations> delegate =
      _FormulariumFlutterLocalizationsDelegate();

  /// Obtém as localizações do [context] embrulhadas na ponte.
  static FormulariumFlutterLocalizations of(BuildContext context) =>
      FormulariumFlutterLocalizations(AppLocalizations.of(context));

  @override
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_color(String value) => _app.validation_invalid_color(value);
}

/// Delegate que carrega um [FormulariumFlutterLocalizations] embrulhando o
/// [AppLocalizations] gerado.
class _FormulariumFlutterLocalizationsDelegate
    extends LocalizationsDelegate<FormulariumFlutterLocalizations> {
  const _FormulariumFlutterLocalizationsDelegate();

  @override
  Future<FormulariumFlutterLocalizations> load(Locale locale) async =>
      FormulariumFlutterLocalizations(await AppLocalizations.delegate.load(locale));

  @override
  bool isSupported(Locale locale) => AppLocalizations.delegate.isSupported(locale);

  @override
  bool shouldReload(_FormulariumFlutterLocalizationsDelegate old) => false;
}