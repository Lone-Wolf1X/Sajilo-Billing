import 'dart:async';
import 'dart:io';
import 'package:printing/printing.dart';

/// Desktop implementation of printer discovery using TCP sockets and OS printing subsystem.
Future<List<String>> scanNetworkPrinters({
  String subnetPrefix = '192.168.1',
  int port = 9100,
  void Function(double progress, String currentIp)? onProgress,
  bool Function()? isCancelled,
}) async {
  final discoveredIps = <String>[];
  const totalHosts = 254;
  int completedHosts = 0;

  // Worker pool of 8 concurrent connection tasks
  const concurrency = 8;
  final queue = List.generate(totalHosts, (i) => '$subnetPrefix.${i + 1}');

  Future<void> worker() async {
    while (queue.isNotEmpty) {
      if (isCancelled != null && isCancelled()) return;

      final ip = queue.removeAt(0);
      Socket? socket;
      try {
        socket = await Socket.connect(
          ip,
          port,
          timeout: const Duration(milliseconds: 500),
        );
        discoveredIps.add(ip);
      } catch (_) {
        // Host unreachable or port closed
      } finally {
        await socket?.close();
      }

      completedHosts++;
      if (onProgress != null) {
        onProgress(completedHosts / totalHosts, ip);
      }
    }
  }

  final workers = List.generate(concurrency, (_) => worker());
  await Future.wait(workers);

  return discoveredIps;
}

Future<List<String>> listUsbPrinters() async {
  try {
    final printers = await Printing.listPrinters();
    return printers.map((p) => p.name).toList();
  } catch (_) {
    return [];
  }
}

