import 'dart:io';
import '../../billing/domain/bill_model.dart';
import '../domain/print_format.dart';
import '../domain/printer_config.dart';
import '../utils/thermal_receipt_builder.dart';

/// Network receipt printer for raw ESC/POS over TCP (Port 9100 standard).
class NetworkReceiptPrinter {
  /// Sends bill bytes to the configured network thermal printer over raw TCP.
  Future<void> printReceipt(BillData bill, PrintFormat format, PrinterConfig config) async {
    final bytes = await ThermalReceiptBuilder.build(
      bill: bill,
      config: config,
      overrideFormat: format,
    );

    Socket? socket;
    try {
      socket = await Socket.connect(
        config.ipAddress,
        config.port,
        timeout: const Duration(seconds: 4),
      );

      // Support multi-copy printing
      final copies = config.printCopies.clamp(1, 3);
      for (int i = 0; i < copies; i++) {
        socket.add(bytes);
        await socket.flush();
      }
    } catch (e) {
      throw Exception('Network printer unreachable (${config.ipAddress}:${config.port}): $e');
    } finally {
      await socket?.close();
    }
  }

  /// Verifies network connectivity to the thermal printer on port 9100.
  Future<bool> testConnection(PrinterConfig config) async {
    Socket? socket;
    try {
      socket = await Socket.connect(
        config.ipAddress,
        config.port,
        timeout: const Duration(seconds: 3),
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      await socket?.close();
    }
  }
}

