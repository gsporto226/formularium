import 'dart:async';

import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/localization/localizable_interface.dart';

/// Classe que mantém todos os validators usados por uma aplicação.
///
/// A classe em si implementa alguns validators básicos, que podem ser usados
/// em qualquer contexto.
///
/// Para adicionar validators mais especializados (que trabalham com um tipo específico), o correto é
/// utilizar extensions.
///
/// **Olhar DecimalFormFieldValidators no CIApp de exemplo.**
class FormFieldValidators {
  const FormFieldValidators._();

  /// Instância singleton.
  static FormFieldValidators instance = const FormFieldValidators._();

  /// Retorna um novo validator que executa todos os validators um depois do outro.
  ///
  /// O valor original é passado para cada um dos validators.
  ///
  /// Caso seja encontrado um caso de failure, o processo é interrompido e o erro é retornado
  /// sem executar mais validators.
  ///
  IUncategorizedFormFieldValidator<T, Transformed> multiple<T, Transformed>({
    required List<IUncategorizedFormFieldValidator<T, Transformed>> validators,
    required Transformed Function(List<Transformed>) selector,
  }) => (T value) {
    final asyncResults = <Future<Validation<Transformed>>>[];
    final syncResults = <Validation<Transformed>>[];
    for (final validator in validators) {
      final r = validator(value);
      if (r is Future<Validation<Transformed>>) {
        asyncResults.add(r);
      } else {
        syncResults.add(r);
      }
    }
    if (asyncResults.isEmpty) {
      ILocalizable? firstValidation;
      final transformedValues = <Transformed>[];
      for (final r in syncResults) {
        transformedValues.add(r.transformed);
        firstValidation ??= r.validation;
      }
      return Validation(
        transformed: selector(transformedValues),
        validation: firstValidation,
      );
    }
    return Future.wait([
      ...syncResults.map(Future<Validation<Transformed>>.value),
      ...asyncResults,
    ]).then((results) {
      ILocalizable? firstValidation;
      final transformedValues = <Transformed>[];
      for (final r in results) {
        transformedValues.add(r.transformed);
        firstValidation ??= r.validation;
      }
      return Validation(
        transformed: selector(transformedValues),
        validation: firstValidation,
      );
    });
  };

  /// Retorna um novo validator que executa os validators um depois do outro.
  ///
  /// O valor tranformado de cada validator é passado para o próximo.
  ///
  /// Caso seja encontrado um caso de failure, o processo é interrompido e o erro é retornado
  /// sem executar mais validators.
  ///
  /// Caso acontecam warnings mas nenhum erro, o resultado final é retornado com o primeiro warning que ocorreu.
  IUncategorizedFormFieldValidator<T, T> serial<T>(List<IUncategorizedFormFieldValidator<T, T>> validators) {
    FutureOr<Validation<T>> run(int i, T current, [ILocalizable? firstValidation]) {
      if (i >= validators.length) {
        return Validation(transformed: current, validation: firstValidation);
      }
      final r = validators[i](current);
      if (r is Future<Validation<T>>) {
        return r.then((v) => run(i + 1, v.transformed, firstValidation ?? v.validation));
      }
      return run(i + 1, r.transformed, firstValidation ?? r.validation);
    }

    return (T value) => run(0, value);
  }

  /// Retorna um novo validator que é o resultado de e executar [first] e depois [second].
  ///
  /// Esse operador pode ser usado para combinar múltiplos [IUncategorizedFormFieldValidator] cujas validações
  /// retornem valores distintos.
  IUncategorizedFormFieldValidator<T, TransformedR> chain<T, Transformed, TransformedR>({
    required IUncategorizedFormFieldValidator<T, Transformed> first,
    required IUncategorizedFormFieldValidator<Transformed, TransformedR> second,
  }) => (T value) {
    final firstResult = first(value);
    if (firstResult is Future<Validation<Transformed>>) {
      return firstResult.then((result) {
        if (result.validation == null) return second(result.transformed);
        final secondResult = second(result.transformed);
        if (secondResult is Future<Validation<TransformedR>>) {
          return secondResult.then((s) => Validation(transformed: s.transformed, validation: result.validation));
        }
        return Validation(transformed: secondResult.transformed, validation: result.validation);
      });
    }
    if (firstResult.validation == null) return second(firstResult.transformed);
    final sr = second(firstResult.transformed);
    if (sr is Future<Validation<TransformedR>>) {
      return sr.then((s) => Validation(transformed: s.transformed, validation: firstResult.validation));
    }
    return Validation(transformed: sr.transformed, validation: firstResult.validation);
  };

  /// Retorna o valor como [Validation], nunca dá erro.
  ///
  /// Pode ser usado em situações onde não se deseja fazer uma validação,
  /// apenas usar o valor original.
  IUncategorizedFormFieldValidator<T, T> identityValidator<T>() =>
      (T value) => Validation(validation: null, transformed: value);

  /// Aplica [validator] após mapear valor de [A] para [B] via [valueMapper].
  IUncategorizedFormFieldValidator<A, TransformedB> map<A, TransformedA, B, TransformedB>({
    required IUncategorizedFormFieldValidator<B, TransformedB> validator,
    required B Function(A value) valueMapper,
  }) => (A value) {
    final result = validator(valueMapper(value));
    return result;
  };

  /// Executa [validator] apenas se [predicate] retornar true; senão, retorna [Validation] com valores nulos.
  IUncategorizedFormFieldValidator<A, Transformed?> conditional<A, Transformed>({
    required IUncategorizedFormFieldValidator<A, Transformed> validator,
    required bool Function(A value) predicate,
  }) => (A value) {
    if (predicate(value)) {
      return validator(value);
    }
    return Validation(transformed: null, validation: null);
  };
}

/// Extension que adiciona o método [chain] diretamente em [IUncategorizedFormFieldValidator].
extension IFormFieldValidatorChainExtension<T, Transformed> on IUncategorizedFormFieldValidator<T, Transformed> {
  /// Encadeia este validator com outro, executando primeiro este e depois [next].
  ///
  /// O valor transformado deste validator é passado para [next].
  ///
  /// Caso aconteça um erro, o processo é interrompido e o erro é retornado.
  ///
  /// Caso aconteça um warning no primeiro validator, o segundo é executado com o valor transformado
  /// e o warning do primeiro é priorizado no resultado final.
  IUncategorizedFormFieldValidator<T, TransformedR> chain<TransformedR>(
    IUncategorizedFormFieldValidator<Transformed, TransformedR> next,
  ) => FormFieldValidators.instance.chain(
    first: this,
    second: next,
  );
}
