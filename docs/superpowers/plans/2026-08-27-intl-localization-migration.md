# intl Localization Migration — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the concierge/`IContext` localization stack with intl-native, Flutter-free localizations across `formularium`, `formularium_decimal`, and `formularium_flutter`.

**Architecture:** `ILocalizable.localize()` becomes context-free and resolves via a global `fL10n`-style accessor backed by `Intl.defaultLocale`. Messages are generated from the existing ARBs by `intl_translation` (pure-Dart `Intl.message` output) instead of gen-l10n. Flutter shrinks to one delegate file per package whose only job is syncing `Intl.defaultLocale` + initializing intl data.

**Tech Stack:** Dart ≥3.12, `intl ^0.20.2`, `intl_translation ^0.21.0` (dev, codegen), Flutter (adapters + example only), `mocktail` (formularium tests), `flutter_test` (decimal/flutter tests).

**Spec:** `docs/superpowers/specs/2026-08-27-intl-localization-design.md`

## Global Constraints

- Locale source of truth: `Intl.defaultLocale`. Never thread a context/parameter for messages.
- Every localizations layer is **pure Dart** (no `package:flutter/...` imports) except the single `*_delegate.dart` adapter file per Flutter package.
- Message keys/function names: **snake_case = ARB keys**. Template locale: **pt**.
- Placeholders: ARB `{date}` → `Intl.message` `$date` + `args: [date]`.
- `generate_from_arb` **rewrites the seed `.dart` file** in place — never hand-edit after generation.
- Message getter/member name collisions with generated top-level functions require an aliased import (`as msgs`) to avoid infinite recursion.
- Verification per task: `flutter analyze` + `flutter test` (formularium, example, decimal, flutter — all are Flutter packages), `dart analyze`/`dart test` (formularium_localization).
- **Pre-staged by setup (do NOT edit pubspecs or run `pub get` unless the task says so):** all members have `resolution: workspace`; `formularium_localization` dep added to formularium/decimal/flutter; `intl_translation ^0.21.0` dev-dep added to formularium/decimal/flutter; workspace root overrides `listenable_plus`/`reef_utils` → `../my_packages/…`; `flutter: generate: true` removed from formularium/decimal/flutter by the controller (single `pub get` already run).
- **Parallel-agents ruling:** the controller dispatches implementers in parallel only across disjoint packages with zero pubspec/pub-get overlap (waves per Execution order); every `pub get` is controller-serialized.

## Execution order (wave structure)

- Wave 0 (parallel): Task 1 ∥ Task 2
- Wave 1 (parallel): Task 3 ∥ Task 6 ∥ Task 7
- Task 4 (needs Task 3)
- Task 8 (needs Task 4) — must precede Task 5 (example still imports the generated code Task 5 deletes)
- Task 5 (needs Task 4 + 8)
- Task 9 (needs 5 + 8)

---

### Task 1: `formularium_localization` package

**Files:**
- Create: `packages/formularium_localization/lib/formularium_localization.dart`, `lib/src/localizable.dart`, `lib/src/current_l10n.dart`
- Test: `packages/formularium_localization/test/current_l10n_test.dart`
- (pubspec already exists — do not modify)

**Interfaces:**
- Produces: `abstract interface class ILocalizable { String localize(); }` and `class CurrentL10n<T> { CurrentL10n(T Function() resolve); T get value; set value(T v); void reset(); }` — every later task consumes these exact names.

- [ ] **Step 1: Write failing test**

```dart
// test/current_l10n_test.dart
import 'package:formularium_localization/formularium_localization.dart';
import 'package:test/test.dart';

void main() {
  group('CurrentL10n', () {
    test('resolves from resolve() when no override', () {
      final holder = CurrentL10n<String>(() => 'resolved');
      expect(holder.value, 'resolved');
    });
    test('returns override when set', () {
      final holder = CurrentL10n<String>(() => 'resolved')..value = 'overridden';
      expect(holder.value, 'overridden');
    });
    test('reset() returns to resolve()', () {
      final holder = CurrentL10n<String>(() => 'resolved')..value = 'overridden';
      holder.reset();
      expect(holder.value, 'resolved');
    });
    test('ILocalizable localizes with no arguments', () {
      expect(const Fake().localize(), 'fake');
    });
  });
}

class Fake implements ILocalizable {
  const Fake();
  @override
  String localize() => 'fake';
}
```

- [ ] **Step 2:** `dart test` → FAIL (sources don't exist yet)
- [ ] **Step 3: Implement**

```dart
// lib/src/localizable.dart
/// Contrato de localização do ecossistema formularium.
///
/// A resolução é feita sem BuildContext: o locale corrente vive em
/// `Intl.defaultLocale`, sincronizado pelo delegate de cada pacote consumidor.
library;

/// Algo que pode ser localizado.
abstract interface class ILocalizable {
  /// Localiza esta mensagem usando o locale corrente.
  String localize();
}
```

```dart
// lib/src/current_l10n.dart
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
```

```dart
// lib/formularium_localization.dart
export 'src/current_l10n.dart';
export 'src/localizable.dart';
```

- [ ] **Step 4:** `dart test` → PASS; `dart analyze` → clean

---

### Task 2: formularium — intl_translation codegen

**Files:**
- Create: `packages/formularium/lib/l10n/intl_messages.dart` (seed; rewritten by generator)
- Generated: `lib/l10n/messages_all.dart`, `messages_en.dart`, `messages_pt.dart`
- Test: `packages/formularium/test/src/l10n/messages_smoke_test.dart`

**Interfaces:**
- Produces: top-level snake_case message functions/getters in `intl_messages.dart` (one per ARB key) and `Future initializeMessages(String localeName)` from `messages_all.dart`. Task 3 consumes both.

- [ ] **Step 1: Author seed** — one function per key in `lib/l10n/arb/app_pt.arb`, pt string as default. Rule: key `k` with pt string `S` and placeholders `P` → `k(P…) => Intl.message('S-with-{p}→$p', name: 'k', args: […])`; getters for zero-arg keys. Pattern (first three, continue for all ~90 keys):

```dart
import 'package:intl/intl.dart';

String date_time_field_before(String date) => Intl.message(
  'Deve ser antes de $date',
  name: 'date_time_field_before',
  args: [date],
  desc: 'Data deve ser anterior à data de referência',
);

String get validation_not_a_number => Intl.message(
  'Não é um número válido',
  name: 'validation_not_a_number',
  desc: 'Entrada não é um número',
);

String validation_invalid_email(String value) => Intl.message(
  '"$value" não é um email válido',
  name: 'validation_invalid_email',
  args: [value],
  desc: 'Email inválido',
);
```

- [ ] **Step 2:** `dart run intl_translation:extract_to_arb --output-dir=lib/l10n/arb lib/l10n/intl_messages.dart` — verify `app_pt.arb` keeps the same key set (extraction merges; no keys lost).
- [ ] **Step 3:** `dart run intl_translation:generate_from_arb --output-dir=lib/l10n lib/l10n/intl_messages.dart lib/l10n/arb/app_pt.arb lib/l10n/arb/app_en.arb` — verify `messages_all.dart` + `messages_pt.dart` + `messages_en.dart` exist.
- [ ] **Step 4: Smoke test**

```dart
// test/src/l10n/messages_smoke_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:formularium/l10n/messages_all.dart';
import 'package:formularium/l10n/intl_messages.dart';

void main() {
  test('pt (template) messages resolve', () async {
    Intl.defaultLocale = 'pt';
    await initializeMessages('pt');
    expect(validation_not_a_number, 'Não é um número válido');
  });
  test('en messages resolve', () async {
    Intl.defaultLocale = 'en';
    await initializeMessages('en');
    expect(validation_not_a_number, 'Not a valid number');
  });
}
```

Run: `flutter test test/src/l10n/messages_smoke_test.dart` → PASS.

---

### Task 3: formularium — pure-Dart localization layer + Flutter adapter

**Files:**
- Rewrite: `packages/formularium/lib/features/validators/_interfaces/formularium_localizations.dart` (keep `IFormulariumLocalizations` verbatim; DELETE `extension FormulariumL10n on IContext` + concierge import; the old `FormulariumLocalizations` bridge + `_FormulariumLocalizationsDelegate` move out)
- Create: `packages/formularium/lib/features/validators/_interfaces/formularium_localizations_delegate.dart`
- Test: `packages/formularium/test/src/features/validators/f_l10n_resolution_test.dart`

**Interfaces:**
- Consumes: Task 1 `CurrentL10n`, Task 2 message fns.
- Produces: `IFormulariumLocalizations get fL10n`, `set fL10n(IFormulariumLocalizations)`, `void resetF10n()`, `Future<void> initFormulariumL10n([String? locale])`, `class FormulariumLocalizationsDelegate extends LocalizationsDelegate<IFormulariumLocalizations>` (const ctor).

⚠️ **This task temporarily breaks the 8 validator `_data_types` files** (they still call `context.fL10n` via the deleted extension and implement old-shape `localize(IContext)`). That is EXPECTED: Task 4 fixes them. Do NOT migrate validators here. The full-suite test run in this task will fail on those files — the PASS criterion is: `flutter analyze` errors are confined to the 8 `_data_types` files + test files that use `MockContext`/`mockContext`, and the new resolution test passes.

- [ ] **Step 1: Failing test**

```dart
// test/src/features/validators/f_l10n_resolution_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';

void main() {
  tearDown(resetF10n);
  test('en resolves via Intl.defaultLocale', () async {
    await initFormulariumL10n('en');
    expect(fL10n.validation_not_a_number, 'Not a valid number');
  });
  test('pt resolves', () async {
    await initFormulariumL10n('pt');
    expect(fL10n.validation_not_a_number, 'Não é um número válido');
  });
  test('test override hook works', () async {
    await initFormulariumL10n('en');
    fL10n = _FixedL10n();
    expect(fL10n.validation_not_a_number, 'fixed');
    resetF10n();
    expect(fL10n.validation_not_a_number, 'Not a valid number');
  });
}

class _FixedL10n implements IFormulariumLocalizations {
  @override
  dynamic noSuchMethod(Invocation i) => 'fixed';
}
```

- [ ] **Step 2: Implement** — in `formularium_localizations.dart`: keep `IFormulariumLocalizations` unchanged; remove `import 'package:concierge/context_interface.dart'`, `import 'package:flutter/widgets.dart'`, the generated-`app_localizations.dart` import, the `FormulariumLocalizations` bridge class, and the `_FormulariumLocalizationsDelegate`; add (⚠️ aliased import — getters must not recurse):

```dart
import 'package:formularium/l10n/intl_messages.dart' as msgs;
import 'package:formularium/l10n/messages_all.dart' show initializeMessages;
import 'package:formularium_localization/formularium_localization.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;
import 'package:intl/intl.dart';

/// Implementação pura em Dart sobre as mensagens geradas pelo intl_translation.
class FormulariumMessages implements IFormulariumLocalizations {
  const FormulariumMessages();

  @override
  String get validation_not_a_number => msgs.validation_not_a_number;
  @override
  String validation_invalid_email(String value) => msgs.validation_invalid_email(value);
  // ... uma linha por método, delegando ao mesmo nome em `msgs` (90 métodos) ...
  @override
  String get localeName => Intl.getCurrentLocale();
}

final CurrentL10n<IFormulariumLocalizations> _current = CurrentL10n(const FormulariumMessages);

/// Mensagens do formularium no locale corrente (`Intl.defaultLocale`).
IFormulariumLocalizations get fL10n => _current.value;
set fL10n(IFormulariumLocalizations v) => _current.value = v;
void resetF10n() => _current.reset();

/// Inicializa intl (mensagens + símbolos de data) para uso sem Flutter.
Future<void> initFormulariumL10n([String? locale]) async {
  final loc = locale ?? Intl.defaultLocale ?? 'en';
  Intl.defaultLocale = loc;
  await initializeMessages(loc);
  await initializeDateFormatting(loc);
}
```

Delegate adapter (the ONLY flutter-importing l10n file):

```dart
// formularium_localizations_delegate.dart
import 'package:flutter/widgets.dart';
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:intl/intl.dart';

/// Sincroniza o locale do MaterialApp com `Intl.defaultLocale`.
class FormulariumLocalizationsDelegate
    extends LocalizationsDelegate<IFormulariumLocalizations> {
  const FormulariumLocalizationsDelegate();

  @override
  Future<IFormulariumLocalizations> load(Locale locale) async {
    await initFormulariumL10n(Intl.canonicalizedLocale(locale.toString()));
    return fL10n;
  }

  @override
  bool isSupported(Locale locale) =>
      const ['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(covariant FormulariumLocalizationsDelegate old) => false;
}
```

- [ ] **Step 3:** `flutter test test/src/features/validators/f_l10n_resolution_test.dart` → PASS. `flutter analyze` → errors confined to the 8 `_data_types` files + `test/src/helpers/*` + tests calling `.localize(context)` (documented, fixed by Task 4).

---

### Task 4: formularium — validators, `ILocalizable`, and tests migration

**Files:**
- Modify: `lib/features/localization/localizable_interface.dart`, `lib/formularium.dart`, all 8 `lib/features/validators/_data_types/*_validation.dart`, `test/src/helpers/mocks.dart`, `test/src/helpers/test_utils.dart`, and the 10 test files listed in Step 6.

**Interfaces:**
- Consumes: new `ILocalizable` (Task 1), `fL10n`/`resetF10n` (Task 3).

- [ ] **Step 1:** `localizable_interface.dart` → `export 'package:formularium_localization/formularium_localization.dart';` (keeps every `forms/` import working against the new no-arg interface).
- [ ] **Step 2:** `formularium.dart` barrel: replace `export 'package:formularium/l10n/generated/app_localizations.dart';` with `export 'package:formularium/features/validators/_interfaces/formularium_localizations_delegate.dart';`.
- [ ] **Step 3: Mechanical rule, all 8 `_data_types` files** — (a) delete `import 'package:concierge/context_interface.dart';`; (b) `String localize(IContext context)` → `String localize()`; (c) `context.fL10n` → `fL10n`; (d) in `date_time_validation.dart` only: `final l10n = context.fL10n;` → `final l10n = fL10n;`. Exact new bodies for `string_validation.dart` (all one-liners; other files follow the same rule):

```dart
String localize() => fL10n.validation_not_a_boolean(value);
String localize() => fL10n.validation_invalid_port(value);
String localize() => fL10n.validation_invalid_url(value);
String localize() => fL10n.validation_invalid_lat_long(value);
String localize() => fL10n.validation_invalid_email(value);
String localize() => fL10n.validation_invalid_uuid(version);
String localize() => fL10n.validation_invalid_semver(value);
String localize() => fL10n.validation_invalid_jwt(value);
String localize() => fL10n.validation_invalid_slug(value);
String localize() => fL10n.validation_not_base64(value);
String localize() => fL10n.validation_invalid_mime_type(value);
String localize() => fL10n.validation_invalid_locale(value);
String localize() => fL10n.validation_invalid_credit_card(provider);
String localize() => fL10n.validation_weak_password(score, minScore);
String localize() => fL10n.validation_invalid_mongo_id(value);
String localize() => fL10n.validation_invalid_hash(algorithm);
String localize() => fL10n.validation_invalid_imei(value);
String localize() => fL10n.validation_invalid_phone(value);
String localize() => fL10n.validation_invalid_json(value);
String localize() => fL10n.validation_invalid_mac_address(value);
String localize() => fL10n.validation_not_octal;
String localize() => fL10n.validation_byte_length_exceeded(min, max);
String localize() => fL10n.validation_not_multibyte;
String localize() => fL10n.validation_not_full_width;
String localize() => fL10n.validation_not_half_width;
String localize() => fL10n.validation_not_variable_width;
String localize() => fL10n.validation_not_surrogate_pair;
String localize() => fL10n.validation_invalid_ip(value);
String localize() => fL10n.validation_invalid_postal_code(value);
String localize() => fL10n.validation_invalid_isbn(value);
String localize() => fL10n.validation_invalid_ean(value);
String localize() => fL10n.validation_invalid_base32(value);
String localize() => fL10n.validation_invalid_base58(value);
String localize() => fL10n.validation_not_alphanumeric;
String localize() => fL10n.validation_not_alpha;
String localize() => fL10n.validation_not_ascii;
String localize() => fL10n.validation_not_numeric(noSymbols);
String localize() => fL10n.validation_not_hexadecimal;
String localize() => fL10n.validation_not_lowercase;
String localize() => fL10n.validation_not_uppercase;
String localize() => fL10n.validation_string_length_exceeded(min, max);
String localize() => fL10n.validation_string_length_mismatch(discrete);
String localize() => fL10n.validation_pattern_mismatch(pattern);
String localize() => fL10n.validation_not_in_list;
String localize() => fL10n.validation_must_contain(seed);
String localize() => fL10n.validation_must_equal(comparison);
```

Other files: `number_validation.dart` (6 bodies: `number_field_value_too_big(maxValue.toString())`, `number_field_value_too_small(minValue.toString())`, `validation_not_a_number`, `number_field_not_divisible(divisor.toString())`, `number_field_not_positive`, `number_field_not_negative`), `boolean_validation.dart` (1: `validation_not_a_boolean(value)`), `lat_long_validation.dart` (1: `validation_invalid_lat_long(value)`), `uri_validation.dart` (1: `validation_invalid_url(value)`), `not_null_validation.dart` (1: `required_field_label`), `time_validation.dart` (1: `validation_invalid_time(value, hourFormat, mode)`), `date_time_validation.dart` (6: the 4 date ones keep the `final l10n = fL10n; … reference.localize(l10n, pattern: format?.toDateFormat.pattern)` pattern; plus `date_invalid` and `validation_invalid_time(value, hourFormat, mode)`).

- [ ] **Step 4:** `test/src/helpers/mocks.dart` → replace whole file:

```dart
import 'package:formularium/features/validators/_interfaces/formularium_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockL10n extends Mock implements IFormulariumLocalizations {}

/// Injeta [l10n] como localizações correntes do formularium para o teste.
void mockL10n(MockL10n l10n) => fL10n = l10n;
```

- [ ] **Step 5:** `test/src/helpers/test_utils.dart`: `TestValidation.localize(IContext context)` → `String localize() => name;`; delete concierge import.
- [ ] **Step 6:** in the 10 test files (`boolean_validation_test.dart`, `number_validation_test.dart`, `string_validation_test.dart`, `date_time_validation_test.dart`, `date_time_localizations_test.dart`, `uri_validation_test.dart`, `lat_long_validation_test.dart`, `time_validation_test.dart`, `not_null_validation_test.dart`, `form_field_data_types_test.dart`): rule — delete `MockContext`/`mockContext` usage and `late MockContext context;` fields; `mockContext(l10n)` → `addTearDown(resetF10n); mockL10n(l10n);`; `v.localize(context)` → `v.localize()`. Example (boolean):

```dart
test('NotABoolean localize', () async {
  final l10n = MockL10n();
  when(() => l10n.validation_not_a_boolean('abc')).thenReturn('abc não é um booleano');
  addTearDown(resetF10n);
  mockL10n(l10n);
  expect(NotABoolean('abc').localize(), 'abc não é um booleano');
  verify(() => l10n.validation_not_a_boolean('abc')).called(1);
});
```

- [ ] **Step 7:** `flutter analyze` → only the pre-existing info-lints; `flutter test` (full suite) → PASS.

---

### Task 5: formularium — cleanup

**Files:** `pubspec.yaml`, `l10n.yaml` (delete), `lib/l10n/generated/` (delete), `lib/formularium.dart`, `lib/features/validators/_interfaces/formularium_localizations.dart` (verify no remnants).

**Interfaces:** Produces clean pubspec for Task 9's package deletion.

- [ ] **Step 1:** pubspec cleanup is **deferred to Task 9** (controller-managed, avoids concurrent pub get). Only verify: `grep -r "concierge|localization_interface|l10n/generated" lib test` → zero hits.
- [ ] **Step 2:** delete `l10n.yaml` and `lib/l10n/generated/`.
- [ ] **Step 3:** verify `formularium.dart` barrel no longer references `l10n/generated` (Task 4 replaced it) and `formularium_localizations.dart` has zero flutter/concierge imports.
- [ ] **Step 4:** `flutter analyze` + `flutter test` → clean/PASS.

---

### Task 6: formularium_decimal

**Files:** delete `l10n.yaml` + `lib/l10n/generated/`; Create `lib/l10n/intl_messages.dart`, `lib/src/decimal_localizations_delegate.dart`, `test/decimal_localizations_test.dart`; Rewrite `lib/src/decimal_localizations.dart`, `lib/src/decimal_validation.dart`; Modify `lib/formularium_decimal.dart`, `pubspec.yaml`.

**Interfaces:** Produces `IFormulariumDecimalLocalizations get fdL10n`, `set fdL10n`, `void resetFdL10n()`, `Future<void> initFormulariumDecimalL10n([String? locale])`, `FormulariumDecimalLocalizationsDelegate` (const).

- [ ] **Step 1: Failing integration test** (first test this package has; computes the number via `NumberFormat` itself so it asserts locale propagation + message selection, not intl's formatting internals):

```dart
// test/decimal_localizations_test.dart
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium_decimal/src/decimal_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  tearDown(resetFdL10n);
  test('en: too-big message resolves via Intl.defaultLocale', () async {
    await initFormulariumDecimalL10n('en');
    final formatted = NumberFormat.currency(locale: 'en', symbol: r'R$')
        .format(Decimal.parse('1234.56'));
    expect(fdL10n.decimal_field_value_too_big(formatted), 'Value greater than $formatted');
  });
  test('pt: too-small message', () async {
    await initFormulariumDecimalL10n('pt');
    final formatted = NumberFormat.currency(locale: 'pt', symbol: r'R$')
        .format(Decimal.parse('10'));
    expect(fdL10n.decimal_field_value_too_small(formatted), 'Valor menor que $formatted');
  });
}
```

- [ ] **Step 2:** delete `l10n.yaml` + `lib/l10n/generated/`; seed (complete file):

```dart
// lib/l10n/intl_messages.dart
import 'package:intl/intl.dart';

String decimal_field_value_too_big(String value) => Intl.message(
  'Valor maior que $value',
  name: 'decimal_field_value_too_big',
  args: [value],
  desc: 'Valor decimal excedeu o máximo',
);

String decimal_field_value_too_small(String value) => Intl.message(
  'Valor menor que $value',
  name: 'decimal_field_value_too_small',
  args: [value],
  desc: 'Valor decimal abaixo do mínimo',
);
```

- [ ] **Step 3:** codegen (same two `intl_translation` commands, this package's dirs).
- [ ] **Step 4: Rewrite `decimal_localizations.dart`** — pure Dart, same structure as Task 3 (⚠️ aliased import `as msgs`): `IFormulariumDecimalLocalizations` unchanged; `FormulariumDecimalMessages implements …` (2 methods + `localeName => Intl.getCurrentLocale()`); `_current`/`fdL10n`/setter/`resetFdL10n()`/`initFormulariumDecimalL10n` (same body as `initFormulariumL10n`); **zero flutter imports**; delegate file mirrors `FormulariumLocalizationsDelegate` with `['en','pt']` and type `LocalizationsDelegate<IFormulariumDecimalLocalizations>`.
- [ ] **Step 5: `decimal_validation.dart`** — imports: drop concierge, `localization_interface` → `formularium_localization`; bodies:

```dart
@override
String localize() {
  final fd = fdL10n;
  final formatted = NumberFormat.currency(locale: fd.localeName, symbol: r'R$').format(maxValue);
  return fd.decimal_field_value_too_big(formatted);
}
```

(same shape for `DecimalTooSmall` with `decimal_field_value_too_small`).
- [ ] **Step 6:** pubspec cleanup is **deferred to Task 9** (controller-managed).
- [ ] **Step 7:** barrel `lib/formularium_decimal.dart`: replace any `l10n/generated/app_localizations.dart` export with the delegate export. `flutter analyze` + `flutter test` → clean/PASS.

---

### Task 7: formularium_flutter

**Files:** delete `l10n.yaml` + `lib/l10n/generated/`; Create `lib/l10n/intl_messages.dart` + `lib/src/color_localizations_delegate.dart` + `test/color_localizations_test.dart`; Rewrite `lib/src/color_localizations.dart`, `lib/src/color_validation.dart`; Modify `lib/formularium_flutter.dart`, `pubspec.yaml`.

**Interfaces:** Produces `IFormulariumFlutterLocalizations get ffL10n`, `set ffL10n`, `void resetFfL10n()`, `Future<void> initFormulariumFlutterL10n([String? locale])`, `FormulariumFlutterLocalizationsDelegate` (const).

- [ ] **Step 1: Data fix (mojibake):** in the seed below, the corrected pt string is `"{value}" não é uma cor válida` (the ARB file has corrupted diacritics `"nǜo Ǹ uma cor vǭlida"` — do NOT copy that; also fix `lib/l10n/arb/app_pt.arb` to the corrected string so extraction stays consistent).
- [ ] **Step 2: Failing test:**

```dart
// test/color_localizations_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:formularium_flutter/src/color_localizations.dart';

void main() {
  tearDown(resetFfL10n);
  test('en resolves', () async {
    await initFormulariumFlutterL10n('en');
    expect(ffL10n.validation_invalid_color('red'), '"red" is not a valid color');
  });
  test('pt resolves', () async {
    await initFormulariumFlutterL10n('pt');
    expect(ffL10n.validation_invalid_color('red'), '"red" não é uma cor válida');
  });
}
```

- [ ] **Step 3:** delete `l10n.yaml` + `lib/l10n/generated/`; seed:

```dart
// lib/l10n/intl_messages.dart
import 'package:intl/intl.dart';

String validation_invalid_color(String value) => Intl.message(
  '"$value" não é uma cor válida',
  name: 'validation_invalid_color',
  args: [value],
  desc: 'Cor inválida',
);
```

then extract + generate.
- [ ] **Step 4:** rewrite `color_localizations.dart` pure-Dart (`FormulariumFlutterMessages implements IFormulariumFlutterLocalizations`, `ffL10n` global via `CurrentL10n`, setter, `resetFfL10n()`, `initFormulariumFlutterL10n`, zero flutter imports, ⚠️ aliased import `as msgs`) + delegate file (mirror Task 3, type `LocalizationsDelegate<IFormulariumFlutterLocalizations>`, `['en','pt']`).
- [ ] **Step 5:** `color_validation.dart`: `String localize() => ffL10n.validation_invalid_color(value);`, drop concierge import, `localization_interface` → `formularium_localization`.
- [ ] **Step 6:** pubspec cleanup is **deferred to Task 9** (controller-managed).
- [ ] **Step 7:** barrel: replace generated export with delegate export. `flutter analyze` + `flutter test` → clean/PASS.

---

### Task 8: example app

**Files:** `packages/formularium/example/pubspec.yaml`; delete `example/lib/localizations.dart`; modify `example/lib/widgets.dart`, `example/lib/examples/09_async_validation.dart`, `example/lib/main.dart`.

**Interfaces:** Consumes `FormulariumLocalizationsDelegate`, no-arg `localize()`.

- [ ] **Step 1:** delete `localizations.dart` (`AppContext` is dead).
- [ ] **Step 2:** `widgets.dart`: delete concierge import, the `AppContext` construction, and the generated `app_localizations.dart` import; `_extractError` loses its context param:

```dart
String? _extractError(FormFieldStatus<Transformed> status) => switch (status) {
  Invalid(:final validation) => validation.validation.localize(),
  Valid(:final validation) when validation != null => validation.validation.localize(),
  _ => null,
};
```

call sites updated accordingly.
- [ ] **Step 3:** `09_async_validation.dart`: `UsernameTaken`/`EmailTaken` → `String localize() => '…';` (strings unchanged), drop concierge import, `localization_interface` → `package:formularium/formularium.dart` (or `formularium_localization`).
- [ ] **Step 4:** `main.dart` delegates:

```dart
localizationsDelegates: const [
  FormulariumLocalizationsDelegate(),
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],
```

- [ ] **Step 5:** pubspec cleanup is **deferred to Task 9** (controller-managed; the example ends up needing NO `intl` dep — custom messages are plain strings). 
- [ ] **Step 6:** `flutter analyze` (in example) → clean.

---

### Task 9: Pubspec cleanup + remove old packages + global verification + CHANGELOGs

**Files:** delete `packages/concierge/`, `packages/localization_interface/`; root `pubspec.yaml`; member pubspecs (formularium, formularium_decimal, formularium_flutter, example); `CHANGELOG.md` in formularium, formularium_decimal, formularium_flutter.

**Interfaces:** Produces the final workspace state.

- [ ] **Step 1 (controller):** pubspec cleanup across the monorepo — formularium: remove deps `concierge`, `localization_interface`, `flutter_localizations` + the `flutter: generate: true` section; formularium_decimal + formularium_flutter: remove deps `concierge`, `localization_interface`, `flutter_localizations` + `flutter: generate: true`; example: remove deps `concierge`, `localization_interface` (keep `flutter_localizations`); root `pubspec.yaml`: remove `packages/concierge` + `packages/localization_interface` from `workspace:`; delete `packages/concierge/` + `packages/localization_interface/`. Then `flutter pub get` at root.
- [ ] **Step 2:** `grep -r "concierge|localization_interface|l10n/generated|generate: true" packages docs --include=*.dart --include=*.yaml` → zero hits.
- [ ] **Step 3:** full matrix: formularium + example + decimal + flutter: `flutter analyze` + `flutter test`; formularium_localization: `dart analyze` + `dart test`. All green.
- [ ] **Step 4:** CHANGELOG `0.1.0` entries in the three packages containing the third-party migration: (1) import `package:formularium_localization/…`; (2) `localize(IContext)` → `localize()`; (3) resolve via `fL10n`/`fdL10n`/`ffL10n` globals or `Intl.message`; (4) call sites drop the context argument; delegates renamed to `FormulariumLocalizationsDelegate` / `FormulariumDecimalLocalizationsDelegate` / `FormulariumFlutterLocalizationsDelegate`.
