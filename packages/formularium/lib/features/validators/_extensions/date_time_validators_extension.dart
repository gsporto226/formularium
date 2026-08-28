import 'package:formularium/features/forms/_utils/form_field_validators.dart';
import 'package:formularium/features/validators/_validators/date_time_form_field_validators.dart';

/// Extensão em [FormFieldValidators] para expor [DateTimeFormFieldValidators] através do getter `dateTime`.
extension DateTimeValidatorsExtension on FormFieldValidators {
  /// A instância singleton de [DateTimeFormFieldValidators].
  DateTimeFormFieldValidators get dateTime => DateTimeFormFieldValidators.instance;
}
