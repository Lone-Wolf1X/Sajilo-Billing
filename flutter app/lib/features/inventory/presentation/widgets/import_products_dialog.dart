import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/paisa_helper.dart';
import '../../data/inventory_import_export_service.dart';
import '../inventory_provider.dart';

class ImportProductsDialog extends ConsumerStatefulWidget {
  const ImportProductsDialog({super.key});

  @override
  ConsumerState<ImportProductsDialog> createState() => _ImportProductsDialogState();
}

class _ImportProductsDialogState extends ConsumerState<ImportProductsDialog> {
  String? _selectedFileName;
  List<ProductImportRow>? _parsedRows;
  bool _isParsing = false;
  bool _isImporting = false;
  String? _errorMessage;
  ImportResult? _importResult;

  Future<void> _downloadTemplate({required bool isExcel}) async {
    try {
      final service = ref.read(inventoryImportExportServiceProvider);
      final path = await service.downloadTemplate(isExcel: isExcel);
      if (path != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Template downloaded successfully: $path'),
            backgroundColor: AppTheme.accentTeal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Template download failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _pickAndParseFile() async {
    try {
      const typeGroup = XTypeGroup(
        label: 'CSV or Excel Spreadsheets',
        extensions: ['csv', 'xlsx', 'xls'],
      );

      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) return;

      setState(() {
        _isParsing = true;
        _errorMessage = null;
        _selectedFileName = file.name;
        _parsedRows = null;
        _importResult = null;
      });

      final bytes = await file.readAsBytes();
      final isExcel = file.name.toLowerCase().endsWith('.xlsx') || file.name.toLowerCase().endsWith('.xls');

      final service = ref.read(inventoryImportExportServiceProvider);
      final rows = isExcel ? service.parseExcel(bytes) : service.parseCsv(bytes);

      setState(() {
        _isParsing = false;
        if (rows.isEmpty) {
          _errorMessage = 'No valid product rows found in the selected file. Please verify columns match the template.';
        } else {
          _parsedRows = rows;
        }
      });
    } catch (e) {
      setState(() {
        _isParsing = false;
        _errorMessage = 'Failed to read file: $e';
      });
    }
  }

  Future<void> _executeImport() async {
    if (_parsedRows == null || _parsedRows!.isEmpty) return;

    setState(() {
      _isImporting = true;
      _errorMessage = null;
    });

    try {
      final service = ref.read(inventoryImportExportServiceProvider);
      final result = await service.importRows(_parsedRows!);

      setState(() {
        _isImporting = false;
        _importResult = result;
      });

      // Invalidate items stream so inventory refreshes immediately
      ref.invalidate(itemsStreamProvider);
      ref.invalidate(categoriesStreamProvider);

      if (mounted && !result.hasErrors) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully imported ${result.insertedCount} new items and updated ${result.updatedCount} existing items!',
            ),
            backgroundColor: AppTheme.accentTeal,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isImporting = false;
        _errorMessage = 'Import failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.file_upload_outlined, color: AppTheme.primaryBlue, size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bulk Import Products / सामान अपलोड',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Upload CSV or Excel (.xlsx) file to add or update your item catalog.',
                          style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24, color: AppTheme.borderSubtle),

              // Step 1: Download Templates
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20, color: AppTheme.primaryBlue),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Step 1: Download official sample template with proper column formatting:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _downloadTemplate(isExcel: false),
                      icon: const Icon(Icons.download, size: 15),
                      label: const Text('CSV Template'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _downloadTemplate(isExcel: true),
                      icon: const Icon(Icons.table_chart, size: 15),
                      label: const Text('Excel (.xlsx) Template'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D6F42),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Step 2: File Picker & Status
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isImporting ? null : _pickAndParseFile,
                    icon: const Icon(Icons.folder_open, size: 18),
                    label: Text(_selectedFileName == null ? 'Step 2: Choose File (.csv / .xlsx)' : 'Choose Different File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 14),
                  if (_selectedFileName != null)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            _selectedFileName!.endsWith('.xlsx') || _selectedFileName!.endsWith('.xls')
                                ? Icons.table_chart
                                : Icons.description,
                            color: AppTheme.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _selectedFileName!,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_parsedRows != null) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accentTeal.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${_parsedRows!.length} products detected',
                                style: const TextStyle(
                                  color: AppTheme.accentTeal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Error or status warning
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12.5),
                  ),
                ),

              // Partial error summary if import finished with errors
              if (_importResult != null && _importResult!.hasErrors)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Import completed: ${_importResult!.insertedCount} added, ${_importResult!.updatedCount} updated, ${_importResult!.failedCount} failed.',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Errors: ${_importResult!.errors.take(3).join("; ")}',
                        style: const TextStyle(fontSize: 11.5, color: Colors.deepOrange),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 10),

              // Step 3: Table Preview of Parsed Rows
              Expanded(
                child: _isParsing
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text('Reading and parsing file rows...'),
                          ],
                        ),
                      )
                    : _parsedRows != null && _parsedRows!.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.borderSubtle),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(AppTheme.backgroundLight),
                                    columnSpacing: 18,
                                    dataRowMinHeight: 36,
                                    dataRowMaxHeight: 44,
                                    columns: const [
                                      DataColumn(label: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Nepali Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Unit', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Cost Price', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Selling Price', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold))),
                                    ],
                                    rows: List.generate(_parsedRows!.length, (index) {
                                      final row = _parsedRows![index];
                                      return DataRow(
                                        cells: [
                                          DataCell(Text('${index + 1}')),
                                          DataCell(Text(row.sku, style: const TextStyle(fontFamily: 'monospace', fontSize: 12))),
                                          DataCell(Text(row.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                          DataCell(Text(row.nepaliName ?? '-')),
                                          DataCell(Text(row.category ?? 'General')),
                                          DataCell(Text(row.unit)),
                                          DataCell(Text(PaisaHelper.formatPaisa(PaisaHelper.toPaisa(row.purchasePrice)))),
                                          DataCell(Text(PaisaHelper.formatPaisa(PaisaHelper.toPaisa(row.sellingPrice)))),
                                          DataCell(Text('${row.stockQty}')),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload_outlined, size: 54, color: Colors.grey.shade400),
                                const SizedBox(height: 10),
                                Text(
                                  _selectedFileName == null
                                      ? 'No file selected yet. Download template or choose file above.'
                                      : 'No rows detected.',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
              ),

              const Divider(height: 24, color: AppTheme.borderSubtle),

              // Bottom Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isImporting ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel / रद्द गर्नुहोस्'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: (_parsedRows == null || _parsedRows!.isEmpty || _isImporting) ? null : _executeImport,
                    icon: _isImporting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(
                      _isImporting
                          ? 'Importing into Database...'
                          : 'Import ${_parsedRows?.length ?? 0} Products',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
