/// Mirrors SAISA backend ItemResponse
class SaisaItem {
  final int id;
  final String sku;
  final String name;
  final String? description;
  final String unitOfMeasure;
  final String? hsnCode;
  final bool tracksInventory;
  final String salePrice;
  final String purchasePrice;
  final String? reorderLevel;
  final bool active;

  const SaisaItem({
    required this.id,
    required this.sku,
    required this.name,
    this.description,
    required this.unitOfMeasure,
    this.hsnCode,
    required this.tracksInventory,
    required this.salePrice,
    required this.purchasePrice,
    this.reorderLevel,
    required this.active,
  });

  factory SaisaItem.fromJson(Map<String, dynamic> j) {
    return SaisaItem(
      id: (j['id'] as num).toInt(),
      sku: j['sku'] as String,
      name: j['name'] as String,
      description: j['description'] as String?,
      unitOfMeasure: j['unitOfMeasure'] as String? ?? 'NOS',
      hsnCode: j['hsnCode'] as String?,
      tracksInventory: j['tracksInventory'] as bool? ?? true,
      salePrice: j['salePrice']?.toString() ?? '0.00',
      purchasePrice: j['purchasePrice']?.toString() ?? '0.00',
      reorderLevel: j['reorderLevel']?.toString(),
      active: j['active'] as bool? ?? true,
    );
  }
}
