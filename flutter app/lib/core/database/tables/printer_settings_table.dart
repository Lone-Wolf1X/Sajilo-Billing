import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Stores thermal and bill printer hardware configuration.
/// Note: This is local-only hardware configuration and is not synced to the cloud.
class PrinterSettings extends Table with SyncTableMixin {
  /// Default print format: 'a4_pdf', 'thermal_58', 'thermal_80'
  TextColumn get defaultFormat => text().withDefault(const Constant('a4_pdf'))();

  /// Connection type: 'network' or 'usb'
  TextColumn get connectionType => text().withDefault(const Constant('network'))();

  /// Network printer IP address (e.g., 192.168.1.100)
  TextColumn get ipAddress => text().withDefault(const Constant('192.168.1.100'))();

  /// Raw ESC/POS port (default standard 9100)
  IntColumn get port => integer().withDefault(const Constant(9100))();

  /// OS printer name for USB connected thermal printer
  TextColumn get usbPrinterName => text().nullable()();

  /// Paper width in millimeters: 58 or 80
  IntColumn get paperWidth => integer().withDefault(const Constant(80))();

  /// Number of copies to print per bill (1 - 3)
  IntColumn get printCopies => integer().withDefault(const Constant(1))();

  /// Auto-trigger print immediately after a POS bill is saved
  BoolColumn get autoPrintAfterSale => boolean().withDefault(const Constant(false))();

  /// Show Nepali business name on header
  BoolColumn get showNepaliHeader => boolean().withDefault(const Constant(true))();

  /// Show fiscal QR code
  BoolColumn get showQrCode => boolean().withDefault(const Constant(true))();

  /// Show "Powered by Sajilo Billing | NextGen Innovations" footer
  BoolColumn get showFooterBranding => boolean().withDefault(const Constant(true))();

  /// Render receipt with Devanagari text as high-res raster bitmap (GS v 0)
  BoolColumn get enableRasterNepali => boolean().withDefault(const Constant(false))();

  /// Send paper cut command after print
  BoolColumn get cutPaper => boolean().withDefault(const Constant(true))();

  /// Number of trailing blank line feeds before cutting
  IntColumn get feedLines => integer().withDefault(const Constant(3))();

  /// Printer resolution in dots per inch (typically 203 or 300)
  IntColumn get dpi => integer().withDefault(const Constant(203))();
}

