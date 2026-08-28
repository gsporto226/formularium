import 'package:concierge/context_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:formularium/l10n/generated/app_localizations.dart';

/// Implementação de [IContext] de exemplo que entrega o
/// [IFormulariumLocalizations] default — a ponte [FormulariumLocalizations] —
/// embrulhando o [AppLocalizations] gerado por gen-l10n.
class AppContext implements IContext {
  /// Cria um [AppContext] sobre as localizações geradas [app].
  AppContext(this._app);

  final AppLocalizations _app;

  @override
  T get<T>() {
    if (T == IFormulariumLocalizations) {
      return FormulariumLocalizations(_app) as T;
    }
    throw StateError('$T não está registrado no AppContext de exemplo');
  }
}