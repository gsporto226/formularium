/// Holder do acesso global às localizações de um pacote, com hook de teste.
class CurrentL10n<T> {
  /// Cria um holder cujo valor default é produzido por [resolve].
  CurrentL10n(this.resolve);

  /// Resolve o valor corrente a partir do locale global.
  final T Function() resolve;

  T? _override;

  /// Valor corrente: override de teste, ou resolvido de `Intl.defaultLocale`.
  T get value => _override ?? resolve();

  /// Injeta um override (hook de teste).
  set value(T v) => _override = v;

  /// Remove o override.
  void reset() => _override = null;
}
