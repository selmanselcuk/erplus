import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Türk formatında sayı girişi için formatter (1.234.567,89)
class TurkishNumberFormatter extends TextInputFormatter {
  final int decimalDigits;
  final bool allowNegative;
  final bool autoAddDecimals;

  TurkishNumberFormatter({
    this.decimalDigits = 2,
    this.allowNegative = false,
    this.autoAddDecimals = true,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text;

    // Negatif sayıya izin verilmiyorsa eksi işaretini kaldır
    if (!allowNegative) {
      text = text.replaceAll('-', '');
    }

    // Tüm noktaları ve virgülleri temizle, sadece rakamları al
    String cleanedText = text.replaceAll('.', '').replaceAll(',', '');

    // Virgül pozisyonunu bul (ondalık ayracı)
    int commaIndex = text.indexOf(',');
    bool hasComma = commaIndex != -1;

    String integerPart = '';
    String decimalPart = '';

    if (hasComma) {
      // Virgülden önce ve sonra kaç rakam var?
      String beforeComma =
          text.substring(0, commaIndex).replaceAll('.', '').replaceAll(',', '');
      String afterComma = text
          .substring(commaIndex + 1)
          .replaceAll('.', '')
          .replaceAll(',', '');
      integerPart = beforeComma;
      decimalPart = afterComma;

      // Ondalık kısmı sınırla
      if (decimalPart.length > decimalDigits) {
        decimalPart = decimalPart.substring(0, decimalDigits);
      }
    } else {
      // Virgül yok, tüm rakamlar tam kısımda
      integerPart = cleanedText;
    }

    // Sadece rakamları filtrele
    integerPart = integerPart.replaceAll(RegExp(r'[^0-9]'), '');
    decimalPart = decimalPart.replaceAll(RegExp(r'[^0-9]'), '');

    // Binlik ayraçlarını ekle
    String formattedInteger = '';
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (count == 3) {
        formattedInteger = '.' + formattedInteger;
        count = 0;
      }
      formattedInteger = integerPart[i] + formattedInteger;
      count++;
    }

    // Sonucu oluştur
    String result = formattedInteger;
    if (hasComma || decimalPart.isNotEmpty) {
      result += ',$decimalPart';
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

/// Sadece tam sayı girişi için formatter (1.234.567)
class TurkishIntegerFormatter extends TextInputFormatter {
  final bool allowNegative;

  TurkishIntegerFormatter({
    this.allowNegative = false,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text;

    // Sadece rakam ve (izin veriliyorsa) eksi işaretine izin ver
    String filtered = '';
    bool hasNegative = false;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (char == '-' && allowNegative && i == 0 && !hasNegative) {
        filtered += char;
        hasNegative = true;
      } else if (RegExp(r'[0-9]').hasMatch(char)) {
        filtered += char;
      }
    }

    // Binlik ayracı ekle
    String formatted = _formatWithThousandsSeparator(filtered);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatWithThousandsSeparator(String text) {
    if (text.isEmpty) return text;

    bool isNegative = text.startsWith('-');
    if (isNegative) {
      text = text.substring(1);
    }

    String formattedInteger = '';
    int count = 0;
    for (int i = text.length - 1; i >= 0; i--) {
      if (count == 3) {
        formattedInteger = '.' + formattedInteger;
        count = 0;
      }
      formattedInteger = text[i] + formattedInteger;
      count++;
    }

    if (isNegative) {
      formattedInteger = '-$formattedInteger';
    }

    return formattedInteger;
  }
}

/// Yüzde formatı için formatter (%15,50)
class PercentageFormatter extends TextInputFormatter {
  final int decimalDigits;

  PercentageFormatter({this.decimalDigits = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text.replaceAll('%', '');

    // Nokta varsa virgüle çevir (ondalık ayracı olarak)
    bool hasComma = text.contains(',');
    if (!hasComma && text.contains('.')) {
      int firstDotIndex = text.indexOf('.');
      text = text.substring(0, firstDotIndex) +
          ',' +
          text.substring(firstDotIndex + 1).replaceAll('.', '');
    }

    // Birden fazla virgül varsa sadece ilkini tut
    int commaCount = text.split(',').length - 1;
    if (commaCount > 1) {
      int firstCommaIndex = text.indexOf(',');
      text = text.substring(0, firstCommaIndex + 1) +
          text.substring(firstCommaIndex + 1).replaceAll(',', '');
    }

    // Virgülden sonraki basamak sayısını kontrol et
    if (text.contains(',')) {
      List<String> parts = text.split(',');
      if (parts[1].length > decimalDigits) {
        text = parts[0] + ',' + parts[1].substring(0, decimalDigits);
      }
    }

    // Sadece rakam ve virgüle izin ver
    String filtered = '';
    bool hasCommaInFiltered = false;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (char == ',' && !hasCommaInFiltered) {
        filtered += char;
        hasCommaInFiltered = true;
      } else if (RegExp(r'[0-9]').hasMatch(char)) {
        filtered += char;
      }
    }

    // 100'den büyük değere izin verme
    double? value = _parseNumber(filtered);
    if (value != null && value > 100) {
      return oldValue;
    }

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }

  double? _parseNumber(String text) {
    if (text.isEmpty) return null;
    try {
      return double.parse(text.replaceAll(',', '.'));
    } catch (e) {
      return null;
    }
  }
}

/// Sayısal değerleri parse etmek için yardımcı fonksiyonlar
class NumberParser {
  /// Türk formatındaki sayıyı double'a çevirir (1.234,56 -> 1234.56)
  static double? parseTurkish(String text) {
    if (text.isEmpty) return null;
    try {
      // Binlik ayraçlarını temizle ve virgülü noktaya çevir
      String cleaned = text.replaceAll('.', '').replaceAll(',', '.');
      return double.parse(cleaned);
    } catch (e) {
      return null;
    }
  }

  /// Double değeri Türk formatına çevirir (1234.56 -> 1.234,56)
  static String formatTurkish(double value, {int decimalDigits = 2}) {
    final formatter = NumberFormat('#,##0.##', 'tr_TR');
    String formatted = formatter.format(value);
    // tr_TR locale kullanımı için virgül ve nokta yerlerini kontrol et
    formatted = formatted
        .replaceAll(',', 'TEMP')
        .replaceAll('.', ',')
        .replaceAll('TEMP', '.');
    return formatted;
  }

  /// Integer değeri Türk formatına çevirir (1234567 -> 1.234.567)
  static String formatTurkishInteger(int value) {
    String text = value.toString();
    String formatted = '';
    int count = 0;
    for (int i = text.length - 1; i >= 0; i--) {
      if (count == 3) {
        formatted = '.' + formatted;
        count = 0;
      }
      formatted = text[i] + formatted;
      count++;
    }
    return formatted;
  }
}
