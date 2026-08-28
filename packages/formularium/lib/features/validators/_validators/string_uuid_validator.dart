import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Valida se uma string é um UUID válido.
///
/// Se [version] for especificada (ex.: '3', '4', '5'), valida contra o
/// padrão de UUID da versão correspondente. Use 'all' (padrão) para qualquer UUID,
/// 'loose' para uma verificação mais flexível, 'nil' ou 'max' para formas especiais de UUID.
IUncategorizedFormFieldValidator<String, String> isUuidValidator({String? version}) => (string) {
  final pattern = switch (version) {
    null || 'all' => RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ),
    'loose' => RegExp(r'^[0-9a-fA-F\-]+$'),
    'nil' => RegExp(r'^00000000-0000-0000-0000-000000000000$'),
    'max' => RegExp(r'^ffffffff-ffff-ffff-ffff-ffffffffffff$'),
    _ => RegExp(uuidPatternForVersion(version)),
  };
  if (!pattern.hasMatch(string)) {
    return Validation(
      validation: StringValidation.invalidUuid(version: version),
      transformed: '',
    );
  }
  return Validation(transformed: string, validation: null);
};

/// Retorna o padrão regex de UUID para uma determinada [version].
String uuidPatternForVersion(String version) {
  switch (version) {
    case '1':
      return r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-1[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$';
    case '2':
      return r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-2[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$';
    case '3':
      return r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-3[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$';
    case '4':
      return r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$';
    case '5':
      return r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-5[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$';
    case '6':
      return r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-6[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$';
    case '7':
      return r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-7[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$';
    case '8':
      return r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-8[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$';
    default:
      return r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$';
  }
}
