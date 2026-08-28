import 'package:formularium/features/forms/_interfaces/form_entity_interface.dart';
import 'package:formularium/features/forms/_interfaces/form_value_setter_interface.dart';

/// Combina as interfaces de leitura ([IFormEntity]) e escrita ([IFormValueSetter]) de um campo.
abstract class IFormField<T, Transformed> implements IFormEntity<Transformed>, IFormValueSetter<T> {}
