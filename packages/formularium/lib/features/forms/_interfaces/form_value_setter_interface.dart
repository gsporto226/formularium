/// Interface para definir valor de um campo de formulário.
///
/// Apenas escrita — para leitura, usar a interface de entidade.
abstract class IFormValueSetter<T> {
  /// Modifica o valor do campo, não possibilita acesso ao valor,
  /// para acessar o valor, usar `validated`;
  // ignore: avoid_setters_without_getters
  set value(T value);
}
