import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/paisa_helper.dart';
import '../data/khata_pdf_generator.dart';
import '../domain/khata_models.dart';
import 'khata_provider.dart';
import 'widgets/payment_dialog.dart';

class PartyLedgerDetailScreen extends ConsumerWidget {
  final PartySummary party;

  const PartyLedgerDetailScreen({
    super.key,
    required this.party,
  });

  Future<void> _handleWhatsAppReminder(BuildContext context, WidgetRef ref) async {
    if (party.phone == null || party.phone!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number recorded for this party.')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final business = await (db.select(db.businessProfiles)..limit(1)).getSingle();
    final message = party.generateWhatsAppReminderMessage(shopName: business.businessName);

    // Clean Nepali mobile phone format
    var phoneDigits = party.phone!.replaceAll(RegExp(r'[^0-9]'), '');
    if (phoneDigits.length == 10) {
      phoneDigits = '977$phoneDigits';
    }

    final url = Uri.parse('https://wa.me/$phoneDigits?text=${Uri.encodeComponent(message)}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _handlePrintStatement(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final business = await (db.select(db.businessProfiles)..limit(1)).getSingle();
    final repo = ref.read(khataRepositoryProvider);
    final entries = await repo.watchPartyLedger(party.id).first;

    final doc = await KhataPdfGenerator.generateStatementPdf(
      business: business,
      party: party,
      entries: entries,
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCustomer = party.partyType == PartyType.customer;
    final ledgerAsync = ref.watch(partyLedgerStreamProvider(party.id));
    final currencyFormat = NumberFormat('#,##,##0.00', 'en_IN');

    return Scaffold(
      appBar: AppBar(
        title: Text('${party.name} - Ledger Statement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print Statement PDF',
            onPressed: () => _handlePrintStatement(context, ref),
          ),
          if (isCustomer && party.phone != null && party.phone!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              tooltip: 'Send WhatsApp Reminder',
              onPressed: () => _handleWhatsAppReminder(context, ref),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Summary Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isCustomer
                                          ? AppTheme.primaryBlue.withOpacity(0.12)
                                          : AppTheme.accentTeal.withOpacity(0.12),
                                      child: Icon(
                                        isCustomer ? Icons.person : Icons.local_shipping,
                                        color: isCustomer ? AppTheme.primaryBlue : AppTheme.accentTeal,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          party.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        if (party.phone != null)
                                          Text(
                                            'Phone: ${party.phone}',
                                            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Current Due Balance
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  isCustomer ? 'Net Due (उठाउन बाँकी)' : 'Net Payable (तिर्नुपर्ने)',
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  party.formattedBalance,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: party.currentBalancePaisa > 0 ? Colors.redAccent : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatColumn('Total Credit (कुल उधारो)', party.totalCreditPaisa),
                            _buildStatColumn('Total Settled (जम्मा भुक्तानी)', party.totalSettledPaisa),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.payment, size: 18),
                              label: Text(isCustomer ? 'Receive Payment' : 'Pay Supplier'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => PaymentDialog(party: party),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Transactions Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ledger Transactions (हिसाब किताब विवरण)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                      label: const Text('Export Statement PDF'),
                      onPressed: () => _handlePrintStatement(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Ledger Table
                ledgerAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e', style: const TextStyle(color: Colors.red)),
                  data: (entries) {
                    if (entries.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: const Text('No transactions recorded yet in this Khata.'),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(AppTheme.backgroundLight),
                          columns: [
                            const DataColumn(label: Text('Date / मिति')),
                            const DataColumn(label: Text('Ref # / भौचर नं.')),
                            const DataColumn(label: Text('Particulars / विवरण')),
                            DataColumn(label: Text(isCustomer ? 'Debit / लिनुपर्ने' : 'Debit / भुक्तानी'), numeric: true),
                            DataColumn(label: Text(isCustomer ? 'Credit / असुली' : 'Credit / खरिद'), numeric: true),
                            const DataColumn(label: Text('Balance / बाँकी'), numeric: true),
                          ],
                          rows: entries.map((e) {
                            final dateStr = DateFormat('yyyy-MM-dd').format(e.entryDate.toLocal());
                            final amt = currencyFormat.format(e.amountPaisa / 100.0);
                            final bal = currencyFormat.format(e.balanceAfterPaisa / 100.0);

                            final isDebit = (isCustomer && e.entryType == 'sale_credit') ||
                                (!isCustomer && e.entryType == 'payment_made');

                            return DataRow(
                              cells: [
                                DataCell(Text(dateStr, style: const TextStyle(fontSize: 12))),
                                DataCell(Text(e.refNumber ?? '-', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                                DataCell(Text(e.notes ?? e.entryType, style: const TextStyle(fontSize: 12))),
                                DataCell(Text(isDebit ? 'Rs. $amt' : '-', style: const TextStyle(fontSize: 12, color: Colors.redAccent))),
                                DataCell(Text(!isDebit ? 'Rs. $amt' : '-', style: const TextStyle(fontSize: 12, color: Colors.green))),
                                DataCell(Text('Rs. $bal', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int amountPaisa) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        const SizedBox(height: 2),
        Text(
          PaisaHelper.formatPaisa(amountPaisa),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

