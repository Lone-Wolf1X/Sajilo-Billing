import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/pos_cart_calculator.dart';
import '../../application/pos_cart_controller.dart';

class CartTable extends ConsumerWidget {
  const CartTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(posCartProvider);
    final controller = ref.read(posCartProvider.notifier);

    if (cart.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Cart is empty / कार्ट खाली छ\nScan or select an item to begin',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 8,
        headingRowHeight: 36,
        dataRowMinHeight: 40,
        dataRowMaxHeight: 56,
        columns: const [
          DataColumn(label: Text('#', style: TextStyle(fontSize: 11))),
          DataColumn(label: Text('Item', style: TextStyle(fontSize: 11))),
          DataColumn(label: Text('Qty', style: TextStyle(fontSize: 11)), numeric: true),
          DataColumn(label: Text('Rate', style: TextStyle(fontSize: 11)), numeric: true),
          DataColumn(label: Text('Total', style: TextStyle(fontSize: 11)), numeric: true),
          DataColumn(label: Text('', style: TextStyle(fontSize: 11))),
        ],
        rows: List.generate(cart.lines.length, (i) {
          final line = cart.lines[i];
          final totals = PosCartCalculator.computeLine(line);
          return DataRow(cells: [
            DataCell(Text('${i + 1}', style: const TextStyle(fontSize: 12))),
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  line.name,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  line.sku,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            )),
            DataCell(_QtyCell(
              value: line.quantity,
              onChanged: (v) => controller.updateQuantity(i, v),
            )),
            DataCell(SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: line.unitPrice.toStringAsFixed(2),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onFieldSubmitted: (v) {
                  final d = double.tryParse(v);
                  if (d != null) controller.updatePrice(i, d);
                },
              ),
            )),
            DataCell(Text(
              'Rs. ${_fmtAmount(totals.lineTotal)}',
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              textAlign: TextAlign.right,
            )),
            DataCell(IconButton(
              icon: const Icon(Icons.close, size: 16),
              color: Colors.red,
              onPressed: () => controller.removeAt(i),
              splashRadius: 16,
              padding: EdgeInsets.zero,
            )),
          ]);
        }),
      ),
    );
  }

  String _fmtAmount(String v) {
    final d = double.tryParse(v) ?? 0.0;
    return d.toStringAsFixed(2);
  }
}

class _QtyCell extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  const _QtyCell({required this.value, required this.onChanged});

  @override
  State<_QtyCell> createState() => _QtyCellState();
}

class _QtyCellState extends State<_QtyCell> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: _fmt(widget.value));
  }

  @override
  void didUpdateWidget(covariant _QtyCell old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _ctrl.text = _fmt(widget.value);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _fmt(double v) => v == v.toInt() ? v.toInt().toString() : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => widget.onChanged(widget.value - 1),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.remove_circle_outline, size: 16),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _ctrl,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onFieldSubmitted: (v) {
                final d = double.tryParse(v);
                if (d != null) widget.onChanged(d);
              },
            ),
          ),
          InkWell(
            onTap: () => widget.onChanged(widget.value + 1),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.add_circle_outline, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

