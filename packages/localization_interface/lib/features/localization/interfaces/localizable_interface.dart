import 'package:concierge/context_interface.dart';

/// Função que localiza [data] a partir de um [IContext].
typedef Localizer<T, R> = R Function(IContext context, T data);

/// Algo que pode ser localizado a partir de um [IContext].
///
/// Diferente de depender de um contexto Flutter ou de um framework, recebe
/// diretamente o [IContext], permitindo o uso em Dart puro (sem BuildContext).
abstract class ILocalizable {
  /// Localiza esta mensagem usando [context].
  String localize(IContext context);

  /// Cria um [ILocalizable] a partir de uma função [delegate].
  static ILocalizable delegate(String Function(IContext context) delegate) => DelegateLocalizable(delegate: delegate);
}

/// Implementação de [ILocalizable] que delega a localização a uma função.
class DelegateLocalizable implements ILocalizable {
  /// Cria um [DelegateLocalizable] com a função [delegate].
  const DelegateLocalizable({required this.delegate});

  /// Função que realiza a localização.
  final String Function(IContext context) delegate;

  @override
  String localize(IContext context) => delegate(context);
}