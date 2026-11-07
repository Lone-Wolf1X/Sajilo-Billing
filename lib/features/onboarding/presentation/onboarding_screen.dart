import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/nepali_validators.dart';
import '../../business/presentation/business_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _businessNameController = TextEditingController();
  final _panVatController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _shopAddressController = TextEditingController();

  String? _selectedLogoPath;
  bool _isSaving = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _panVatController.dispose();
    _contactNumberController.dispose();
    _shopAddressController.dispose();
    super.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(businessRepositoryProvider);
      await repo.saveBusinessProfile(
        businessName: _businessNameController.text.trim(),
        panVatNumber: _panVatController.text.trim(),
        contactNumber: _contactNumberController.text.trim(),
        shopAddress: _shopAddressController.text.trim().isEmpty
            ? null
            : _shopAddressController.text.trim(),
        logoPath: _selectedLogoPath,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving business info: $e')),
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

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Branding
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.storefront_rounded,
                              size: 36,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.onboardingTitle,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textDark,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.onboardingSubtitle,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.textMuted,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Divider(color: AppTheme.borderSubtle),
                      const SizedBox(height: 20),

                      // Business Name Field
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
                      const SizedBox(height: 18),

                      // PAN / VAT and Contact Number side by side for desktop
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

                      // Shop Address Field
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

                      // Logo Selection Area
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
                              child: _selectedLogoPath != null && File(_selectedLogoPath!).existsSync()
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
                                        ? 'Logo selected'
                                        : 'No logo chosen',
                                    style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: _pickLogo,
                                        icon: const Icon(Icons.file_upload_outlined, size: 16),
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

                      // Submit Button
                      ElevatedButton(
                        onPressed: _isSaving ? null : _submit,
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.saveAndContinue),
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
  }
}
