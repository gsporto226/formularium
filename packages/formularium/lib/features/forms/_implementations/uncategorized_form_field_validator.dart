import 'dart:async';

import 'package:formularium/features/localization/localizable_interface.dart';

/// Validador não categorizado: retorna [Validation]
typedef IUncategorizedFormFieldValidator<T, Transformed> = FutureOr<Validation<Transformed>> Function(T);

/// Validação não categorizada bem-sucedida. Contém valor transformado.
class Validation<Transformed> {
  /// Cria resultado válido com valor [transformed] e [validation].
  Validation({required this.validation, required this.transformed});

  /// Validação associada ao resultado.
  final ILocalizable? validation;

  /// Valor transformado.
  final Transformed transformed;
}
