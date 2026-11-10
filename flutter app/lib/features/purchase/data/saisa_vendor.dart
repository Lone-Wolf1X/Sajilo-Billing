class SaisaVendor {
  final int id;
  final String vendorCode;
  final String vendorName;
  final String? gstin;
  final String? pan;
  final String? email;
  final String? phone;
  final String? billingAddress;
  final String? state;
  final bool active;

  const SaisaVendor({
    required this.id,
    required this.vendorCode,
    required this.vendorName,
    this.gstin,
    this.pan,
    this.email,
    this.phone,
    this.billingAddress,
    this.state,
    required this.active,
  });

  factory SaisaVendor.fromJson(Map<String, dynamic> j) => SaisaVendor(
        id: (j['id'] as num).toInt(),
        vendorCode: j['vendorCode'] as String,
        vendorName: j['vendorName'] as String,
        gstin: j['gstin'] as String?,
        pan: j['pan'] as String?,
        email: j['email'] as String?,
        phone: j['phone'] as String?,
        billingAddress: j['billingAddress'] as String?,
        state: j['state'] as String?,
        active: j['active'] as bool? ?? true,
      );
}

