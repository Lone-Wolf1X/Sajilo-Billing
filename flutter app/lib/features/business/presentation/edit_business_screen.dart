import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/nepali_validators.dart';
import 'business_provider.dart';

class EditBusinessScreen extends ConsumerStatefulWidget {
  const EditBusinessScreen({super.key});

  @override
  ConsumerState<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends ConsumerState<EditBusinessScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _businessNameController;
  late TextEditingController _businessNameNepaliController;
  late TextEditingController _panVatController;
  late TextEditingController _contactNumberController;
  late TextEditingController _shopAddressController;

  String? _selectedLogoPath;
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController();
    _businessNameNepaliController = TextEditingController();
    _panVatController = TextEditingController();
    _contactNumberController = TextEditingController();
    _shopAddressController = TextEditingController();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessNameNepaliController.dispose();
    _panVatController.dispose();
    _contactNumberController.dispose();
    _shopAddressController.dispose();
    super.dispose();
  }

  void _populateExisting(dynamic profile) {
    if (profile != null && !_initialized) {
      _businessNameController.text = profile.businessName;
      _businessNameNepaliController.text = profile.businessNameNepali ?? '';
      _panVatController.text = profile.panVatNumber;
      _contactNumberController.text = profile.contactNumber;
      _shopAddressController.text = profile.shopAddress ?? '';
      _selectedLogoPath = profile.logoPath;
      _initialized = true;
    }
  }

  Future<void> _pickLogo() async {
    const typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'jpeg', 'png', 'webp'],
    );
    final file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    if (file != null) {
      final repo = ref.read(businessRepositoryProvider);
      final persistedPath = await repo.persistLogoFile(file.path);
      setState(() {
        _selectedLogoPath = persistedPath;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(businessRepositoryProvider);
      await repo.saveBusinessProfile(
        businessName: _businessNameController.text.trim(),
        businessNameNepali: _businessNameNepaliController.text.trim().isEmpty
            ? null
            : _businessNameNepaliController.text.trim(),
        panVatNumber: _panVatController.text.trim(),
        contactNumber: _contactNumberController.text.trim(),
        shopAddress: _shopAddressController.text.trim().isEmpty
            ? null
            : _shopAddressController.text.trim(),
        logoPath: _selectedLogoPath,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business information updated successfully!'),
            backgroundColor: AppTheme.accentTeal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating business info: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(businessProfileStreamProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading business profile: $e')),
      data: (profile) {
        _populateExisting(profile);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.businessInfo),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.badge_outlined, color: AppTheme.primaryBlue, size: 28),
                              const SizedBox(width: 12),
                              Text(
                                l10n.businessInfoSubtitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: AppTheme.borderSubtle),
                          const SizedBox(height: 20),

                          Text(
                            l10n.businessNameLabel,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _businessNameController,
                            decoration: InputDecoration(
                              hintText: l10n.businessNameHint,
                              prefixIcon: const Icon(Icons.business),
                            ),
                            validator: (val) => NepaliValidators.validateBusinessName(
                              val,
                              requiredMsg: l10n.businessNameRequired,
                            ),
                          ),
                          const SizedBox(height: 14),

                          Text(
                            l10n.businessNameNepaliLabel,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _businessNameNepaliController,
                            decoration: InputDecoration(
                              hintText: l10n.businessNameNepaliHint,
                              prefixIcon: const Icon(Icons.translate),
                            ),
                          ),
                          const SizedBox(height: 18),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.panVatLabel,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _panVatController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 9,
                                      decoration: InputDecoration(
                                        hintText: l10n.panVatHint,
                                        counterText: '',
                                        prefixIcon: const Icon(Icons.pin),
                                      ),
                                      validator: (val) => NepaliValidators.validatePanVat(
                                        val,
                                        requiredMsg: l10n.panVatRequired,
                                        invalidMsg: l10n.panVatInvalid,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.contactNumberLabel,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _contactNumberController,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        hintText: l10n.contactNumberHint,
                                        counterText: '',
                                        prefixIcon: const Icon(Icons.phone),
                                      ),
                                      validator: (val) => NepaliValidators.validateContactNumber(
                                        val,
                                        requiredMsg: l10n.contactNumberRequired,
                                        invalidMsg: l10n.contactNumberInvalid,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          Text(
                            l10n.shopAddressLabel,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _shopAddressController,
                            decoration: InputDecoration(
                              hintText: l10n.shopAddressHint,
                              prefixIcon: const Icon(Icons.location_on_outlined),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            l10n.businessLogoLabel,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.borderSubtle),
                              borderRadius: BorderRadius.circular(8),
                              color: AppTheme.backgroundLight,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppTheme.borderSubtle),
                                  ),
                                  child: _selectedLogoPath != null &&
                                          File(_selectedLogoPath!).existsSync()
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            File(_selectedLogoPath!),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.image_outlined,
                                          color: AppTheme.textMuted,
                                          size: 32,
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedLogoPath != null
                                            ? 'Shop logo loaded'
                                            : 'No logo uploaded',
                                        style: const TextStyle(
                                            fontSize: 13, color: AppTheme.textDark),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          OutlinedButton.icon(
                                            onPressed: _pickLogo,
                                            icon: const Icon(Icons.file_upload_outlined,
                                                size: 16),
                                            label: Text(
                                              _selectedLogoPath != null
                                                  ? l10n.changeLogo
                                                  : l10n.uploadLogo,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              minimumSize: const Size(120, 34),
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                            ),
                                          ),
                                          if (_selectedLogoPath != null) ...[
                                            const SizedBox(width: 8),
                                            TextButton(
                                              onPressed: () {
                                                setState(() => _selectedLogoPath = null);
                                              },
                                              child: Text(
                                                l10n.removeLogo,
                                                style: const TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          ElevatedButton.icon(
                            onPressed: _isSaving ? null : _saveChanges,
                            icon: const Icon(Icons.save_outlined),
                            label: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.saveChanges),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

