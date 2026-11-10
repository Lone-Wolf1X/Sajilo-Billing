class SaisaCustomer {
  final int id;
  final String customerCode;
  final String customerName;
  final String? gstin;
  final String? pan;
  final String? email;
  final String? phone;
  final String? billingAddress;
  final String? state;
  final bool active;

  const SaisaCustomer({
    required this.id,
    required this.customerCode,
    required this.customerName,
    this.gstin,
    this.pan,
    this.email,
    this.phone,
    this.billingAddress,
    this.state,
    required this.active,
  });

  factory SaisaCustomer.fromJson(Map<String, dynamic> j) => SaisaCustomer(
        id: (j['id'] as num).toInt(),
        customerCode: j['customerCode'] as String,
        customerName: j['customerName'] as String,
        gstin: j['gstin'] as String?,
        pan: j['pan'] as String?,
        email: j['email'] as String?,
        phone: j['phone'] as String?,
        billingAddress: j['billingAddress'] as String?,
        state: j['state'] as String?,
        active: j['active'] as bool? ?? true,
      );
}
