import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/responsive_card.dart';

/// Welcome modal/screen introducing NextGen Innovations and Sajilo Billing.
class WelcomeScreen extends StatelessWidget {
  final VoidCallback? onContinue;

  const WelcomeScreen({super.key, this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: ResponsiveCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.receipt_long, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Sajilo Billing!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'सजिलो बिलिङमा स्वागत छ',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.accentTeal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your trusted, offline-first Nepali retail billing & khata management suite. Designed to keep working seamlessly without internet and automatically synchronize across your devices.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.5, color: AppTheme.textMuted, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const ListTile(
                    leading: Icon(Icons.verified_user_outlined, color: AppTheme.accentTeal),
                    title: Text('100% Offline-First SQLite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('Store data safely on your machine without cloud dependency', style: TextStyle(fontSize: 12)),
                  ),
                  const ListTile(
                    leading: Icon(Icons.qr_code_2, color: AppTheme.primaryBlue),
                    title: Text('Bilingual Invoices with Fiscal QR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('Print receipts in English and Nepali Devanagari', style: TextStyle(fontSize: 12)),
                  ),
                  const ListTile(
                    leading: Icon(Icons.book_outlined, color: Colors.indigo),
                    title: Text('Credit Khata (उधारो खाता)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('Track customer dues and supplier settlements accurately', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 20),
                  if (onContinue != null)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: onContinue,
                        child: const Text('Get Started / सुरु गर्नुहोस्', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final uri = Uri.parse('https://nextgeninnovations.com.np/');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: const Text(
                      '© 2026 NextGen Innovations Pvt. Ltd. Made in Nepal\nVisit nextgeninnovations.com.np',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppTheme.primaryBlue, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

