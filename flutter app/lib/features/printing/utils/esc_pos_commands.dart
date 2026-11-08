/// Standard ESC/POS command sequences for thermal receipt printers.
class EscPosCommands {
  EscPosCommands._();

  /// Hardware initialization (clears buffer and resets modes)
  static const List<int> initialize = [0x1B, 0x40]; // ESC @

  /// Character Code Tables (ESC t n)
  static const List<int> selectCodePageCP437 = [0x1B, 0x74, 0x00]; // USA, Standard Europe
  static const List<int> selectCodePageCP850 = [0x1B, 0x74, 0x02]; // Multilingual

  /// Text Justification (ESC a n)
  static const List<int> alignLeft = [0x1B, 0x61, 0x00];
  static const List<int> alignCenter = [0x1B, 0x61, 0x01];
  static const List<int> alignRight = [0x1B, 0x61, 0x02];

  /// Font Emphasize / Bold (ESC E n)
  static const List<int> boldOn = [0x1B, 0x45, 0x01];
  static const List<int> boldOff = [0x1B, 0x45, 0x00];

  /// Underline (ESC - n)
  static const List<int> underlineOn = [0x1B, 0x2D, 0x01];
  static const List<int> underlineOff = [0x1B, 0x2D, 0x00];

  /// Character Size (GS ! n)
  static const List<int> sizeNormal = [0x1D, 0x21, 0x00];
  static const List<int> sizeDoubleHeight = [0x1D, 0x21, 0x01];
  static const List<int> sizeDoubleWidth = [0x1D, 0x21, 0x10];
  static const List<int> sizeDouble = [0x1D, 0x21, 0x11];

  /// Line spacing
  static const List<int> lineSpacingDefault = [0x1B, 0x32]; // ESC 2 (1/6 inch)

  /// Paper Feed
  static const List<int> lineFeed = [0x0A]; // LF (\n)

  /// Feeds [n] lines (ESC d n)
  static List<int> feedLines(int n) => [0x1B, 0x64, n.clamp(1, 255)];

  /// Paper Cut Commands (GS V m)
  static const List<int> cutFull = [0x1D, 0x56, 0x00]; // GS V 0 (full cut)
  static const List<int> cutPartial = [0x1D, 0x56, 0x01]; // GS V 1 (partial cut)

  /// Feeds [feedLines] lines and cuts paper (GS V 'B' n)
  static List<int> feedAndCut(int feedLines, {bool partial = false}) {
    return [0x1D, 0x56, partial ? 0x42 : 0x41, feedLines.clamp(0, 255)];
  }

  /// ESC/POS Raster Bit Image Header (GS v 0 m xL xH yL yH)
  /// - [widthBytes]: width in bytes (width in pixels / 8)
  /// - [heightPixels]: height in dots/pixels
  /// - [density]: 0 = normal (203 DPI), 1 = double-width, 2 = double-height, 3 = quadruple
  static List<int> rasterBitImageHeader({
    required int widthBytes,
    required int heightPixels,
    int density = 0,
  }) {
    final xL = widthBytes & 0xFF;
    final xH = (widthBytes >> 8) & 0xFF;
    final yL = heightPixels & 0xFF;
    final yH = (heightPixels >> 8) & 0xFF;

    return [
      0x1D, // GS
      0x76, // v
      0x30, // 0
      density & 0x03, // m (0: normal)
      xL,
      xH,
      yL,
      yH,
    ];
  }
}

