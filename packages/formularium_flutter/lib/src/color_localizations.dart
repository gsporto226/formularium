import 'package:formularium_flutter/l10n/intl_messages.dart' as msgs;
import 'package:formularium_flutter/l10n/messages_all.dart' show initializeMessages;
import 'package:formularium_localization/formularium_localization.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;
import 'package:intl/intl.dart';

/// Interface de localização para mensagens de validação do formularium flutter.
abstract interface class IFormulariumFlutterLocalizations {
  /// Retorna a mensagem de erro localizada para uma cor [value] inválida.
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_color(String value);
}

/// Implementação pura em Dart sobre as mensagens geradas pelo intl_translation.
class FormulariumFlutterMessages implements IFormulariumFlutterLocalizations {
  /// Cria uma instância constante das mensagens.
  const FormulariumFlutterMessages();

  @override
  // ignore: non_constant_identifier_names - snake_case for i18n key
  String validation_invalid_color(String value) => msgs.validation_invalid_color(value);
}

final CurrentL10n<IFormulariumFlutterLocalizations> _current =
    CurrentL10n(FormulariumFlutterMessages.new);

/// Mensagens do formularium_flutter no locale corrente (`Intl.defaultLocale`).
IFormulariumFlutterLocalizations get ffL10n => _current.value;
set ffL10n(IFormulariumFlutterLocalizations v) => _current.value = v;
void resetFfL10n() => _current.reset();

/// Inicializa intl (mensagens + símbolos de data) para uso sem Flutter.
Future<void> initFormulariumFlutterL10n([String? locale]) async {
  final loc = Intl.canonicalizedLocale(locale ?? Intl.defaultLocale ?? 'en');
  Intl.defaultLocale = loc;
  await initializeMessages(loc);
  await initializeDateFormatting(loc);
}
