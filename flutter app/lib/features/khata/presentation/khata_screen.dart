import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/paisa_helper.dart';
import '../domain/khata_models.dart';
import 'khata_provider.dart';
import 'party_ledger_detail_screen.dart';
import 'widgets/payment_dialog.dart';

/// Main Khata Screen supporting bilingual Customer Credit (उधारो लिन बाँकी)
/// and Supplier Payables (आपूर्तिकर्ता तिर्न बाँकी) tracking.
class KhataScreen extends ConsumerStatefulWidget {
  const KhataScreen({super.key});

  @override
  ConsumerState<KhataScreen> createState() => _KhataScreenState();
}

class _KhataScreenState extends ConsumerState<KhataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _customerSearchController = TextEditingController();
  final _supplierSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customerSearchController.dispose();
    _supplierSearchController.dispose();
    super.dispose();
  }

  Future<void> _showAddPartyDialog(BuildContext context, PartyType type) async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final panController = TextEditingController();
    final addressController = TextEditingController();
    final isCustomer = type == PartyType.customer;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isCustomer ? 'Add New Customer (नयाँ ग्राहक)' : 'Add New Supplier (नयाँ आपूर्तिकर्ता)'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: isCustomer ? 'Customer Name *' : 'Supplier Name *',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (फोन नं.)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: panController,
                decoration: const InputDecoration(
                  labelText: 'PAN / VAT (प्यान नं.)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address (ठेगाना)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final repo = ref.read(khataRepositoryProvider);
              if (isCustomer) {
                await repo.getOrCreateCustomer(
                  name: name,
                  phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                  panVat: panController.text.trim().isEmpty ? null : panController.text.trim(),
                  address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
                );
              }
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Save Party'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync = ref.watch(khataOverallMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Khata Ledger (उधारो खाता हिसाब)'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          indicatorColor: AppTheme.primaryBlue,
          tabs: const [
            Tab(
              icon: Icon(Icons.people_outline),
              text: 'Customer Khata (ग्राहक उधारो)',
            ),
            Tab(
              icon: Icon(Icons.local_shipping_outlined),
              text: 'Supplier Khata (आपूर्तिकर्ता हिसाब)',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Top Overall Metrics Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: metricsAsync.when(
              loading: () => const Center(child: LinearProgressIndicator()),
              error: (e, _) => Text('Error loading metrics: $e', style: const TextStyle(color: Colors.red)),
              data: (m) => Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Total Customer Due (कुल लिन बाँकी)',
                      amountPaisa: m.totalCustomerReceivablePaisa,
                      subtitle: '${m.customersWithDuesCount} customers with pending balance',
                      icon: Icons.account_balance_wallet_outlined,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Total Supplier Due (कुल तिर्न बाँकी)',
                      amountPaisa: m.totalSupplierPayablePaisa,
                      subtitle: '${m.suppliersWithDuesCount} suppliers pending payout',
                      icon: Icons.outbox_outlined,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderSubtle),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCustomerKhataTab(),
                _buildSupplierKhataTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerKhataTab() {
    final customersAsync = ref.watch(customerKhataStreamProvider);
    final onlyDues = ref.watch(customerKhataOnlyDuesProvider);

    return Column(
      children: [
        // Filter bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customerSearchController,
                  onChanged: (val) => ref.read(customerKhataSearchProvider.notifier).state = val,
                  decoration: InputDecoration(
                    hintText: 'Search customer by name or phone...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('Only Pending Dues (उधारो बाँकी मात्र)'),
                selected: onlyDues,
                onSelected: (val) => ref.read(customerKhataOnlyDuesProvider.notifier).state = val,
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text('Add Customer'),
                onPressed: () => _showAddPartyDialog(context, PartyType.customer),
              ),
            ],
          ),
        ),

        // Customer Cards List
        Expanded(
          child: customersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
            data: (customers) {
              if (customers.isEmpty) {
                return const Center(
                  child: Text('No customers found matching criteria.'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: customers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return _buildPartyCard(customer);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSupplierKhataTab() {
    final suppliersAsync = ref.watch(supplierKhataStreamProvider);
    final onlyDues = ref.watch(supplierKhataOnlyDuesProvider);

    return Column(
      children: [
        // Filter bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _supplierSearchController,
                  onChanged: (val) => ref.read(supplierKhataSearchProvider.notifier).state = val,
                  decoration: InputDecoration(
                    hintText: 'Search supplier by name or phone...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('Only Pending Payables (तिर्न बाँकी मात्र)'),
                selected: onlyDues,
                onSelected: (val) => ref.read(supplierKhataOnlyDuesProvider.notifier).state = val,
              ),
            ],
          ),
        ),

        // Supplier Cards List
        Expanded(
          child: suppliersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
            data: (suppliers) {
              if (suppliers.isEmpty) {
                return const Center(
                  child: Text('No suppliers recorded yet.'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: suppliers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final supplier = suppliers[index];
                  return _buildPartyCard(supplier);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPartyCard(PartySummary party) {
    final isCustomer = party.partyType == PartyType.customer;
    final hasDues = party.currentBalancePaisa > 0;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PartyLedgerDetailScreen(party: party),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isCustomer
                    ? AppTheme.primaryBlue.withOpacity(0.12)
                    : AppTheme.accentTeal.withOpacity(0.12),
                child: Icon(
                  isCustomer ? Icons.person_outline : Icons.local_shipping_outlined,
                  color: isCustomer ? AppTheme.primaryBlue : AppTheme.accentTeal,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (party.phone != null) ...[
                          Text(party.phone!, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                          const SizedBox(width: 10),
                        ],
                        if (party.panVat != null)
                          Text('PAN: ${party.panVat}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isCustomer ? 'Net Due (लिन बाँकी)' : 'Net Payable (तिर्न बाँकी)',
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    party.formattedBalance,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: hasDues ? Colors.redAccent : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: const Size(0, 36),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => PaymentDialog(party: party),
                  );
                },
                child: Text(isCustomer ? 'Receive Payment' : 'Pay'),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required int amountPaisa,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                const SizedBox(height: 2),
                Text(
                  PaisaHelper.formatPaisa(amountPaisa),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

