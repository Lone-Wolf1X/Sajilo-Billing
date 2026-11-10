import '../../../core/api/saisa_api_client.dart';
import 'saisa_customer.dart';

class CustomersRepository {
  final SaisaApiClient _api;
  CustomersRepository(this._api);

  Future<List<SaisaCustomer>> listCustomers() async {
    final data = await _api.get<List<dynamic>>('/customers');
    return data.map((e) => SaisaCustomer.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SaisaCustomer> createCustomer({
    required String customerCode,
    required String customerName,
    String? gstin,
    String? pan,
    String? email,
    String? phone,
    String? billingAddress,
    String? state,
  }) async {
    final data = await _api.post<Map<String, dynamic>>('/customers', data: {
      'customerCode': customerCode,
      'customerName': customerName,
      if (gstin != null) 'gstin': gstin,
      if (pan != null) 'pan': pan,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (billingAddress != null) 'billingAddress': billingAddress,
      if (state != null) 'state': state,
    });
    return SaisaCustomer.fromJson(data);
  }
}
