import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';

class CustomerSelector extends ConsumerWidget {
  final int? value;
  final ValueChanged<int?> onChange;
  final String label;

  const CustomerSelector({
    super.key,
    required this.value,
    required this.onChange,
    this.label = 'Customer',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersListProvider);

    return customersAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text(
        'Error loading customers: $e',
        style: const TextStyle(color: Colors.red),
      ),
      data: (customers) {
        // Ensure walk-in customer exists
        final hasWalkIn = customers.any((c) => c.customerCode == 'WALK-IN');

        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: value,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: customers
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(
                            '${c.customerName} (${c.customerCode})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: onChange,
              ),
            ),
            if (!hasWalkIn) ...[
              const SizedBox(width: 8),
              Tooltip(
                message: 'Create walk-in customer',
                child: IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () async {
                    final repo = ref.read(customersRepositoryProvider);
                    try {
                      await repo.createCustomer(
                        customerCode: 'WALK-IN',
                        customerName: 'Walk-in Customer / नगद ग्राहक',
                      );
                      ref.invalidate(customersListProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Walk-in customer created')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
