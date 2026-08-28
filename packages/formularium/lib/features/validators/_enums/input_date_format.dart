import 'package:intl/intl.dart';

/// Formatos de data de entrada suportados, com níveis crescentes de precisão.
enum InputDateFormat {
  /// Apenas o ano, ex.: 2008.
  yyyy,

  /// Apenas o dia, ex.: 18.
  dd,

  /// Dia e mês.
  ddMM,

  /// Dia, mês e ano.
  ddMMyyyy,

  /// Dia, mês, ano e hora.
  ddMMyyyyHH,

  /// Dia, mês, ano, hora e minuto.
  ddMMyyyyHHmm,

  /// Dia, mês, ano, hora, minuto e segundo.
  ddMMyyyyHHmmSS,
}

/// Extensão que mapeia cada [InputDateFormat] para sua máscara de entrada, formatador de data e texto de dica.
extension DateFormatToMask on InputDateFormat {
  /// Retorna a string do padrão de máscara de entrada para este formato.
  String get toMask {
    switch (this) {
      case InputDateFormat.yyyy:
        return '0000';
      case InputDateFormat.dd:
        return '00';
      case InputDateFormat.ddMM:
        return '00/00';
      case InputDateFormat.ddMMyyyy:
        return '00/00/0000';
      case InputDateFormat.ddMMyyyyHH:
        return '00/00/0000 00';
      case InputDateFormat.ddMMyyyyHHmm:
        return '00/00/0000 00:00';
      case InputDateFormat.ddMMyyyyHHmmSS:
        return '00/00/0000 00:00:00';
    }
  }

  /// Retorna o formatador [DateFormat] para análise e exibição de datas.
  DateFormat get toDateFormat {
    switch (this) {
      case InputDateFormat.yyyy:
        return DateFormat('yyyy');
      case InputDateFormat.dd:
        return DateFormat('dd');
      case InputDateFormat.ddMM:
        return DateFormat('dd/MM');
      case InputDateFormat.ddMMyyyy:
        return DateFormat('dd/MM/yyyy');
      case InputDateFormat.ddMMyyyyHH:
        return DateFormat('dd/MM/yyyy HH');
      case InputDateFormat.ddMMyyyyHHmm:
        return DateFormat('dd/MM/yyyy HH:mm');
      case InputDateFormat.ddMMyyyyHHmmSS:
        return DateFormat('dd/MM/yyyy HH:mm:ss');
    }
  }

  /// Retorna uma string de dica legível para este formato.
  String get toHint {
    switch (this) {
      case InputDateFormat.yyyy:
        return '2008';
      case InputDateFormat.dd:
        return '18';
      case InputDateFormat.ddMM:
        return '18/05';
      case InputDateFormat.ddMMyyyy:
        return '18/05/2008';
      case InputDateFormat.ddMMyyyyHH:
        return '18/05/2008 08';
      case InputDateFormat.ddMMyyyyHHmm:
        return '18/05/2008 08:30';
      case InputDateFormat.ddMMyyyyHHmmSS:
        return '18/05/2008 08:30:12';
    }
  }
}
