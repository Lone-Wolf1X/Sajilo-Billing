import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/utils/paisa_helper.dart';
import 'package:sajilo_billing/features/billing/data/sales_repository.dart';
import 'package:sajilo_billing/features/purchase/data/purchase_repository.dart';

void main() {
  group('PaisaHelper Tests', () {
    test('Currency conversion between Rupees and Paisa', () {
      expect(PaisaHelper.toPaisa(25.50), 2550);
      expect(PaisaHelper.toPaisa(0.0), 0);
      expect(PaisaHelper.toRupees(2550), 25.50);
      expect(PaisaHelper.formatPaisa(255000), 'Rs. 2,550.00');
      expect(PaisaHelper.formatPaisa(255000, isNepali: true), 'रु. 2,550.00');
    });

    test('Paisa to English Words conversion', () {
      expect(PaisaHelper.paisaToWords(100), 'One Rupees Only');
      expect(PaisaHelper.paisaToWords(255050), 'Two Thousand Five Hundred Fifty Rupees and Fifty Paisa Only');
    });
  });

  group('Line Calculation Tests', () {
    test('SaleLineInput amounts in Paisa', () {
      const line = SaleLineInput(
        itemId: 'item-1',
        itemName: 'Wai Wai Noodles',
        unit: 'box',
        quantity: 2,
        ratePaisa: 60000, // Rs 600.00
        discountPaisa: 5000, // Rs 50.00
        isVatApplicable: true,
      );

      expect(line.grossPaisa, 120000); // 2 * 600 = 1200
      expect(line.taxablePaisa, 115000); // 1200 - 50 = 1150
      expect(line.vatPaisa, (115000 * 0.13).round()); // 14950
      expect(line.lineTotalPaisa, line.taxablePaisa + line.vatPaisa);
    });

    test('PurchaseLineInput amounts in Paisa', () {
      const line = PurchaseLineInput(
        itemId: 'item-2',
        itemName: 'Mustard Oil 1L',
        unit: 'ltr',
        quantity: 10,
        ratePaisa: 21000, // Rs 210.00
        discountPaisa: 10000, // Rs 100.00
        isVatApplicable: false,
      );

      expect(line.grossPaisa, 210000);
      expect(line.taxablePaisa, 200000);
      expect(line.vatPaisa, 0);
      expect(line.lineTotalPaisa, 200000);
    });
  });
}

