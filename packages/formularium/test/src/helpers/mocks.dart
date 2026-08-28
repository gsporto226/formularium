import 'package:concierge/context_interface.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockL10n extends Mock implements IFormulariumLocalizations {}

class MockContext extends Mock implements IContext {}

/// Cria um [MockContext] cujo `fL10n` retorna [l10n].
MockContext mockContext(MockL10n l10n) {
  final context = MockContext();
  when(() => context.fL10n).thenReturn(l10n);
  return context;
}