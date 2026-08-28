import 'dart:ui';

import 'package:formularium/features/forms/_implementations/uncategorized_form_field_validator.dart';
import 'package:formularium_flutter/src/color_validation.dart';

/// Validadores para campos de formulário de cor (hex, RGB, HSL).
class ColorFormFieldValidators {
  const ColorFormFieldValidators._();

  /// Instância singleton de [ColorFormFieldValidators].
  static ColorFormFieldValidators instance = const ColorFormFieldValidators._();

  /// Retorna um validador que verifica se uma [String] é uma cor hexadecimal
  /// válida.
  ///
  /// Se [requireHashtag] for true, o `#` inicial é obrigatório.
  IUncategorizedFormFieldValidator<String, Color> isHexColor({
    bool requireHashtag = false,
  }) => (String value) {
    final pattern = requireHashtag
        ? RegExp(r'^#[0-9a-fA-F]{3}([0-9a-fA-F]{3})?$')
        : RegExp(r'^#?[0-9a-fA-F]{3}([0-9a-fA-F]{3})?$');

    if (!pattern.hasMatch(value)) {
      return Validation(
        validation: ColorValidation.invalidColor(value),
        transformed: const Color(0xFF000000),
      );
    }

    final hex = value.replaceFirst('#', '');
    final colorValue = hex.length == 3
        ? int.parse(
                hex.split('').map((c) => '$c$c').join(),
                radix: 16,
              ) +
              0xFF000000
        : int.parse(hex, radix: 16) + 0xFF000000;

    return Validation(transformed: Color(colorValue), validation: null);
  };

  /// Retorna um validador que verifica se uma [String] é uma cor RGB/RGBA
  /// válida.
  ///
  /// Se [includePercentValues] for true, valores percentuais (ex.: `50%`) são
  /// aceitos. Se [allowSpaces] for true, espaços ao redor das vírgulas são
  /// aceitos.
  IUncategorizedFormFieldValidator<String, Color> isRgbColor({
    bool includePercentValues = true,
    bool allowSpaces = true,
  }) => (String value) {
    final pattern = RegExp(
      r'^rgb(a)?\(\s*'
      '(\\d{1,3}${includePercentValues ? r'|\d{1,3}%' : ''})\\s*'
      '${allowSpaces ? ',' : ','}\\s*'
      '(\\d{1,3}${includePercentValues ? r'|\d{1,3}%' : ''})\\s*'
      '${allowSpaces ? ',' : ','}\\s*'
      '(\\d{1,3}${includePercentValues ? r'|\d{1,3}%' : ''})\\s*'
      '(?:${allowSpaces ? ',' : ','}\\s*'
      '(\\d+(?:\\.\\d+)?${includePercentValues ? r'|\d+(?:\.\d+)?%' : ''})\\s*)?'
      r'\)$',
    );

    if (!pattern.hasMatch(value.trim())) {
      return Validation(
        validation: ColorValidation.invalidColor(value),
        transformed: const Color(0xFF000000),
      );
    }

    // Simple parse: extract numeric values
    final sanitized = value
        .replaceAll(RegExp(r'rgba?\('), '')
        .replaceAll(')', '')
        .replaceAll('%', '')
        .replaceAll(' ', '');
    final parts = sanitized.split(',');
    final r = int.parse(parts[0].trim());
    final g = int.parse(parts[1].trim());
    final b = int.parse(parts[2].trim());
    final a = parts.length > 3 ? double.parse(parts[3].trim()) : 1.0;

    if (r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255) {
      return Validation(
        validation: ColorValidation.invalidColor(value),
        transformed: const Color(0xFF000000),
      );
    }

    final alpha = (a * 255).round();
    return Validation(
      transformed: Color.fromARGB(alpha.clamp(0, 255), r, g, b),
      validation: null,
    );
  };

  /// Retorna um validador que verifica se uma [String] é uma cor HSL/HSLA
  /// válida.
  IUncategorizedFormFieldValidator<String, Color> isHSL() => (String value) {
    final pattern = RegExp(
      r'^hsl(a)?\(\s*'
      r'(\d{1,3}(?:\.\d+)?)\s*[,]\s*'
      r'(\d{1,3}(?:\.\d+)?)%\s*[,]\s*'
      r'(\d{1,3}(?:\.\d+)?)%\s*'
      r'(?:[,]\s*(\d+(?:\.\d+)?)\s*)?'
      r'\)$',
    );

    final match = pattern.firstMatch(value.trim());
    if (match == null) {
      return Validation(
        validation: ColorValidation.invalidColor(value),
        transformed: const Color(0xFF000000),
      );
    }

    final h = double.parse(match.group(2)!);
    final s = double.parse(match.group(3)!);
    final l = double.parse(match.group(4)!);
    final a = match.group(5) != null ? double.parse(match.group(5)!) : 1.0;

    if (h < 0 || h > 360 || s < 0 || s > 100 || l < 0 || l > 100) {
      return Validation(
        validation: ColorValidation.invalidColor(value),
        transformed: const Color(0xFF000000),
      );
    }

    return Validation(
      transformed: _hslToColor(h, s / 100, l / 100, a),
      validation: null,
    );
  };

  Color _hslToColor(double h, double s, double l, double alpha) {
    final c = (1 - (2 * l - 1).abs()) * s;
    final x = c * (1 - ((h / 60) % 2 - 1).abs());
    final m = l - c / 2;

    double r1;
    double g1;
    double b1;
    if (h < 60) {
      r1 = c;
      g1 = x;
      b1 = 0;
    } else if (h < 120) {
      r1 = x;
      g1 = c;
      b1 = 0;
    } else if (h < 180) {
      r1 = 0;
      g1 = c;
      b1 = x;
    } else if (h < 240) {
      r1 = 0;
      g1 = x;
      b1 = c;
    } else if (h < 300) {
      r1 = x;
      g1 = 0;
      b1 = c;
    } else {
      r1 = c;
      g1 = 0;
      b1 = x;
    }

    return Color.fromARGB(
      (alpha * 255).round(),
      ((r1 + m) * 255).round(),
      ((g1 + m) * 255).round(),
      ((b1 + m) * 255).round(),
    );
  }
}
