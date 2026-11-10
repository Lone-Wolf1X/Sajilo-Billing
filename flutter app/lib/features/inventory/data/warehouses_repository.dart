import '../../../core/api/saisa_api_client.dart';
import 'saisa_warehouse.dart';

class WarehousesRepository {
  final SaisaApiClient _api;
  WarehousesRepository(this._api);

  Future<List<SaisaWarehouse>> listWarehouses() async {
    final data = await _api.get<List<dynamic>>('/warehouses');
    return data.map((e) => SaisaWarehouse.fromJson(e as Map<String, dynamic>)).toList();
  }
}

