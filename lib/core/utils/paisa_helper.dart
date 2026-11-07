import 'package:intl/intl.dart';

/// Financial arithmetic helper storing and computing amounts in integer paisa
/// (1 Rupee = 100 Paisa) to completely avoid floating-point inaccuracies.
class PaisaHelper {
  PaisaHelper._();

  /// Converts double rupees to integer paisa.
  static int toPaisa(double rupees) {
    return (rupees * 100).round();
  }

  /// Converts integer paisa to double rupees.
  static double toRupees(int paisa) {
    return paisa / 100.0;
  }

  /// Formats integer paisa to a localized currency string.
  /// Example: 255050 -> "Rs. 2,550.50" (or "रु. 2,550.50")
  static String formatPaisa(
    int paisa, {
    bool includeSymbol = true,
    bool isNepali = false,
  }) {
    final rupees = toRupees(paisa);
    final formatter = NumberFormat('#,##,##0.00', 'en_US');
    final formattedNum = formatter.format(rupees);

    if (!includeSymbol) return formattedNum;

    final symbol = isNepali ? 'रु. ' : 'Rs. ';
    return '$symbol$formattedNum';
  }

  /// Converts an amount to standard Nepali words for invoice footer (In Words / अक्षरेपी).
  static String paisaToWords(int paisa) {
    final totalRupees = paisa ~/ 100;
    final remainingPaisa = paisa % 100;

    if (totalRupees == 0 && remainingPaisa == 0) {
      return 'Zero Rupees Only';
    }

    final rupeeWords = _convertNumberToWords(totalRupees);
    final buffer = StringBuffer(rupeeWords);
    buffer.write(' Rupees');

    if (remainingPaisa > 0) {
      buffer.write(' and ');
      buffer.write(_convertNumberToWords(remainingPaisa));
      buffer.write(' Paisa');
    }

    buffer.write(' Only');
    return buffer.toString();
  }

  static String _convertNumberToWords(int n) {
    if (n == 0) return 'Zero';

    final units = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];

    final tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    String twoDigits(int num) {
      if (num < 20) return units[num];
      final ten = tens[num ~/ 10];
      final unit = units[num % 10];
      return unit.isEmpty ? ten : '$ten $unit';
    }

    String threeDigits(int num) {
      final hundred = num ~/ 100;
      final rest = num % 100;
      if (hundred > 0 && rest > 0) {
        return '${units[hundred]} Hundred ${twoDigits(rest)}';
      } else if (hundred > 0) {
        return '${units[hundred]} Hundred';
      } else {
        return twoDigits(rest);
      }
    }

    // Nepali/South Asian numbering: Crores, Lakhs, Thousands, Hundreds
    var remaining = n;
    final parts = <String>[];

    final crore = remaining ~/ 10000000;
    remaining %= 10000000;
    if (crore > 0) {
      parts.add('${threeDigits(crore)} Crore');
    }

    final lakh = remaining ~/ 100000;
    remaining %= 100000;
    if (lakh > 0) {
      parts.add('${threeDigits(lakh)} Lakh');
    }

    final thousand = remaining ~/ 1000;
    remaining %= 1000;
    if (thousand > 0) {
      parts.add('${threeDigits(thousand)} Thousand');
    }

    if (remaining > 0) {
      parts.add(threeDigits(remaining));
    }

    return parts.join(' ');
  }
}
