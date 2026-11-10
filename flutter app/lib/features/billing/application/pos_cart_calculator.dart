/// Pure calculator that mirrors SAISA backend's rounding logic exactly.
///
/// Backend (BillingService.computeSalesTotals):
///   lineSubtotal = qty * unitPrice   (round HALF_EVEN 4dp)
///   lineTax      = lineSubtotal * taxRate (round HALF_EVEN 4dp)
///   lineTotal    = lineSubtotal + lineTax
///   subtotal = Σ lineSubtotal
///   taxAmount = Σ lineTax
///   totalAmount = Σ lineTotal
class PosCartLine {
  final String itemId; // SAISA itemId as string
  final String sku;
  final String name;
  final double quantity;
  final double unitPrice;
  final double taxRate; // 0.13 for 13%
  final double discountAmount; // absolute rupees, per line

  const PosCartLine({
    required this.itemId,
    required this.sku,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.taxRate,
    this.discountAmount = 0,
  });

  PosCartLine copyWith({
    double? quantity,
    double? unitPrice,
    double? taxRate,
    double? discountAmount,
  }) {
    return PosCartLine(
      itemId: itemId,
      sku: sku,
      name: name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      taxRate: taxRate ?? this.taxRate,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}

class PosLineTotals {
  final String lineSubtotal;
  final String lineTax;
  final String lineTotal;
  final String discount;

  const PosLineTotals({
    required this.lineSubtotal,
    required this.lineTax,
    required this.lineTotal,
    required this.discount,
  });
}

class PosCartTotals {
  final String subtotal; // sum of line subtotals (before discount)
  final String discountTotal; // sum of discounts
  final String taxableAmount; // subtotal - discountTotal
  final String taxAmount; // sum of line taxes
  final String totalAmount; // taxableAmount + taxAmount

  const PosCartTotals({
    required this.subtotal,
    required this.discountTotal,
    required this.taxableAmount,
    required this.taxAmount,
    required this.totalAmount,
  });
}

class PosCartCalculator {
  /// Round HALF_EVEN to 4 decimal places, then format as fixed 4dp string.
  /// Mirrors Java's BigDecimal.setScale(4, RoundingMode.HALF_EVEN).
  static double _round4(double v) {
    final scaled = v * 10000;
    final floor = scaled.floorToDouble();
    final remainder = scaled - floor;
    double rounded;
    if (remainder < 0.5) {
      rounded = floor;
    } else if (remainder > 0.5) {
      rounded = floor + 1;
    } else {
      // Tie — go to even
      rounded = floor.toInt().isEven ? floor : floor + 1;
    }
    return rounded / 10000.0;
  }

  static String _fmt4(double v) => _round4(v).toStringAsFixed(4);

  static PosLineTotals computeLine(PosCartLine line) {
    final rawSubtotal = line.quantity * line.unitPrice;
    final discount = line.discountAmount < 0 ? 0.0 : line.discountAmount;
    final afterDiscount = rawSubtotal - discount;

    final lineSubtotal = _round4(afterDiscount < 0 ? 0 : afterDiscount);
    final lineTax = _round4(lineSubtotal * line.taxRate);
    final lineTotal = _round4(lineSubtotal + lineTax);

    return PosLineTotals(
      lineSubtotal: lineSubtotal.toStringAsFixed(4),
      lineTax: lineTax.toStringAsFixed(4),
      lineTotal: lineTotal.toStringAsFixed(4),
      discount: discount.toStringAsFixed(4),
    );
  }

  static PosCartTotals computeCart(List<PosCartLine> lines) {
    double subtotal = 0;
    double discountTotal = 0;
    double taxAmount = 0;
    double totalAmount = 0;

    for (final line in lines) {
      final t = computeLine(line);
      subtotal += double.parse(t.lineSubtotal);
      discountTotal += double.parse(t.discount);
      taxAmount += double.parse(t.lineTax);
      totalAmount += double.parse(t.lineTotal);
    }

    final taxableAmount = subtotal;
    return PosCartTotals(
      subtotal: _fmt4(subtotal),
      discountTotal: _fmt4(discountTotal),
      taxableAmount: _fmt4(taxableAmount),
      taxAmount: _fmt4(taxAmount),
      totalAmount: _fmt4(totalAmount),
    );
  }
}
