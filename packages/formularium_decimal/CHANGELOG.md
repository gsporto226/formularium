## 0.1.0

 - **BREAKING**(formularium_decimal): `ILocalizable` movido para `formularium_localization`; assinatura agora é `String localize()` (sem `IContext`/parâmetros).
 - **BREAKING**(formularium_decimal): `concierge` e `localization_interface` removidos como dependências.
 - **FEAT**(formularium_decimal): mensagens resolvidas via `Intl.defaultLocale` (intl nativo); ARBs gerados com `intl_translation` (gen-l10n removido).
 - **FEAT**(formularium_decimal): novo acesso global `fdL10n` + `resetFdL10n()` + `initFormulariumDecimalL10n([locale])` para uso sem Flutter.
 - **REFACTOR**(formularium_decimal): delegate renomeado para `FormulariumDecimalLocalizationsDelegate`.
 - **DOCS**(formularium_decimal): migração para consumidores: (1) importar `package:formularium_localization/formularium_localization.dart`; (2) `localize(IContext)` → `localize()`; (3) resolver mensagens via o global `fdL10n` ou `Intl.message`; (4) call sites deixam de passar o contexto.

## 0.0.2

 - **REFACTOR**(formularium): adiciona docs em pt-BR, corrige lints e seções supérfluas. ([a15c26a6](https://github.com/ConceitoSolucoes/FlutterMonorepo/commit/a15c26a67cf9658e4361d425394962925fea444f))
 - **REFACTOR**: migra pacotes para usar extensões de localização por pacote. ([41189584](https://github.com/ConceitoSolucoes/FlutterMonorepo/commit/41189584bb31da464a307a2d127e2e2fb95105b1))
 - **REFACTOR**: rename flutter_localization_interface to localization_interface. ([9a78aae8](https://github.com/ConceitoSolucoes/FlutterMonorepo/commit/9a78aae871285fde023a831682407cf42c83d6cb))
 - **FEAT**: adiciona interfaces de localização por pacote. ([963f03ec](https://github.com/ConceitoSolucoes/FlutterMonorepo/commit/963f03ec2c055b2b426bebed95383560df2e5916))
 - **FEAT**: add formularium_decimal package. ([117919e1](https://github.com/ConceitoSolucoes/FlutterMonorepo/commit/117919e12cd76d1b56a98c5a83d90508afb82e75))

