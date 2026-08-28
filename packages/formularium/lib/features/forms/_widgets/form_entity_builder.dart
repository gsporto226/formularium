import 'package:flutter/widgets.dart' hide FormFieldState;
import 'package:formularium/features/forms/_data_types/form_field_state.dart';
import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_interfaces/form_entity_interface.dart';
import 'package:listenable_plus/features/combine/implementations/combine_value_notifier.dart';

/// Função builder para renderizar um [IFormEntity].
typedef FormEntityWidgetBuilder<T> =
    Widget Function(
      BuildContext context,
      IFormEntity<T> entity,
      bool enabled,
      FormFieldState state,
      FormFieldStatus<T> status,
      Widget? child,
    );

/// Widget que escuta as mudanças de um [IFormEntity] e reconstrói via builder.
class FormEntityBuilder<T> extends StatelessWidget {
  /// Cria widget que escuta [entity] e reconstrói via [builder].
  const FormEntityBuilder({
    super.key,
    required this.entity,
    required this.builder,
    this.child,
  });

  /// Entidade de formulário a ser observada.
  final IFormEntity<T> entity;

  /// Função builder chamada em cada mudança.
  final FormEntityWidgetBuilder<T> builder;

  /// Widget filho opcional repassado ao builder.
  final Widget? child;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: CombineLatestValueNotifier.combine3(
      entity.$enabled,
      entity.$state,
      entity.$status,
      (bool enabled, FormFieldState state, FormFieldStatus<T> status) => (
        enabled: enabled,
        state: state,
        status: status,
      ),
    ),
    builder: (context, values, child) => builder(
      context,
      entity,
      values.enabled,
      values.state,
      values.status,
      child,
    ),
    child: child,
  );
}
