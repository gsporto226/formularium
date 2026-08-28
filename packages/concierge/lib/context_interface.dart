/// Interface genérica de serviço (service locator).
///
/// Permite recuperar instâncias tipadas sem depender de um framework.
abstract class IContext {
  /// Recupera a instância registrada para o tipo [T].
  T get<T>();
}