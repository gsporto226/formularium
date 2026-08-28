import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:intl/intl.dart';

/// Métodos de extensão em [DateTime] para formatação localizada usando [IFormulariumLocalizations].
extension DateTimeLocalizations on DateTime {
  /// Formata este [DateTime] usando o nome da localidade de [IFormulariumLocalizations] e um padrão opcional.
  String localize(
    IFormulariumLocalizations l10n, {
    String? pattern,
  }) {
    final fmt = DateFormat(pattern ?? DateFormat.YEAR_MONTH_DAY, l10n.localeName);
    return fmt.format(this);
  }
}
