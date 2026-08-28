import 'package:flutter/foundation.dart';
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/form_field_status_utils.dart';
import 'package:formularium/features/forms/_interfaces/form_entity_interface.dart';
import 'package:formularium/features/forms/_interfaces/form_field_interface.dart';
import 'package:listenable_plus/features/combine/implementations/combine_value_notifier.dart';

/// Uma implementação de forms que não depende do Flutter, é simples
/// e tem uma interface mais robusta.
/// Grupo de campos que se comporta como entidade única.
///
/// Agrega múltiplos campos e valida todos em conjunto.
/// Resultado combinado via valueTransformer em valor único [T].
class Formularium<T> implements IFormEntity<T> {
  /// Cria [Formularium] a partir de lista de campos.
  ///
  /// [fields] deve manter ordem consistente com [valueTransformer].
  /// Cada campo validado tem seu valor transformado passado na posição correspondente da lista.
  factory Formularium.list({
    required T Function(List<dynamic> values) valueTransformer,
    required List<IFormField<dynamic, dynamic>> fields,
    bool enabled = true,
  }) {
    final $enabled = ValueNotifier<bool>(enabled);
    final wrapped = fields
        .map(
          (f) => GroupFormulariumField(
            field: f,
            groupEnabled: $enabled,
          ),
        )
        .toList();

    final $state = CombineLatestValueNotifier.combine(
      wrapped.map((field) => field.$state).toList(),
      (states) {
        for (final state in states) {
          if (state == FormFieldState.dirty) {
            return FormFieldState.dirty;
          }
        }
        return FormFieldState.pure;
      },
    );

    final $status = CombineLatestValueNotifier.combine(
      wrapped.map((field) => field.$status).toList(),
      (statuses) => combineFieldStatuses(statuses: statuses, valueTransformer: valueTransformer),
    );

    return Formularium._(fields: wrapped, $enabled: $enabled, $state: $state, $status: $status);
  }

  Formularium._({required this._fields, required this._$enabled, required this._$status, required this._$state});

  final List<GroupFormulariumField<dynamic, dynamic>> _fields;

  final ValueNotifier<bool> _$enabled;

  @override
  bool get enabled => _$enabled.value;

  @override
  ValueNotifier<bool> get $enabled => _$enabled;
  @override
  set enabled(bool enabled) => _$enabled.value = enabled;

  final CombineLatestValueNotifier<FormFieldState> _$state;
  @override
  ValueListenable<FormFieldState> get $state => _$state;
  @override
  FormFieldState get state => $state.value;

  final CombineLatestValueNotifier<FormFieldStatus<T>> _$status;

  @override
  ValueListenable<FormFieldStatus<T>> get $status => _$status;
  @override
  FormFieldStatus<T> get status => $status.value;

  @override
  FormFieldStatus<T> validate() {
    for (final field in _fields) {
      field.validate();
    }
    return $status.value;
  }

  @override
  FormFieldStatus<T> validateDirty() {
    for (final field in _fields) {
      if (field.state == FormFieldState.dirty) {
        field.validate();
      }
    }
    return $status.value;
  }

  /// Cria [Formularium] com 1 campo.
  static Formularium<Combined> form1<A, TransformedA, Combined>({
    required IFormField<A, TransformedA> first,
    required Combined Function(TransformedA value) valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(list[0] as TransformedA),
    );

    return formularium;
  }

  /// Cria [Formularium] com 2 campos.
  static Formularium<Combined> form2<A, TransformedA, B, TransformedB, Combined>({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required Combined Function(TransformedA first, TransformedB second) valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first, second],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(list[0] as TransformedA, list[1] as TransformedB),
    );
    return formularium;
  }

  /// Cria [Formularium] com 3 campos.
  static Formularium<Combined> form3<A, TransformedA, B, TransformedB, C, TransformedC, Combined>({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required IFormField<C, TransformedC> third,
    required Combined Function(TransformedA, TransformedB, TransformedC) valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first, second, third],
      enabled: enabled,
      valueTransformer: (list) =>
          valueCombiner(list[0] as TransformedA, list[1] as TransformedB, list[2] as TransformedC),
    );
    return formularium;
  }

  /// Cria [Formularium] com 4 campos.
  static Formularium<Combined> form4<A, TransformedA, B, TransformedB, C, TransformedC, D, TransformedD, Combined>({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required IFormField<C, TransformedC> third,
    required IFormField<D, TransformedD> fourth,
    required Combined Function(TransformedA, TransformedB, TransformedC, TransformedD) valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first, second, third, fourth],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(
        list[0] as TransformedA,
        list[1] as TransformedB,
        list[2] as TransformedC,
        list[3] as TransformedD,
      ),
    );
    return formularium;
  }

  /// Cria [Formularium] com 5 campos.
  static Formularium<Combined>
  form5<A, TransformedA, B, TransformedB, C, TransformedC, D, TransformedD, E, TransformedE, Combined>({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required IFormField<C, TransformedC> third,
    required IFormField<D, TransformedD> fourth,
    required IFormField<E, TransformedE> fifth,
    required Combined Function(TransformedA, TransformedB, TransformedC, TransformedD, TransformedE) valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first, second, third, fourth, fifth],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(
        list[0] as TransformedA,
        list[1] as TransformedB,
        list[2] as TransformedC,
        list[3] as TransformedD,
        list[4] as TransformedE,
      ),
    );
    return formularium;
  }

  /// Cria [Formularium] com 6 campos.
  static Formularium<Combined> form6<
    A,
    TransformedA,
    B,
    TransformedB,
    C,
    TransformedC,
    D,
    TransformedD,
    E,
    TransformedE,
    F,
    TransformedF,
    Combined
  >({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required IFormField<C, TransformedC> third,
    required IFormField<D, TransformedD> fourth,
    required IFormField<E, TransformedE> fifth,
    required IFormField<F, TransformedF> sixth,
    required Combined Function(
      TransformedA,
      TransformedB,
      TransformedC,
      TransformedD,
      TransformedE,
      TransformedF,
    )
    valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first, second, third, fourth, fifth, sixth],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(
        list[0] as TransformedA,
        list[1] as TransformedB,
        list[2] as TransformedC,
        list[3] as TransformedD,
        list[4] as TransformedE,
        list[5] as TransformedF,
      ),
    );
    return formularium;
  }

  /// Cria [Formularium] com 7 campos.
  static Formularium<Combined> form7<
    A,
    TransformedA,
    B,
    TransformedB,
    C,
    TransformedC,
    D,
    TransformedD,
    E,
    TransformedE,
    F,
    TransformedF,
    G,
    TransformedG,
    Combined
  >({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required IFormField<C, TransformedC> third,
    required IFormField<D, TransformedD> fourth,
    required IFormField<E, TransformedE> fifth,
    required IFormField<F, TransformedF> sixth,
    required IFormField<G, TransformedG> seventh,
    required Combined Function(
      TransformedA,
      TransformedB,
      TransformedC,
      TransformedD,
      TransformedE,
      TransformedF,
      TransformedG,
    )
    valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first, second, third, fourth, fifth, sixth, seventh],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(
        list[0] as TransformedA,
        list[1] as TransformedB,
        list[2] as TransformedC,
        list[3] as TransformedD,
        list[4] as TransformedE,
        list[5] as TransformedF,
        list[6] as TransformedG,
      ),
    );
    return formularium;
  }

  /// Cria [Formularium] com 8 campos.
  static Formularium<Combined> form8<
    A,
    TransformedA,
    B,
    TransformedB,
    C,
    TransformedC,
    D,
    TransformedD,
    E,
    TransformedE,
    F,
    TransformedF,
    G,
    TransformedG,
    H,
    TransformedH,
    Combined
  >({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required IFormField<C, TransformedC> third,
    required IFormField<D, TransformedD> fourth,
    required IFormField<E, TransformedE> fifth,
    required IFormField<F, TransformedF> sixth,
    required IFormField<G, TransformedG> seventh,
    required IFormField<H, TransformedH> eighth,
    required Combined Function(
      TransformedA,
      TransformedB,
      TransformedC,
      TransformedD,
      TransformedE,
      TransformedF,
      TransformedG,
      TransformedH,
    )
    valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first, second, third, fourth, fifth, sixth, seventh, eighth],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(
        list[0] as TransformedA,
        list[1] as TransformedB,
        list[2] as TransformedC,
        list[3] as TransformedD,
        list[4] as TransformedE,
        list[5] as TransformedF,
        list[6] as TransformedG,
        list[7] as TransformedH,
      ),
    );
    return formularium;
  }

  /// Cria [Formularium] com 9 campos.
  static Formularium<Combined> form9<
    A,
    TransformedA,
    B,
    TransformedB,
    C,
    TransformedC,
    D,
    TransformedD,
    E,
    TransformedE,
    F,
    TransformedF,
    G,
    TransformedG,
    H,
    TransformedH,
    I,
    TransformedI,
    Combined
  >({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required IFormField<C, TransformedC> third,
    required IFormField<D, TransformedD> fourth,
    required IFormField<E, TransformedE> fifth,
    required IFormField<F, TransformedF> sixth,
    required IFormField<G, TransformedG> seventh,
    required IFormField<H, TransformedH> eighth,
    required IFormField<I, TransformedI> ninth,
    required Combined Function(
      TransformedA,
      TransformedB,
      TransformedC,
      TransformedD,
      TransformedE,
      TransformedF,
      TransformedG,
      TransformedH,
      TransformedI,
    )
    valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first, second, third, fourth, fifth, sixth, seventh, eighth, ninth],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(
        list[0] as TransformedA,
        list[1] as TransformedB,
        list[2] as TransformedC,
        list[3] as TransformedD,
        list[4] as TransformedE,
        list[5] as TransformedF,
        list[6] as TransformedG,
        list[7] as TransformedH,
        list[8] as TransformedI,
      ),
    );
    return formularium;
  }

  /// Cria [Formularium] com 10 campos.
  static Formularium<Combined> form10<
    A,
    TransformedA,
    B,
    TransformedB,
    C,
    TransformedC,
    D,
    TransformedD,
    E,
    TransformedE,
    F,
    TransformedF,
    G,
    TransformedG,
    H,
    TransformedH,
    I,
    TransformedI,
    J,
    TransformedJ,
    Combined
  >({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required IFormField<C, TransformedC> third,
    required IFormField<D, TransformedD> fourth,
    required IFormField<E, TransformedE> fifth,
    required IFormField<F, TransformedF> sixth,
    required IFormField<G, TransformedG> seventh,
    required IFormField<H, TransformedH> eighth,
    required IFormField<I, TransformedI> ninth,
    required IFormField<J, TransformedJ> tenth,
    required Combined Function(
      TransformedA,
      TransformedB,
      TransformedC,
      TransformedD,
      TransformedE,
      TransformedF,
      TransformedG,
      TransformedH,
      TransformedI,
      TransformedJ,
    )
    valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(
        list[0] as TransformedA,
        list[1] as TransformedB,
        list[2] as TransformedC,
        list[3] as TransformedD,
        list[4] as TransformedE,
        list[5] as TransformedF,
        list[6] as TransformedG,
        list[7] as TransformedH,
        list[8] as TransformedI,
        list[9] as TransformedJ,
      ),
    );
    return formularium;
  }

  /// Cria [Formularium] com 15 campos.
  static Formularium<Combined> form15<
    A,
    TransformedA,
    B,
    TransformedB,
    C,
    TransformedC,
    D,
    TransformedD,
    E,
    TransformedE,
    F,
    TransformedF,
    G,
    TransformedG,
    H,
    TransformedH,
    I,
    TransformedI,
    J,
    TransformedJ,
    K,
    TransformedK,
    L,
    TransformedL,
    M,
    TransformedM,
    N,
    TransformedN,
    O,
    TransformedO,
    Combined
  >({
    required IFormField<A, TransformedA> first,
    required IFormField<B, TransformedB> second,
    required IFormField<C, TransformedC> third,
    required IFormField<D, TransformedD> fourth,
    required IFormField<E, TransformedE> fifth,
    required IFormField<F, TransformedF> sixth,
    required IFormField<G, TransformedG> seventh,
    required IFormField<H, TransformedH> eighth,
    required IFormField<I, TransformedI> ninth,
    required IFormField<J, TransformedJ> tenth,
    required IFormField<K, TransformedK> eleventh,
    required IFormField<L, TransformedL> twelfth,
    required IFormField<M, TransformedM> thirteenth,
    required IFormField<N, TransformedN> fourteenth,
    required IFormField<O, TransformedO> fifteenth,
    required Combined Function(
      TransformedA,
      TransformedB,
      TransformedC,
      TransformedD,
      TransformedE,
      TransformedF,
      TransformedG,
      TransformedH,
      TransformedI,
      TransformedJ,
      TransformedK,
      TransformedL,
      TransformedM,
      TransformedN,
      TransformedO,
    )
    valueCombiner,
    bool enabled = true,
  }) {
    final formularium = Formularium.list(
      fields: [
        first,
        second,
        third,
        fourth,
        fifth,
        sixth,
        seventh,
        eighth,
        ninth,
        tenth,
        eleventh,
        twelfth,
        thirteenth,
        fourteenth,
        fifteenth,
      ],
      enabled: enabled,
      valueTransformer: (list) => valueCombiner(
        list[0] as TransformedA,
        list[1] as TransformedB,
        list[2] as TransformedC,
        list[3] as TransformedD,
        list[4] as TransformedE,
        list[5] as TransformedF,
        list[6] as TransformedG,
        list[7] as TransformedH,
        list[8] as TransformedI,
        list[9] as TransformedJ,
        list[10] as TransformedK,
        list[11] as TransformedL,
        list[12] as TransformedM,
        list[13] as TransformedN,
        list[14] as TransformedO,
      ),
    );

    return formularium;
  }

  /// Libera recursos do formulário.
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    _$enabled.dispose();
    _$status.dispose();
    _$state.dispose();
  }

  @override
  void reset() {
    for (final field in _fields) {
      field.reset();
    }
  }

  @override
  void clear() {
    for (final field in _fields) {
      field.clear();
    }
  }
}

/// Wrapper que combina enabled do form com enabled do campo.
///
/// Usado internamente por [Formularium] para propagar o enabled do grupo
/// para cada campo. O enabled final é: grupo && campo.
class GroupFormulariumField<T, Transformed> implements IFormEntity<Transformed> {
  GroupFormulariumField({
    required this._field,
    required this._groupEnabled,
  });

  final IFormField<T, Transformed> _field;
  final ValueNotifier<bool> _groupEnabled;

  late final CombineLatestValueNotifier<bool> _combined = CombineLatestValueNotifier.combine2(
    _groupEnabled,
    _field.$enabled,
    (group, field) => group && field,
  );

  @override
  bool get enabled => _field.enabled && _groupEnabled.value;
  @override
  set enabled(bool value) => _field.enabled = value;
  @override
  ValueListenable<bool> get $enabled => _combined;

  @override
  FormFieldStatus<Transformed> get status => _field.status;
  @override
  ValueListenable<FormFieldStatus<Transformed>> get $status => _field.$status;
  @override
  FormFieldState get state => _field.state;
  @override
  ValueListenable<FormFieldState> get $state => _field.$state;

  @override
  FormFieldStatus<Transformed> validate() => _field.validate();
  @override
  FormFieldStatus<Transformed> validateDirty() => _field.validateDirty();
  @override
  void reset() => _field.reset();
  @override
  void clear() => _field.clear();

  void dispose() {
    _combined.dispose();
  }
}
