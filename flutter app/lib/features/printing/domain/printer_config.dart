import 'package:drift/drift.dart' as drift;
import '../../../core/database/app_database.dart';
import 'print_format.dart';

/// Immutable model representing hardware printer configuration.
class PrinterConfig {
  final String id;
  final PrintFormat defaultFormat;
  final String connectionType; // 'network' or 'usb'
  final String ipAddress;
  final int port;
  final String? usbPrinterName;
  final int paperWidth; // 58 or 80
  final int printCopies;
  final bool autoPrintAfterSale;
  final bool showNepaliHeader;
  final bool showQrCode;
  final bool showFooterBranding;
  final bool enableRasterNepali;
  final bool cutPaper;
  final int feedLines;
  final int dpi;

  const PrinterConfig({
    this.id = 'default_printer_config',
    this.defaultFormat = PrintFormat.a4Pdf,
    this.connectionType = 'network',
    this.ipAddress = '192.168.1.100',
    this.port = 9100,
    this.usbPrinterName,
    this.paperWidth = 80,
    this.printCopies = 1,
    this.autoPrintAfterSale = false,
    this.showNepaliHeader = true,
    this.showQrCode = true,
    this.showFooterBranding = true,
    this.enableRasterNepali = false,
    this.cutPaper = true,
    this.feedLines = 3,
    this.dpi = 203,
  });

  bool get isNetwork => connectionType.toLowerCase() == 'network';
  bool get isUsb => connectionType.toLowerCase() == 'usb';

  factory PrinterConfig.fromRow(PrinterSetting row) {
    return PrinterConfig(
      id: row.id,
      defaultFormat: PrintFormat.fromCode(row.defaultFormat),
      connectionType: row.connectionType,
      ipAddress: row.ipAddress,
      port: row.port,
      usbPrinterName: row.usbPrinterName,
      paperWidth: row.paperWidth,
      printCopies: row.printCopies,
      autoPrintAfterSale: row.autoPrintAfterSale,
      showNepaliHeader: row.showNepaliHeader,
      showQrCode: row.showQrCode,
      showFooterBranding: row.showFooterBranding,
      enableRasterNepali: row.enableRasterNepali,
      cutPaper: row.cutPaper,
      feedLines: row.feedLines,
      dpi: row.dpi,
    );
  }

  PrinterSettingsCompanion toCompanion() {
    return PrinterSettingsCompanion(
      id: drift.Value(id),
      defaultFormat: drift.Value(defaultFormat.code),
      connectionType: drift.Value(connectionType),
      ipAddress: drift.Value(ipAddress),
      port: drift.Value(port),
      usbPrinterName: drift.Value(usbPrinterName),
      paperWidth: drift.Value(paperWidth),
      printCopies: drift.Value(printCopies),
      autoPrintAfterSale: drift.Value(autoPrintAfterSale),
      showNepaliHeader: drift.Value(showNepaliHeader),
      showQrCode: drift.Value(showQrCode),
      showFooterBranding: drift.Value(showFooterBranding),
      enableRasterNepali: drift.Value(enableRasterNepali),
      cutPaper: drift.Value(cutPaper),
      feedLines: drift.Value(feedLines),
      dpi: drift.Value(dpi),
      updatedAt: drift.Value(DateTime.now().toUtc()),
    );
  }

  PrinterConfig copyWith({
    String? id,
    PrintFormat? defaultFormat,
    String? connectionType,
    String? ipAddress,
    int? port,
    String? usbPrinterName,
    int? paperWidth,
    int? printCopies,
    bool? autoPrintAfterSale,
    bool? showNepaliHeader,
    bool? showQrCode,
    bool? showFooterBranding,
    bool? enableRasterNepali,
    bool? cutPaper,
    int? feedLines,
    int? dpi,
  }) {
    return PrinterConfig(
      id: id ?? this.id,
      defaultFormat: defaultFormat ?? this.defaultFormat,
      connectionType: connectionType ?? this.connectionType,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      usbPrinterName: usbPrinterName ?? this.usbPrinterName,
      paperWidth: paperWidth ?? this.paperWidth,
      printCopies: printCopies ?? this.printCopies,
      autoPrintAfterSale: autoPrintAfterSale ?? this.autoPrintAfterSale,
      showNepaliHeader: showNepaliHeader ?? this.showNepaliHeader,
      showQrCode: showQrCode ?? this.showQrCode,
      showFooterBranding: showFooterBranding ?? this.showFooterBranding,
      enableRasterNepali: enableRasterNepali ?? this.enableRasterNepali,
      cutPaper: cutPaper ?? this.cutPaper,
      feedLines: feedLines ?? this.feedLines,
      dpi: dpi ?? this.dpi,
    );
  }
}

