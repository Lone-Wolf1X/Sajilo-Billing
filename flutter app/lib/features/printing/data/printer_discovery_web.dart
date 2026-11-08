/// Web stub for printer discovery.
Future<List<String>> scanNetworkPrinters({
  String subnetPrefix = '192.168.1',
  int port = 9100,
  void Function(double progress, String currentIp)? onProgress,
  bool Function()? isCancelled,
}) async {
  return [];
}

Future<List<String>> listUsbPrinters() async {
  return [];
}

