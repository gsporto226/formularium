import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockL10n extends Mock implements IFormulariumLocalizations {}

/// Injeta [l10n] como localizações correntes do formularium para o teste.
void mockL10n(MockL10n l10n) => fL10n = l10n;
