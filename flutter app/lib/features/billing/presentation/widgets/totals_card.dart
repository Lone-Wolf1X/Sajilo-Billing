import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/pos_cart_controller.dart';

class TotalsCard extends ConsumerWidget {
  const TotalsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = ref.watch(posCartProvider).totals;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _row('Subtotal (उप-जम्मा)', totals.subtotal),
          if ((double.tryParse(totals.discountTotal) ?? 0) > 0)
            _row('Discount (छुट)', '- ${_fmt(totals.discountTotal)}'),
          _row('Taxable Amount (करयोग्य रकम)', totals.taxableAmount),
          _row('13% VAT (मूल्य अभिवृद्धि कर)', totals.taxAmount),
          const Divider(height: 20, thickness: 1.5),
          _row('Grand Total (कुल रकम)', totals.totalAmount, bold: true, large: true),
        ],
      ),
    );
  }

  Widget _row(String label, String amount, {bool bold = false, bool large = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: large ? 15 : 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: const Color(0xFF1E293B),
            ),
          ),
          Text(
            'Rs. ${_fmt(amount)}',
            style: TextStyle(
              fontSize: large ? 18 : 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontFamily: 'monospace',
              color: large ? const Color(0xFF1E3A8A) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(String v) {
    final d = double.tryParse(v) ?? 0.0;
    final parts = d.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    final n = intPart.replaceFirst('-', '');
    for (int i = 0; i < n.length; i++) {
      if (i > 0 && (n.length - i) % 3 == 0) buffer.write(',');
      buffer.write(n[i]);
    }
    final sign = intPart.startsWith('-') ? '-' : '';
    return '$sign${buffer.toString()}.$decPart';
  }
}
