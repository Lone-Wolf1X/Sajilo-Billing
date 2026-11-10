import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pos_cart_calculator.dart';

class PosCartState {
  final List<PosCartLine> lines;
  final int? customerId;
  final int? warehouseId;
  final String? notes;

  const PosCartState({
    required this.lines,
    this.customerId,
    this.warehouseId,
    this.notes,
  });

  PosCartState copyWith({
    List<PosCartLine>? lines,
    int? customerId,
    int? warehouseId,
    String? notes,
    bool clearCustomer = false,
  }) {
    return PosCartState(
      lines: lines ?? this.lines,
      customerId: clearCustomer ? null : (customerId ?? this.customerId),
      warehouseId: warehouseId ?? this.warehouseId,
      notes: notes ?? this.notes,
    );
  }

  PosCartTotals get totals => PosCartCalculator.computeCart(lines);
  bool get isEmpty => lines.isEmpty;
}

class PosCartController extends StateNotifier<PosCartState> {
  PosCartController() : super(const PosCartState(lines: []));

  void addItem(PosCartLine line) {
    // Check if same item already in cart (by itemId). Merge quantities.
    final idx = state.lines.indexWhere((l) => l.itemId == line.itemId);
    if (idx >= 0) {
      final existing = state.lines[idx];
      final merged = existing.copyWith(
        quantity: existing.quantity + line.quantity,
      );
      final updated = [...state.lines];
      updated[idx] = merged;
      state = state.copyWith(lines: updated);
    } else {
      state = state.copyWith(lines: [...state.lines, line]);
    }
  }

  void updateQuantity(int index, double qty) {
    if (index < 0 || index >= state.lines.length) return;
    if (qty <= 0) {
      removeAt(index);
      return;
    }
    final updated = [...state.lines];
    updated[index] = updated[index].copyWith(quantity: qty);
    state = state.copyWith(lines: updated);
  }

  void updatePrice(int index, double price) {
    if (index < 0 || index >= state.lines.length) return;
    final updated = [...state.lines];
    updated[index] = updated[index].copyWith(unitPrice: price);
    state = state.copyWith(lines: updated);
  }

  void updateDiscount(int index, double discount) {
    if (index < 0 || index >= state.lines.length) return;
    final updated = [...state.lines];
    updated[index] = updated[index].copyWith(discountAmount: discount);
    state = state.copyWith(lines: updated);
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.lines.length) return;
    final updated = [...state.lines]..removeAt(index);
    state = state.copyWith(lines: updated);
  }

  void setCustomer(int? customerId) {
    state = customerId == null
        ? state.copyWith(clearCustomer: true)
        : state.copyWith(customerId: customerId);
  }

  void setWarehouse(int? warehouseId) {
    state = state.copyWith(warehouseId: warehouseId);
  }

  void setNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  void clear() {
    state = const PosCartState(lines: []);
  }
}

final posCartProvider = StateNotifierProvider<PosCartController, PosCartState>((ref) {
  return PosCartController();
});
