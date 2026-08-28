import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium/features/validators/_data_types/string_validation.dart';

/// Valida se uma string é um par de coordenadas latitude/longitude válido.
///
/// Se [checkDMS] for true, também aceita o formato graus-minutos-segundos (DMS).
/// Caso contrário, espera graus decimais no formato "lat, lng".
IUncategorizedFormFieldValidator<String, ({double lat, double lng})> isLatLongValidator({
  bool checkDMS = false,
}) => (string) {
  if (checkDMS) {
    final dmsMatch = RegExp(
      '^'
      r'(\d{1,3})°\s*(\d{1,2})'
      "'"
      r'\s*(\d{1,2}(?:\.\d+)?)'
      '"'
      r'?\s*([NSns])\s*,\s*'
      r'(\d{1,3})°\s*(\d{1,2})'
      "'"
      r'\s*(\d{1,2}(?:\.\d+)?)'
      '"'
      r'?\s*([EWew])$',
    ).firstMatch(string.trim());
    if (dmsMatch != null) {
      final latDeg = int.parse(dmsMatch.group(1)!);
      final latMin = int.parse(dmsMatch.group(2)!);
      final latSec = double.parse(dmsMatch.group(3)!);
      final latDir = dmsMatch.group(4)!.toUpperCase();
      final lngDeg = int.parse(dmsMatch.group(5)!);
      final lngMin = int.parse(dmsMatch.group(6)!);
      final lngSec = double.parse(dmsMatch.group(7)!);
      final lngDir = dmsMatch.group(8)!.toUpperCase();

      if (latDeg > 90 || latMin >= 60 || latSec >= 60) {
        return Validation(validation: StringValidation.invalidLatLong(string), transformed: (lat: 0, lng: 0));
      }
      if (lngDeg > 180 || lngMin >= 60 || lngSec >= 60) {
        return Validation(validation: StringValidation.invalidLatLong(string), transformed: (lat: 0, lng: 0));
      }

      var lat = latDeg + latMin / 60.0 + latSec / 3600.0;
      var lng = lngDeg + lngMin / 60.0 + lngSec / 3600.0;
      if (latDir == 'S') lat = -lat;
      if (lngDir == 'W') lng = -lng;

      return Validation(transformed: (lat: lat, lng: lng), validation: null);
    }
  }

  final match = RegExp(
    r'^([+\-]?\d+(?:\.\d+)?)\s*,\s*([+\-]?\d+(?:\.\d+)?)$',
  ).firstMatch(string.trim());
  if (match == null) {
    return Validation(validation: StringValidation.invalidLatLong(string), transformed: (lat: 0, lng: 0));
  }

  final lat = double.parse(match.group(1)!);
  final lng = double.parse(match.group(2)!);

  if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
    return Validation(validation: StringValidation.invalidLatLong(string), transformed: (lat: 0, lng: 0));
  }

  return Validation(transformed: (lat: lat, lng: lng), validation: null);
};
