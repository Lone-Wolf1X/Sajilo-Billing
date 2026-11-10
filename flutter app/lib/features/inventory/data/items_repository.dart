import '../../../core/api/saisa_api_client.dart';
import 'saisa_item.dart';

class ItemsRepository {
  final SaisaApiClient _api;
  ItemsRepository(this._api);

  /// Fetch all items from SAISA backend.
  Future<List<SaisaItem>> listItems() async {
    final data = await _api.get<List<dynamic>>('/items');
    return data.map((e) => SaisaItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Fetch single item.
  Future<SaisaItem> getItem(int id) async {
    final data = await _api.get<Map<String, dynamic>>('/items/$id');
    return SaisaItem.fromJson(data);
  }

  /// Create item in SAISA backend.
  Future<SaisaItem> createItem({
    required String sku,
    required String name,
    required String unitOfMeasure,
    required bool tracksInventory,
    required String salePrice,
    required String purchasePrice,
    String? hsnCode,
    String? description,
    String? reorderLevel,
  }) async {
    final data = await _api.post<Map<String, dynamic>>('/items', data: {
      'sku': sku,
      'name': name,
      'unitOfMeasure': unitOfMeasure,
      'tracksInventory': tracksInventory,
      'salePrice': salePrice,
      'purchasePrice': purchasePrice,
      if (hsnCode != null) 'hsnCode': hsnCode,
      if (description != null) 'description': description,
      if (reorderLevel != null) 'reorderLevel': reorderLevel,
    });
    return SaisaItem.fromJson(data);
  }

  /// Update item.
  Future<SaisaItem> updateItem(
    int id, {
    String? name,
    String? salePrice,
    String? purchasePrice,
    String? hsnCode,
    bool? active,
    String? reorderLevel,
  }) async {
    final data = await _api.put<Map<String, dynamic>>('/items/$id', data: {
      if (name != null) 'name': name,
      if (salePrice != null) 'salePrice': salePrice,
      if (purchasePrice != null) 'purchasePrice': purchasePrice,
      if (hsnCode != null) 'hsnCode': hsnCode,
      if (active != null) 'active': active,
      if (reorderLevel != null) 'reorderLevel': reorderLevel,
    });
    return SaisaItem.fromJson(data);
  }
}

