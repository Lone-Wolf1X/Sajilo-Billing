import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/features/billing/domain/bill_model.dart';
import 'package:sajilo_billing/features/printing/data/network_receipt_printer.dart';
import 'package:sajilo_billing/features/printing/domain/print_format.dart';
import 'package:sajilo_billing/features/printing/domain/printer_config.dart';

void main() {
  group('NetworkReceiptPrinter TCP Socket Tests', () {
    late ServerSocket mockServer;
    late int serverPort;
    final receivedBytes = <int>[];

    setUp(() async {
      receivedBytes.clear();
      mockServer = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      serverPort = mockServer.port;

      mockServer.listen((clientSocket) {
        clientSocket.listen(
          (data) => receivedBytes.addAll(data),
          onDone: () => clientSocket.close(),
        );
      });
    });

    tearDown(() async {
      await mockServer.close();
    });

    final testBill = BillData(
      businessName: 'Network Mart',
      panVatNumber: '123456789',
      contactNumber: '9800000000',
      shopAddress: 'Kathmandu',
      invoiceNumber: 'TEST-NET-001',
      invoiceDate: DateTime(2026, 4, 15, 10, 0),
      customerName: 'Customer',
      paymentMode: 'CASH',
      items: const [
        BillItem(sn: 1, description: 'Item A', quantity: 1, rate: 100, amount: 100, unit: 'pcs'),
      ],
      subtotal: 100,
      discountAmount: 0,
      taxableAmount: 100,
      vatAmount: 0,
      grandTotal: 100,
      inWords: 'One Hundred Rupees Only',
      qrData: 'https://nextgeninnovations.com.np/',
    );

    test('testConnection returns true when port 9100 TCP socket is open and listening', () async {
      final printer = NetworkReceiptPrinter();
      final config = PrinterConfig(
        ipAddress: '127.0.0.1',
        port: serverPort,
      );

      final isConnected = await printer.testConnection(config);
      expect(isConnected, isTrue);
    });

    test('printReceipt delivers ESC/POS bytes over TCP socket successfully', () async {
      final printer = NetworkReceiptPrinter();
      final config = PrinterConfig(
        ipAddress: '127.0.0.1',
        port: serverPort,
        printCopies: 1,
      );

      await printer.printReceipt(testBill, PrintFormat.thermal80, config);

      // Allow brief tick for socket data delivery
      await Future.delayed(const Duration(milliseconds: 50));

      expect(receivedBytes, isNotEmpty);
      // Starts with ESC @ ([0x1B, 0x40])
      expect(receivedBytes[0], equals(0x1B));
      expect(receivedBytes[1], equals(0x40));
    });

    test('testConnection returns false and printReceipt throws when host is unreachable', () async {
      final printer = NetworkReceiptPrinter();
      // Unused port
      const config = PrinterConfig(
        ipAddress: '127.0.0.1',
        port: 65432,
      );

      final isConnected = await printer.testConnection(config);
      expect(isConnected, isFalse);

      expect(
        () => printer.printReceipt(testBill, PrintFormat.thermal80, config),
        throwsA(isA<Exception>()),
      );
    });
  });
}

