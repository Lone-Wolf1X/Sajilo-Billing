import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../inventory/data/saisa_item.dart';
import '../../application/pos_cart_calculator.dart';
import '../../application/pos_cart_controller.dart';

class ItemPicker extends ConsumerStatefulWidget {
  const ItemPicker({super.key});

  @override
  ConsumerState<ItemPicker> createState() => _ItemPickerState();
}

class _ItemPickerState extends ConsumerState<ItemPicker> {
  final _search = TextEditingController();
  List<SaisaItem> _filtered = [];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(List<SaisaItem> all, String term) {
    final t = term.trim().toLowerCase();
    setState(() {
      _filtered = t.isEmpty
          ? all
          : all
              .where((i) =>
                  i.sku.toLowerCase().contains(t) ||
                  i.name.toLowerCase().contains(t))
              .toList();
    });
  }

  void _addItem(SaisaItem item) {
    final controller = ref.read(posCartProvider.notifier);
    controller.addItem(PosCartLine(
      itemId: item.id.toString(),
      sku: item.sku,
      name: item.name,
      quantity: 1,
      unitPrice: double.tryParse(item.salePrice) ?? 0,
      taxRate: 0.13, // Standard Nepal VAT
    ));
    _search.clear();
    setState(() => _filtered = []);
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _search,
          decoration: InputDecoration(
            hintText: 'Search item by SKU or name / Scan barcode…',
            prefixIcon: const Icon(Icons.search, size: 20),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: (v) => itemsAsync.whenData((all) => _onSearchChanged(all, v)),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: itemsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('Error loading items: $e', style: const TextStyle(color: Colors.red)),
            ),
            data: (all) {
              final display = _search.text.isEmpty ? all : _filtered;
              if (display.isEmpty) {
                return const Center(
                  child: Text('No items found', style: TextStyle(color: Colors.grey)),
                );
              }
              return ListView.separated(
                itemCount: display.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                itemBuilder: (_, i) {
                  final item = display[i];
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(0xFFEFF6FF),
                      child: Text(
                        item.sku.isNotEmpty ? item.sku.substring(0, 1).toUpperCase() : 'P',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${item.sku} · ${item.unitOfMeasure}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    trailing: Text(
                      'Rs. ${(double.tryParse(item.salePrice) ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    onTap: () => _addItem(item),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
