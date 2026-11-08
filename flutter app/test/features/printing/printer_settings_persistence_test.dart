import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/features/printing/data/printer_repository.dart';
import 'package:sajilo_billing/features/printing/domain/print_format.dart';
import 'package:sajilo_billing/features/printing/domain/printer_config.dart';

void main() {
  late AppDatabase db;
  late PrinterRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = PrinterRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PrinterSettingsPersistence SQLite Tests', () {
    test('getConfig seeds default printer configuration if table is empty', () async {
      final config = await repo.getConfig();

      expect(config.defaultFormat, equals(PrintFormat.a4Pdf));
      expect(config.connectionType, equals('network'));
      expect(config.ipAddress, equals('192.168.1.100'));
      expect(config.port, equals(9100));
      expect(config.paperWidth, equals(80));
      expect(config.autoPrintAfterSale, isFalse);
      expect(config.enableRasterNepali, isFalse);
    });

    test('saveConfig persists customized hardware printer settings to SQLite', () async {
      const updatedConfig = PrinterConfig(
        id: 'main_shop_printer',
        defaultFormat: PrintFormat.thermal58,
        connectionType: 'usb',
        usbPrinterName: 'POS-58 Series',
        ipAddress: '192.168.1.222',
        port: 9100,
        paperWidth: 58,
        printCopies: 2,
        autoPrintAfterSale: true,
        showNepaliHeader: true,
        showQrCode: true,
        showFooterBranding: false,
        enableRasterNepali: true,
        cutPaper: false,
        feedLines: 4,
      );

      await repo.saveConfig(updatedConfig);

      final retrieved = await repo.getConfig();

      expect(retrieved.id, equals('main_shop_printer'));
      expect(retrieved.defaultFormat, equals(PrintFormat.thermal58));
      expect(retrieved.connectionType, equals('usb'));
      expect(retrieved.usbPrinterName, equals('POS-58 Series'));
      expect(retrieved.paperWidth, equals(58));
      expect(retrieved.printCopies, equals(2));
      expect(retrieved.autoPrintAfterSale, isTrue);
      expect(retrieved.enableRasterNepali, isTrue);
      expect(retrieved.cutPaper, isFalse);
      expect(retrieved.feedLines, equals(4));
    });
  });
}

