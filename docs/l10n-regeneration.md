# Regeneração das mensagens l10n (intl_translation)

Os três pacotes com mensagens (`formularium`, `formularium_decimal`, `formularium_flutter`)
usam **intl_translation** com mensagens puras em Dart (`Intl.message`), resolvidas por
`Intl.defaultLocale`. Não há mais gen-l10n/`flutter_localizations` na biblioteca.

## Topologia de arquivos (por pacote)

| Arquivo | Papel |
|---|---|
| `lib/l10n/intl_messages.dart` | Fonte das mensagens (pt, template). **Editável** — é aqui que se adiciona/altera mensagem, `desc:` ou placeholder. É reescrito pelo gerador, mantendo o conteúdo dos ARBs. |
| `lib/l10n/arb/intl_messages.arb` | Saída do `extract_to_arb` (metadados `@key`, incluindo `description`). Comprometido — é o template canônico para tradutores. |
| `lib/l10n/arb/app_pt.arb` | Tradução pt (template). Entrada do `generate_from_arb`. |
| `lib/l10n/arb/app_en.arb` | Tradução en. Entrada do `generate_from_arb`. |
| `lib/l10n/messages_all.dart`, `messages_pt.dart`, `messages_en.dart`, `messages_all_locales.dart` | Gerados. **Não editar à mão.** |

## Fluxo de regeneração (a partir do diretório do pacote)

```bash
# 1. Edite lib/l10n/intl_messages.dart (mensagem nova/alterada + desc)

# 2. Extraia as mensagens para o ARB template
dart run intl_translation:extract_to_arb --output-dir=lib/l10n/arb lib/l10n/intl_messages.dart

# 3. Traduza as chaves novas em lib/l10n/arb/app_en.arb (pt já é o template)

# 4. Gere os lookups por locale (REESCREVE intl_messages.dart in-place)
dart run intl_translation:generate_from_arb --output-dir=lib/l10n \
  lib/l10n/intl_messages.dart lib/l10n/arb/app_pt.arb lib/l10n/arb/app_en.arb
```

## Regras

- Nome da função/getter = chave da mensagem = `name:` do `Intl.message` (snake_case).
- Placeholders: ARB `{x}` → interpolação `$x` + `args: [x]`. Todos os argumentos de
  `Intl.message` (incluindo `desc:`) devem ser **literais de string sem interpolação**.
- `localeName` resolve via `Intl.getCurrentLocale()`; o locale corrente é sincronizado
  pelo delegate de cada pacote (`Formularium*LocalizationsDelegate`) ou por
  `initFormularium*L10n([locale])` em uso puro-Dart.
- Cada pacote expõe o acesso global (`fL10n` / `fdL10n` / `ffL10n`) com hook de teste
  (`set fX10n(...)` + `resetFX10n()`).
