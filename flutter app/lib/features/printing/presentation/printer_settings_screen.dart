import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/responsive_card.dart';
import '../data/printer_discovery_service.dart';
import '../data/printer_repository.dart';
import '../domain/print_format.dart';
import '../domain/printer_config.dart';
import 'printer_test_dialog.dart';

/// Complete configuration screen for ESC/POS thermal roll and A4 bill printers.
class PrinterSettingsScreen extends ConsumerStatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  ConsumerState<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends ConsumerState<PrinterSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _ipController;
  late TextEditingController _portController;

  PrintFormat _selectedFormat = PrintFormat.a4Pdf;
  String _connectionType = 'network';
  String? _selectedUsbPrinter;
  int _paperWidth = 80;
  int _printCopies = 1;
  bool _autoPrintAfterSale = false;
  bool _showNepaliHeader = true;
  bool _showQrCode = true;
  bool _showFooterBranding = true;
  bool _enableRasterNepali = false;
  bool _cutPaper = true;
  int _feedLines = 3;

  bool _isLoaded = false;
  bool _isSaving = false;
  bool _isScanning = false;
  double _scanProgress = 0.0;
  String _scanStatusText = '';
  List<String> _discoveredIps = [];
  List<String> _usbPrinters = [];

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController();
    _portController = TextEditingController();
    _loadInitialConfig();
    _refreshUsbPrinters();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialConfig() async {
    final repo = ref.read(printerRepositoryProvider);
    final config = await repo.getConfig();

    if (mounted) {
      setState(() {
        _selectedFormat = config.defaultFormat;
        _connectionType = config.connectionType;
        _ipController.text = config.ipAddress;
        _portController.text = config.port.toString();
        _selectedUsbPrinter = config.usbPrinterName;
        _paperWidth = config.paperWidth;
        _printCopies = config.printCopies;
        _autoPrintAfterSale = config.autoPrintAfterSale;
        _showNepaliHeader = config.showNepaliHeader;
        _showQrCode = config.showQrCode;
        _showFooterBranding = config.showFooterBranding;
        _enableRasterNepali = config.enableRasterNepali;
        _cutPaper = config.cutPaper;
        _feedLines = config.feedLines;
        _isLoaded = true;
      });
    }
  }

  Future<void> _refreshUsbPrinters() async {
    final list = await PrinterDiscoveryService.listUsbPrinters();
    if (mounted) {
      setState(() {
        _usbPrinters = list;
        if (_selectedUsbPrinter == null && list.isNotEmpty) {
          _selectedUsbPrinter = list.first;
        }
      });
    }
  }

  Future<void> _scanNetwork() async {
    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
      _discoveredIps = [];
      _scanStatusText = 'Scanning 192.168.1.1 - 254 on port 9100...';
    });

    try {
      final results = await PrinterDiscoveryService.scanNetworkPrinters(
        subnetPrefix: '192.168.1',
        port: int.tryParse(_portController.text) ?? 9100,
        onProgress: (progress, currentIp) {
          if (mounted) {
            setState(() {
              _scanProgress = progress;
              _scanStatusText = 'Pinging $currentIp... (${(progress * 100).toInt()}%)';
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _discoveredIps = results;
          _scanStatusText = results.isEmpty
              ? 'No ESC/POS printers found on port 9100. Enter IP manually.'
              : 'Found ${results.length} printer(s)! Tap an IP to select.';
        });
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final config = PrinterConfig(
        defaultFormat: _selectedFormat,
        connectionType: _connectionType,
        ipAddress: _ipController.text.trim(),
        port: int.tryParse(_portController.text.trim()) ?? 9100,
        usbPrinterName: _selectedUsbPrinter,
        paperWidth: _paperWidth,
        printCopies: _printCopies,
        autoPrintAfterSale: _autoPrintAfterSale,
        showNepaliHeader: _showNepaliHeader,
        showQrCode: _showQrCode,
        showFooterBranding: _showFooterBranding,
        enableRasterNepali: _enableRasterNepali,
        cutPaper: _cutPaper,
        feedLines: _feedLines,
      );

      final repo = ref.read(printerRepositoryProvider);
      await repo.saveConfig(config);
      ref.invalidate(printerConfigProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Printer settings saved successfully / सेटिङ सुरक्षित गरियो'),
            backgroundColor: AppTheme.accentTeal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving printer settings: $e'), backgroundColor: AppTheme.dangerRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  PrinterConfig _buildCurrentConfig() {
    return PrinterConfig(
      defaultFormat: _selectedFormat,
      connectionType: _connectionType,
      ipAddress: _ipController.text.trim(),
      port: int.tryParse(_portController.text.trim()) ?? 9100,
      usbPrinterName: _selectedUsbPrinter,
      paperWidth: _paperWidth,
      printCopies: _printCopies,
      autoPrintAfterSale: _autoPrintAfterSale,
      showNepaliHeader: _showNepaliHeader,
      showQrCode: _showQrCode,
      showFooterBranding: _showFooterBranding,
      enableRasterNepali: _enableRasterNepali,
      cutPaper: _cutPaper,
      feedLines: _feedLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (!_isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.printerSettings ?? 'Printer Settings / प्रिन्टर सेटअप'),
        actions: [
          IconButton(
            tooltip: 'Ping & Test Connection',
            icon: const Icon(Icons.wifi_tethering),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => PrinterTestDialog(config: _buildCurrentConfig()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Default Format Selection
              ResponsiveCard(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.print_outlined, color: AppTheme.primaryBlue),
                          const SizedBox(width: 8),
                          Text(
                            l10n?.defaultPrintFormat ?? 'Default Print Format / पूर्वनिर्धारित ढाँचा',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: PrintFormat.values.map((f) {
                          final isSelected = _selectedFormat == f;
                          return ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(f.isThermal ? Icons.receipt_long : Icons.description_outlined, size: 16),
                                const SizedBox(width: 6),
                                Text(f.label),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _selectedFormat = f;
                                  if (f == PrintFormat.thermal58) _paperWidth = 58;
                                  if (f == PrintFormat.thermal80) _paperWidth = 80;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 2. Hardware Connection Configuration
              ResponsiveCard(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.cable_outlined, color: AppTheme.accentTeal),
                          const SizedBox(width: 8),
                          Text(
                            l10n?.connectionType ?? 'Printer Connection / प्रिन्टर कनेक्सन',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SegmentedButton<String>(
                        segments: [
                          ButtonSegment(
                            value: 'network',
                            label: Text(l10n?.networkPrinter ?? 'Network (LAN / Wi-Fi)'),
                            icon: const Icon(Icons.wifi),
                          ),
                          ButtonSegment(
                            value: 'usb',
                            label: Text(l10n?.usbPrinter ?? 'USB Thermal Printer'),
                            icon: const Icon(Icons.usb),
                          ),
                        ],
                        selected: {_connectionType},
                        onSelectionChanged: (set) {
                          setState(() => _connectionType = set.first);
                        },
                      ),
                      const SizedBox(height: 18),

                      if (_connectionType == 'network') ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _ipController,
                                decoration: InputDecoration(
                                  labelText: l10n?.printerIpAddress ?? 'Printer IP Address (e.g. 192.168.1.100)',
                                  prefixIcon: const Icon(Icons.lan_outlined),
                                  isDense: true,
                                ),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'IP address is required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _portController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: l10n?.printerPort ?? 'Port (9100)',
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _isScanning ? null : _scanNetwork,
                              icon: _isScanning
                                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Icon(Icons.radar, size: 16),
                              label: Text(_isScanning ? 'Scanning...' : 'Scan Subnet for Printers'),
                            ),
                            if (_scanStatusText.isNotEmpty)
                              Text(
                                _scanStatusText,
                                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                              ),
                          ],
                        ),
                        if (_isScanning) ...[
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: _scanProgress),
                        ],
                        if (_discoveredIps.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: _discoveredIps.map((ip) {
                              return ActionChip(
                                avatar: const Icon(Icons.check, size: 14, color: AppTheme.accentTeal),
                                label: Text(ip),
                                onPressed: () {
                                  setState(() => _ipController.text = ip);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedUsbPrinter,
                                decoration: const InputDecoration(
                                  labelText: 'Detected USB / Local Printer',
                                  prefixIcon: Icon(Icons.usb),
                                  isDense: true,
                                ),
                                items: _usbPrinters.map((name) {
                                  return DropdownMenuItem(value: name, child: Text(name));
                                }).toList(),
                                onChanged: (val) {
                                  setState(() => _selectedUsbPrinter = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              tooltip: 'Refresh Printer List',
                              icon: const Icon(Icons.refresh),
                              onPressed: _refreshUsbPrinters,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Note: On Windows, install your manufacturer ESC/POS USB driver once. Sajilo Billing communicates directly with the named device.',
                          style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 3. Roll Formatting & Toggles
              ResponsiveCard(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Roll & Formatting Preferences / रसिद ढाँचा सेटिङहरू',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 14),

                      // Paper Width
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Paper Width (कागजको चौडाइ):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          SegmentedButton<int>(
                            segments: const [
                              ButtonSegment(value: 58, label: Text('58mm (2")')),
                              ButtonSegment(value: 80, label: Text('80mm (3")')),
                            ],
                            selected: {_paperWidth},
                            onSelectionChanged: (val) => setState(() => _paperWidth = val.first),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Number of Copies
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Print Copies (प्रतिलिपि):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          DropdownButton<int>(
                            value: _printCopies,
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('1 Copy (ग्राहक प्रति)')),
                              DropdownMenuItem(value: 2, child: Text('2 Copies (ग्राहक + पसल)')),
                              DropdownMenuItem(value: 3, child: Text('3 Copies')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _printCopies = val);
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n?.autoPrintSale ?? 'Auto-Print After Sale (बिक्रीपछि तुरुन्त स्वतः प्रिन्ट)'),
                        subtitle: const Text('Immediately prints bill when confirmed on POS counter without extra taps'),
                        value: _autoPrintAfterSale,
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (val) => setState(() => _autoPrintAfterSale = val),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n?.showNepaliHeader ?? 'Show Nepali Business Name (नेपाली नाम देखाउनुहोस्)'),
                        subtitle: const Text('Displays Devanagari business name on the header'),
                        value: _showNepaliHeader,
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (val) => setState(() => _showNepaliHeader = val),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n?.showQrCode ?? 'Print Fiscal QR Code (फिस्कल QR कोड)'),
                        subtitle: const Text('Enables Fonepay/invoice verification QR code on receipt'),
                        value: _showQrCode,
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (val) => setState(() => _showQrCode = val),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n?.enableRasterNepali ?? 'High-Fidelity Devanagari Mode (Raster)'),
                        subtitle: const Text('Renders full Nepali text as graphic bitmap image (GS v 0). Essential for pure Devanagari receipts.'),
                        value: _enableRasterNepali,
                        activeColor: AppTheme.accentTeal,
                        onChanged: (val) => setState(() => _enableRasterNepali = val),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n?.cutPaper ?? 'Auto Cut Paper (कागज स्वतः काट्ने)'),
                        subtitle: const Text('Sends GS V partial cut command after receipt printing'),
                        value: _cutPaper,
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (val) => setState(() => _cutPaper = val),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n?.showFooterBranding ?? 'Show NextGen Innovations Footer Branding'),
                        subtitle: const Text('Prints "Powered by Sajilo Billing | NextGen Innovations" and website'),
                        value: _showFooterBranding,
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (val) => setState(() => _showFooterBranding = val),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Save and Test Buttons
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => PrinterTestDialog(config: _buildCurrentConfig()),
                      );
                    },
                    icon: const Icon(Icons.wifi_tethering),
                    label: Text(l10n?.testConnection ?? 'Test Connection'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveSettings,
                    icon: _isSaving
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.save),
                    label: const Text('Save Printer Settings / सुरक्षित गर्नुहोस्'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

