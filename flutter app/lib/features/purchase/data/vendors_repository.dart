import '../../../core/api/saisa_api_client.dart';
import 'saisa_vendor.dart';

class VendorsRepository {
  final SaisaApiClient _api;

  VendorsRepository({required SaisaApiClient api}) : _api = api;

  /// Fetch all active vendors for current tenant
  Future<List<SaisaVendor>> listVendors() async {
    final res = await _api.get('/vendors');
    final list = res.data as List<dynamic>;
    return list
        .map((e) => SaisaVendor.fromJson(e as Map<String, dynamic>))
        .where((v) => v.active)
        .toList();
  }

  /// Create a new vendor on backend
  Future<SaisaVendor> createVendor({
    required String vendorCode,
    required String vendorName,
    String? pan,
    String? phone,
    String? billingAddress,
  }) async {
    final res = await _api.post('/vendors', data: {
      'vendorCode': vendorCode,
      'vendorName': vendorName,
      'pan': pan,
      'phone': phone,
      'billingAddress': billingAddress,
    });
    return SaisaVendor.fromJson(res.data as Map<String, dynamic>);
  }
}

