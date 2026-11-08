/// Defines the supported receipt and invoice output formats.
enum PrintFormat {
  /// Standard full-page bilingual PDF invoice (A4 or A5)
  a4Pdf('a4_pdf', 'A4 / A5 PDF (कर बिजक)'),

  /// 58mm (2-inch) thermal roll receipt (32 characters per line)
  thermal58('thermal_58', 'Thermal 58mm (थर्मल ५८ मि.मि.)'),

  /// 80mm (3-inch) thermal roll receipt (48 characters per line)
  thermal80('thermal_80', 'Thermal 80mm (थर्मल ८० मि.मि.)');

  final String code;
  final String label;

  const PrintFormat(this.code, this.label);

  static PrintFormat fromCode(String? code) {
    switch (code) {
      case 'thermal_58':
        return PrintFormat.thermal58;
      case 'thermal_80':
        return PrintFormat.thermal80;
      case 'a4_pdf':
      default:
        return PrintFormat.a4Pdf;
    }
  }

  bool get isThermal => this == PrintFormat.thermal58 || this == PrintFormat.thermal80;

  int get paperWidthMm => this == PrintFormat.thermal58 ? 58 : 80;

  int get charsPerLine => this == PrintFormat.thermal58 ? 32 : 48;
}

