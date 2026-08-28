import 'package:formularium/features/forms/_data_types/form_field_status.dart';
import 'package:formularium/features/forms/_implementations/form_field_validator.dart';

FormFieldStatus<R> combineFieldStatuses<R>({
  required List<FormFieldStatus<dynamic>> statuses,
  required R Function(List<dynamic> values) valueTransformer,
}) {
  var pendingCount = 0;
  var invalidCount = 0;
  var validCount = 0;
  var validatingCount = 0;

  final validations = List<ValidationBundle?>.filled(statuses.length, null);
  final invalidations = List<ValidationBundle?>.filled(statuses.length, null);

  final valid = List<dynamic>.filled(statuses.length, null);

  for (final (index, status) in statuses.indexed) {
    switch (status) {
      case Valid(:final transformed, :final validation):
        valid[index] = transformed;
        validations[index] = validation;
        validCount += 1;
      case Invalid(:final transformed, :final validation):
        valid[index] = transformed;
        validations[index] = validation;
        invalidCount += 1;
        invalidations[index] = validation;
      case Pending():
        pendingCount += 1;
      case Validating():
        validatingCount += 1;
    }
  }
  if (validatingCount > 0) {
    return const Validating();
  }
  if (pendingCount > 0) {
    return const Pending();
  }
  assert(
    validCount + invalidCount == statuses.length,
    'Se chegarmos aqui, a quantidade de valores válidos deveria'
    ' ser exatamente igual à quantidade de status na array original',
  );

  final value = valueTransformer(valid);
  final validation =
      invalidations.where((b) => b != null).firstOrNull ??
      validations
          .where(
            (b) => b != null,
          )
          .firstOrNull;
  if (invalidCount > 0) {
    assert(
      validation != null,
      'Invariant: if invalidCount > 0, at least one invalidation must have a non-null validation bundle',
    );
    return Invalid(
      transformed: value,
      validation: validation!,
    );
  }
  return Valid(
    transformed: value,
    validation: validation,
  );
}
