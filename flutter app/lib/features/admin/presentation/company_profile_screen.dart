import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/api_exception.dart';
import '../../../core/providers.dart';

/// Company profile model matching SAISA backend /setup/profile
class CompanyProfile {
  final String? companyName;
  final String? companyNameNepali;
  final String? legalName;
  final String? registrationAuthority;
  final String? registrationNo;
  final String? registrationDate;
  final String? panVatNo;
  final String? panVatDate;
  final String? province;
  final String? district;
  final String? municipalityVdc;
  final String? wardNo;
  final String? toleStreet;
  final String? incorporationType;
  final String? businessNature;
  final String? authorizedPersonName;
  final String? authorizedPersonDesignation;
  final String? authorizedPersonPhone;
  final String? authorizedPersonEmail;
  final String? email;
  final String? phone;

  const CompanyProfile({
    this.companyName,
    this.companyNameNepali,
    this.legalName,
    this.registrationAuthority,
    this.registrationNo,
    this.registrationDate,
    this.panVatNo,
    this.panVatDate,
    this.province,
    this.district,
    this.municipalityVdc,
    this.wardNo,
    this.toleStreet,
    this.incorporationType,
    this.businessNature,
    this.authorizedPersonName,
    this.authorizedPersonDesignation,
    this.authorizedPersonPhone,
    this.authorizedPersonEmail,
    this.email,
    this.phone,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> j) => CompanyProfile(
        companyName: j['companyName'] as String?,
        companyNameNepali: j['companyNameNepali'] as String?,
        legalName: j['legalName'] as String?,
        registrationAuthority: j['registrationAuthority'] as String?,
        registrationNo: j['registrationNo'] as String?,
        registrationDate: (j['registrationDate'] as String?)?.split('T').first,
        panVatNo: j['panVatNo'] as String?,
        panVatDate: (j['panVatDate'] as String?)?.split('T').first,
        province: j['province'] as String?,
        district: j['district'] as String?,
        municipalityVdc: j['municipalityVdc'] as String?,
        wardNo: j['wardNo']?.toString(),
        toleStreet: j['toleStreet'] as String?,
        incorporationType: j['incorporationType'] as String?,
        businessNature: j['businessNature'] as String?,
        authorizedPersonName: j['authorizedPersonName'] as String?,
        authorizedPersonDesignation: j['authorizedPersonDesignation'] as String?,
        authorizedPersonPhone: j['authorizedPersonPhone'] as String?,
        authorizedPersonEmail: j['authorizedPersonEmail'] as String?,
        email: j['email'] as String?,
        phone: j['phone'] as String?,
      );
}

final companyProfileProvider = FutureProvider.autoDispose<CompanyProfile>((ref) async {
  final api = ref.read(apiClientProvider);
  final json = await api.get<Map<String, dynamic>>('/setup/profile');
  return CompanyProfile.fromJson(json);
});

class CompanyProfileScreen extends ConsumerStatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  ConsumerState<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends ConsumerState<CompanyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  String? _error;
  bool _initialized = false;

  final _companyName = TextEditingController();
  final _companyNameNepali = TextEditingController();
  final _legalName = TextEditingController();
  final _registrationAuthority = TextEditingController();
  final _registrationNo = TextEditingController();
  final _registrationDate = TextEditingController();
  final _panVatNo = TextEditingController();
  final _panVatDate = TextEditingController();
  final _province = TextEditingController();
  final _district = TextEditingController();
  final _municipalityVdc = TextEditingController();
  final _wardNo = TextEditingController();
  final _toleStreet = TextEditingController();
  String _incorporationType = 'PRIVATE_LIMITED';
  String _businessNature = 'TRADING';
  final _authName = TextEditingController();
  final _authDesig = TextEditingController();
  final _authPhone = TextEditingController();
  final _authEmail = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _companyName, _companyNameNepali, _legalName,
      _registrationAuthority, _registrationNo, _registrationDate,
      _panVatNo, _panVatDate, _province, _district, _municipalityVdc,
      _wardNo, _toleStreet, _authName, _authDesig, _authPhone,
      _authEmail, _email, _phone,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _populate(CompanyProfile p) {
    _companyName.text = p.companyName ?? '';
    _companyNameNepali.text = p.companyNameNepali ?? '';
    _legalName.text = p.legalName ?? '';
    _registrationAuthority.text = p.registrationAuthority ?? '';
    _registrationNo.text = p.registrationNo ?? '';
    _registrationDate.text = p.registrationDate ?? '';
    _panVatNo.text = p.panVatNo ?? '';
    _panVatDate.text = p.panVatDate ?? '';
    _province.text = p.province ?? '';
    _district.text = p.district ?? '';
    _municipalityVdc.text = p.municipalityVdc ?? '';
    _wardNo.text = p.wardNo ?? '';
    _toleStreet.text = p.toleStreet ?? '';
    _incorporationType = p.incorporationType ?? 'PRIVATE_LIMITED';
    _businessNature = p.businessNature ?? 'TRADING';
    _authName.text = p.authorizedPersonName ?? '';
    _authDesig.text = p.authorizedPersonDesignation ?? '';
    _authPhone.text = p.authorizedPersonPhone ?? '';
    _authEmail.text = p.authorizedPersonEmail ?? '';
    _email.text = p.email ?? '';
    _phone.text = p.phone ?? '';
    _initialized = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      await api.put<Map<String, dynamic>>('/setup/profile', data: {
        'companyName': _companyName.text.trim(),
        'companyNameNepali': _companyNameNepali.text.trim().isEmpty
            ? null
            : _companyNameNepali.text.trim(),
        'legalName': _legalName.text.trim().isEmpty ? null : _legalName.text.trim(),
        'registrationAuthority': _registrationAuthority.text.trim().isEmpty
            ? null
            : _registrationAuthority.text.trim(),
        'registrationNo': _registrationNo.text.trim().isEmpty
            ? null
            : _registrationNo.text.trim(),
        'registrationDate': _registrationDate.text.trim().isEmpty
            ? null
            : _registrationDate.text.trim(),
        'panVatNo': _panVatNo.text.trim(),
        'panVatDate': _panVatDate.text.trim().isEmpty
            ? null
            : _panVatDate.text.trim(),
        'province': _province.text.trim().isEmpty ? null : _province.text.trim(),
        'district': _district.text.trim().isEmpty ? null : _district.text.trim(),
        'municipalityVdc': _municipalityVdc.text.trim().isEmpty
            ? null
            : _municipalityVdc.text.trim(),
        'wardNo': int.tryParse(_wardNo.text.trim()),
        'toleStreet': _toleStreet.text.trim().isEmpty ? null : _toleStreet.text.trim(),
        'incorporationType': _incorporationType,
        'businessNature': _businessNature,
        'authorizedPersonName': _authName.text.trim().isEmpty
            ? null
            : _authName.text.trim(),
        'authorizedPersonDesignation': _authDesig.text.trim().isEmpty
            ? null
            : _authDesig.text.trim(),
        'authorizedPersonPhone': _authPhone.text.trim().isEmpty
            ? null
            : _authPhone.text.trim(),
        'authorizedPersonEmail': _authEmail.text.trim().isEmpty
            ? null
            : _authEmail.text.trim(),
        'email': _email.text.trim().isEmpty ? null : _email.text.trim(),
        'phone': _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      });

      ref.invalidate(companyProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Company profile updated successfully! / कम्पनी विवरण सुरक्षित गरियो!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(companyProfileProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text('Failed to load profile: $e', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(companyProfileProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (profile) {
        if (!_initialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _populate(profile);
              setState(() {});
            }
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.business, color: Color(0xFF1E3A8A), size: 28),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Profile / कम्पनी विवरण',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Official business details printed on Tax & PAN invoices',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save, size: 18),
                      label: Text(_saving ? 'SAVING…' : 'SAVE PROFILE (सुरक्षित गर्नुहोस्)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (_error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9E8E8),
                      border: Border.all(color: const Color(0xFFA83232)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(_error!, style: const TextStyle(color: Color(0xFFA83232))),
                  ),

                // Section 1: Business Identity
                _section('Business Identity / पहिचान'),
                _row2(
                  _field(_companyName, 'Company Name (English) *', required: true),
                  _field(_companyNameNepali, 'Company Name (Nepali / देवनागरी)'),
                ),
                _field(_legalName, 'Legal / Trade Name'),

                // Section 2: Registration & Tax
                _section('Registration & Tax / दर्ता तथा कर'),
                _row2(
                  _field(_registrationAuthority, 'Registration Authority (e.g. OCR)'),
                  _field(_registrationNo, 'Registration No'),
                ),
                _row2(
                  _dateField(_registrationDate, 'Registration Date (दर्ता मिति)'),
                  _field(_panVatNo, 'PAN / VAT No *', required: true, hint: 'e.g. 601234567'),
                ),
                _dateField(_panVatDate, 'PAN/VAT Registration Date (कर दर्ता मिति)'),

                // Section 3: Registered Address
                _section('Registered Address / ठेगाना'),
                _row2(
                  _field(_province, 'Province (प्रदेश)'),
                  _field(_district, 'District (जिल्ला)'),
                ),
                _row2(
                  _field(_municipalityVdc, 'Municipality / Palika (पालिका)'),
                  _field(_wardNo, 'Ward No (वडा नं.)'),
                ),
                _field(_toleStreet, 'Tole / Street (टोल)'),

                // Section 4: Classification
                _section('Business Classification / प्रकृत'),
                _row2(
                  _dropdownField(
                    'Incorporation Type (कम्पनी प्रकार) *',
                    _incorporationType,
                    const [
                      ('PRIVATE_LIMITED', 'Private Limited (प्रा.लि.)'),
                      ('PUBLIC_LIMITED', 'Public Limited (लि.)'),
                      ('PROPRIETORSHIP', 'Sole Proprietorship (एकलौटी फर्म)'),
                      ('PARTNERSHIP', 'Partnership (साझेदारी)'),
                      ('COOPERATIVE', 'Cooperative (सहकारी)'),
                      ('NGO', 'NGO (गैर-सरकारी संस्था)'),
                      ('GOVERNMENT', 'Government (सरकारी)'),
                      ('OTHER', 'Other (अन्य)'),
                    ],
                    (v) => setState(() => _incorporationType = v),
                  ),
                  _dropdownField(
                    'Business Nature (कारोबार प्रकृति) *',
                    _businessNature,
                    const [
                      ('TRADING', 'Trading (व्यापार)'),
                      ('MANUFACTURING', 'Manufacturing (उत्पादन)'),
                      ('SERVICE', 'Service (सेवा)'),
                      ('RETAIL', 'Retail (खुद्रा)'),
                      ('WHOLESALE', 'Wholesale (थोक)'),
                      ('MIXED', 'Mixed (मिश्रित)'),
                      ('OTHER', 'Other (अन्य)'),
                    ],
                    (v) => setState(() => _businessNature = v),
                  ),
                ),

                // Section 5: Authorized Person
                _section('Authorized Person / अधिकृत व्यक्ति'),
                _row2(
                  _field(_authName, 'Full Name (नाम)'),
                  _field(_authDesig, 'Designation (पद)', hint: 'e.g. Managing Director / Proprietor'),
                ),
                _row2(
                  _field(_authPhone, 'Phone (सम्पर्क नं.)'),
                  _field(_authEmail, 'Email (इमेल)'),
                ),

                // Section 6: Official Contact
                _section('Official Contact / कम्पनी सम्पर्क'),
                _row2(
                  _field(_email, 'Company Email'),
                  _field(_phone, 'Company Phone'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            color: const Color(0xFF1E3A8A),
            margin: const EdgeInsets.only(right: 8),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row2(Widget a, Widget b) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(child: a),
            const SizedBox(width: 12),
            Expanded(child: b),
          ],
        ),
      );

  Widget _field(TextEditingController c, String label, {bool required = false, String? hint}) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null : null,
    );
  }

  Widget _dateField(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, size: 16),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: c.text.isNotEmpty
                ? DateTime.tryParse(c.text) ?? DateTime.now()
                : DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            c.text = picked.toIso8601String().substring(0, 10);
          }
        },
      ),
    );
  }

  Widget _dropdownField(
    String label,
    String value,
    List<(String, String)> options,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      items: options
          .map((o) => DropdownMenuItem(
                value: o.$1,
                child: Text(o.$2, style: const TextStyle(fontSize: 13)),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

