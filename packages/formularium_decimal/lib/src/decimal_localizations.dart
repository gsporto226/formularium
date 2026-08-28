import 'package:formularium_localization/formularium_localization.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../l10n/intl_messages.dart' as msgs;
import '../l10n/messages_all.dart' show initializeMessages;

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

/// Implementação pura em Dart sobre as mensagens geradas pelo intl_translation.
class FormulariumDecimalMessages implements IFormulariumDecimalLocalizations {
  /// Cria as localizações decimais.
  const FormulariumDecimalMessages();

  @override
  String decimal_field_value_too_big(String value) =>
      msgs.decimal_field_value_too_big(value);

  @override
  String decimal_field_value_too_small(String value) =>
      msgs.decimal_field_value_too_small(value);

  @override
  String get localeName => Intl.getCurrentLocale();
}

final CurrentL10n<IFormulariumDecimalLocalizations> _current =
    CurrentL10n(FormulariumDecimalMessages.new);

/// As localizações correntes para mensagens de validação de campos decimais.
IFormulariumDecimalLocalizations get fdL10n => _current.value;

/// Injeta um override (hook de teste).
set fdL10n(IFormulariumDecimalLocalizations value) => _current.value = value;

/// Remove o override injetado.
void resetFdL10n() => _current.reset();

/// Inicializa intl (mensagens + símbolos de data) para uso sem Flutter.
Future<void> initFormulariumDecimalL10n([String? locale]) async {
  final loc = Intl.canonicalizedLocale(locale ?? Intl.defaultLocale ?? 'en');
  Intl.defaultLocale = loc;
  await initializeMessages(loc);
  await initializeDateFormatting(loc);
}
