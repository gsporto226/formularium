import 'package:concierge/context_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

/// Implementação de [IContext] de exemplo que entrega o
/// [IFormulariumLocalizations] default — [FormulariumMessages], a
/// implementação pura em Dart sobre as mensagens do intl_translation.
class AppContext implements IContext {
  /// Cria um [AppContext] com as localizações default.
  const AppContext();

  @override
  T get<T>() {
    if (T == IFormulariumLocalizations) {
      return const FormulariumMessages() as T;
    }
    throw StateError('$T não está registrado no AppContext de exemplo');
  }
}
