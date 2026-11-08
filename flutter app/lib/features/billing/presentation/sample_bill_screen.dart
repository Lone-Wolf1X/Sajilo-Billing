import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../business/presentation/business_provider.dart';
import '../data/pdf_bill_generator.dart';
import '../domain/bill_model.dart';

class SampleBillScreen extends ConsumerStatefulWidget {
  const SampleBillScreen({super.key});

  @override
  ConsumerState<SampleBillScreen> createState() => _SampleBillScreenState();
}

class _SampleBillScreenState extends ConsumerState<SampleBillScreen> {
  Uint8List? _pdfBytes;
  BillData? _currentBillData;
  bool _isGenerating = false;
  String? _savedDocPath;

  Future<void> _generateSamplePdf() async {
    final profile = await ref.read(businessRepositoryProvider).getCurrentProfile();
    if (profile == null) return;

    setState(() => _isGenerating = true);
    try {
      Uint8List? logoBytes;
      if (profile.logoPath != null) {
        final logoFile = File(profile.logoPath!);
        if (await logoFile.exists()) {
          logoBytes = await logoFile.readAsBytes();
        }
      }

      final billData = BillData.dummy(
        businessName: profile.businessName,
        panVatNumber: profile.panVatNumber,
        contactNumber: profile.contactNumber,
        shopAddress: profile.shopAddress,
        logoBytes: logoBytes,
      );

      final pdfDoc = await PdfBillGenerator.generateDocument(billData);
      final bytes = await pdfDoc.save();

      // Automatically save copy to app documents folder
      final savedFile = await PdfBillGenerator.saveToAppDocuments(billData, bytes);

      setState(() {
        _currentBillData = billData;
        _pdfBytes = bytes;
        _savedDocPath = savedFile.path;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating bill: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  Future<void> _exportPdf() async {
    final l10n = AppLocalizations.of(context)!;
    if (_pdfBytes == null || _currentBillData == null) return;

    final path = await PdfBillGenerator.exportPdf(_currentBillData!, _pdfBytes!);
    if (path != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.billExportSuccess}: $path'),
          backgroundColor: AppTheme.accentTeal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(businessProfileStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sampleBilling),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading business: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Please complete business setup first.'));
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left control panel (Desktop ergonomics)
              SizedBox(
                width: 320,
                child: Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.sampleBillingSubtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _isGenerating ? null : _generateSamplePdf,
                          icon: _isGenerating
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.picture_as_pdf_outlined),
                          label: Text(l10n.generatePdf),
                        ),
                        const SizedBox(height: 12),
                        if (_pdfBytes != null) ...[
                          OutlinedButton.icon(
                            onPressed: _exportPdf,
                            icon: const Icon(Icons.download_rounded),
                            label: Text(l10n.exportPdf),
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: AppTheme.borderSubtle),
                          const SizedBox(height: 12),

                          // Document storage info
                          if (_savedDocPath != null) ...[
                            const Text(
                              'Saved internally to:',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SelectableText(
                              _savedDocPath!,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // QR Code inspection widget
                          if (_currentBillData != null) ...[
                            const Text(
                              'Embedded Bill QR:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.borderSubtle),
                                ),
                                child: QrImageView(
                                  data: _currentBillData!.qrData,
                                  version: QrVersions.auto,
                                  size: 110.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            SelectableText(
                              _currentBillData!.qrData,
                              style: const TextStyle(fontSize: 9, color: AppTheme.textMuted),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Right preview area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                  child: _pdfBytes == null
                      ? Card(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.receipt_long_rounded,
                                  size: 64,
                                  color: AppTheme.textMuted,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Click "${l10n.generatePdf}" to build bilingual invoice',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: AppTheme.textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Card(
                          clipBehavior: Clip.antiAlias,
                          child: PdfPreview(
                            build: (format) => _pdfBytes!,
                            allowPrinting: true,
                            allowSharing: false,
                            canChangeOrientation: false,
                            canChangePageFormat: false,
                            canDebug: false,
                            pdfFileName: '${_currentBillData?.invoiceNumber ?? "bill"}.pdf',
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
