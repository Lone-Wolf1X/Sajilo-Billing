import 'printer_discovery_io.dart'
    if (dart.library.html) 'printer_discovery_web.dart' as impl;

/// Cross-platform printer discovery service for Network and USB devices.
class PrinterDiscoveryService {
  /// Scans local subnet on raw ESC/POS port 9100 with progress reporting.
  static Future<List<String>> scanNetworkPrinters({
    String subnetPrefix = '192.168.1',
    int port = 9100,
    void Function(double progress, String currentIp)? onProgress,
    bool Function()? isCancelled,
  }) {
    return impl.scanNetworkPrinters(
      subnetPrefix: subnetPrefix,
      port: port,
      onProgress: onProgress,
      isCancelled: isCancelled,
    );
  }

  /// Lists all OS-enumerated local and USB printers.
  static Future<List<String>> listUsbPrinters() {
    return impl.listUsbPrinters();
  }
}

