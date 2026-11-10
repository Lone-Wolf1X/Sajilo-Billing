import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';

class ReportsDashboardScreen extends ConsumerStatefulWidget {
  const ReportsDashboardScreen({super.key});

  @override
  ConsumerState<ReportsDashboardScreen> createState() => _ReportsDashboardScreenState();
}

class _ReportsDashboardScreenState extends ConsumerState<ReportsDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: Color(0xFF1E3A8A), size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial Reports & IRD Registers / वित्तीय विवरण तथा कर खाता',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Real-time double-entry trial balance, P&L, balance sheet, and Nepal IRD Annex 13 (D-01/D-02)',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tab bar
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFCBD5E1))),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: const Color(0xFF1E3A8A),
                unselectedLabelColor: const Color(0xFF64748B),
                indicatorColor: const Color(0xFF1E3A8A),
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Trial Balance (सन्तुलन परीक्षण)'),
                  Tab(text: 'Profit & Loss (नाफा नोक्सान)'),
                  Tab(text: 'Balance Sheet (वासलात)'),
                  Tab(text: 'IRD D-01 Sales (बिक्री खाता)'),
                  Tab(text: 'IRD D-02 Purchase (खरिद खाता)'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _TrialBalanceView(),
                  _ProfitLossView(),
                  _BalanceSheetView(),
                  _IrdSalesBookView(),
                  _IrdPurchaseBookView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================== 1. TRIAL BALANCE VIEW ===================
class _TrialBalanceView extends ConsumerWidget {
  const _TrialBalanceView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now().toIso8601String().split('T').first;
    final tbAsync = ref.watch(
      FutureProvider.autoDispose((ref) async {
        final api = ref.read(apiClientProvider);
        return api.get<Map<String, dynamic>>('/reports/trial-balance?asOf=$today');
      }),
    );

    return tbAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      data: (data) {
        final rows = (data['rows'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
        final balanced = data['balanced'] as bool? ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('As of: $today', style: const TextStyle(fontWeight: FontWeight.w600)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: balanced ? const Color(0xFFDEF7EC) : const Color(0xFFFDE8E8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(balanced ? Icons.check_circle : Icons.error, size: 14, color: balanced ? const Color(0xFF03543F) : Colors.red),
                      const SizedBox(width: 6),
                      Text(
                        balanced ? 'BALANCED (डेबिट = क्रेडिट)' : 'OUT OF BALANCE',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: balanced ? const Color(0xFF03543F) : Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Color(0xFFE2E8F0))),
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
                    columns: const [
                      DataColumn(label: Text('CODE', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('ACCOUNT NAME', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('TYPE', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('DEBIT (रु)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('CREDIT (रु)', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: rows.map((r) {
                      final dr = (r['debitBalance'] as num?)?.toDouble() ?? 0.0;
                      final cr = (r['creditBalance'] as num?)?.toDouble() ?? 0.0;
                      return DataRow(cells: [
                        DataCell(Text(r['accountCode'] as String? ?? '', style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold))),
                        DataCell(Text(r['accountName'] as String? ?? '')),
                        DataCell(Text(r['accountType'] as String? ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
                        DataCell(Text(dr > 0 ? dr.toStringAsFixed(2) : '—', style: TextStyle(fontWeight: dr > 0 ? FontWeight.bold : FontWeight.normal))),
                        DataCell(Text(cr > 0 ? cr.toStringAsFixed(2) : '—', style: TextStyle(fontWeight: cr > 0 ? FontWeight.bold : FontWeight.normal))),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// =================== 2. PROFIT & LOSS VIEW ===================
class _ProfitLossView extends ConsumerWidget {
  const _ProfitLossView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = DateTime.now().year;
    final plAsync = ref.watch(
      FutureProvider.autoDispose((ref) async {
        final api = ref.read(apiClientProvider);
        return api.get<Map<String, dynamic>>('/reports/profit-loss?from=$year-01-01&to=$year-12-31');
      }),
    );

    return plAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      data: (data) {
        final revLines = (data['revenueLines'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
        final expLines = (data['expenseLines'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
        final totRev = data['totalRevenue']?['amount']?.toString() ?? '0.00';
        final totExp = data['totalExpenses']?['amount']?.toString() ?? '0.00';
        final netProfit = data['netProfit']?['amount']?.toString() ?? '0.00';
        final isProfit = data['profitable'] as bool? ?? true;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: isProfit ? const Color(0xFFDEF7EC) : const Color(0xFFFDE8E8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isProfit ? 'NET PROFIT (खुद नाफा):' : 'NET LOSS (खुद नोक्सान):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isProfit ? const Color(0xFF03543F) : Colors.red),
                      ),
                      Text(
                        'Rs. $netProfit',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: isProfit ? const Color(0xFF03543F) : Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Revenues Table
              _reportTable('Revenues (आम्दानी)', revLines, totRev, const Color(0xFF059669)),
              const SizedBox(height: 16),

              // Expenses Table
              _reportTable('Expenses (खर्च)', expLines, totExp, const Color(0xFFDC2626)),
            ],
          ),
        );
      },
    );
  }

  Widget _reportTable(String title, List<Map<String, dynamic>> lines, String total, Color color) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
            const Divider(),
            ...lines.map((l) {
              final amt = l['amount']?['amount']?.toString() ?? '0.00';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${l['accountCode']} — ${l['accountName']}'),
                    Text('Rs. $amt', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                  ],
                ),
              );
            }),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Rs. $total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color, fontFamily: 'monospace')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =================== 3. BALANCE SHEET VIEW ===================
class _BalanceSheetView extends ConsumerWidget {
  const _BalanceSheetView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now().toIso8601String().split('T').first;
    final bsAsync = ref.watch(
      FutureProvider.autoDispose((ref) async {
        final api = ref.read(apiClientProvider);
        return api.get<Map<String, dynamic>>('/reports/balance-sheet?asOf=$today');
      }),
    );

    return bsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      data: (data) {
        final assets = (data['assets'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
        final liabilities = (data['liabilities'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
        final totAssets = data['totalAssets']?['amount']?.toString() ?? '0.00';
        final totLiabEquity = data['totalLiabilitiesAndEquity']?['amount']?.toString() ?? '0.00';
        final balanced = data['balanced'] as bool? ?? false;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: balanced ? const Color(0xFFDEF7EC) : const Color(0xFFFDE8E8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        balanced ? 'ASSETS = LIABILITIES + EQUITY (सन्तुलित)' : 'OUT OF BALANCE',
                        style: TextStyle(fontWeight: FontWeight.bold, color: balanced ? const Color(0xFF03543F) : Colors.red),
                      ),
                      Text('Total: Rs. $totAssets', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _bsSection('Assets (सम्पत्ति)', assets, totAssets, const Color(0xFF2563EB)),
              const SizedBox(height: 16),
              _bsSection('Liabilities (दायित्व)', liabilities, totLiabEquity, const Color(0xFFD97706)),
            ],
          ),
        );
      },
    );
  }

  Widget _bsSection(String title, List<Map<String, dynamic>> lines, String total, Color color) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
            const Divider(),
            ...lines.map((l) {
              final amt = l['amount']?['amount']?.toString() ?? '0.00';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${l['accountCode']} — ${l['accountName']}'),
                    Text('Rs. $amt', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                  ],
                ),
              );
            }),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Rs. $total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color, fontFamily: 'monospace')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =================== 4. IRD D-01 SALES BOOK ===================
class _IrdSalesBookView extends ConsumerWidget {
  const _IrdSalesBookView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d01Async = ref.watch(
      FutureProvider.autoDispose((ref) async {
        final api = ref.read(apiClientProvider);
        final list = await api.get<List<dynamic>>('/reports/ird/d01-sales');
        return list.cast<Map<String, dynamic>>();
      }),
    );

    return d01Async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      data: (rows) {
        if (rows.isEmpty) {
          return const Center(child: Text('No sales records in D-01 register'));
        }

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Color(0xFFE2E8F0))),
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
              columns: const [
                DataColumn(label: Text('DATE (मिति)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('INVOICE NO (बिजक नं)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('BUYER NAME (खरिदकर्ता)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('PAN NO (प्यान)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('TOTAL SALES (कुल)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('TAXABLE (कर योग्य)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('13% VAT (कर रकम)', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: rows.map((r) {
                return DataRow(cells: [
                  DataCell(Text('${r['dateBs'] ?? r['dateAd']}')),
                  DataCell(Text(r['invoiceNumber'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'))),
                  DataCell(Text(r['customerName'] ?? '—')),
                  DataCell(Text(r['customerPan'] ?? '—')),
                  DataCell(Text('Rs. ${r['totalAmount']}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('Rs. ${r['taxableAmount']}')),
                  DataCell(Text('Rs. ${r['vatAmount']}', style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold))),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// =================== 5. IRD D-02 PURCHASE BOOK ===================
class _IrdPurchaseBookView extends ConsumerWidget {
  const _IrdPurchaseBookView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d02Async = ref.watch(
      FutureProvider.autoDispose((ref) async {
        final api = ref.read(apiClientProvider);
        final list = await api.get<List<dynamic>>('/reports/ird/d02-purchases');
        return list.cast<Map<String, dynamic>>();
      }),
    );

    return d02Async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      data: (rows) {
        if (rows.isEmpty) {
          return const Center(child: Text('No purchase records in D-02 register'));
        }

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Color(0xFFE2E8F0))),
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
              columns: const [
                DataColumn(label: Text('DATE (मिति)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('BILL NO (बीजक नं)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('SUPPLIER (आपूर्तिकर्ता)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('PAN NO (प्यान)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('TOTAL PURCHASE (कुल)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('TAXABLE (कर योग्य)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('13% VAT (कर रकम)', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: rows.map((r) {
                return DataRow(cells: [
                  DataCell(Text('${r['dateBs'] ?? r['dateAd']}')),
                  DataCell(Text(r['invoiceNumber'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'))),
                  DataCell(Text(r['supplierName'] ?? '—')),
                  DataCell(Text(r['supplierPan'] ?? '—')),
                  DataCell(Text('Rs. ${r['totalAmount']}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('Rs. ${r['taxableAmount']}')),
                  DataCell(Text('Rs. ${r['vatAmount']}', style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold))),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
