import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/connectivity_watcher.dart';
import '../data/backup_service_locator.dart';
import '../data/google_auth_service.dart';
import '../domain/backup_error.dart';
import '../domain/backup_progress.dart';
import 'backup_provider.dart';
import 'widgets/backup_history_list.dart';
import 'widgets/restore_dialog.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _isProcessing = false;
  BackupProgress? _currentProgress;
  StreamSubscription<BackupProgress>? _progressSub;

  @override
  void initState() {
    super.initState();
    // Listen to Google Drive progress stream
    final driveService = ref.read(googleDriveBackupServiceProvider);
    _progressSub = driveService.progressStream.listen((progress) {
      if (mounted) {
        setState(() => _currentProgress = progress);
      }
    });
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    super.dispose();
  }

  Future<void> _handleConnectGoogle() async {
    String? clientId = GoogleAuthService.defaultClientId;
    String? clientSecret = GoogleAuthService.defaultClientSecret;

    // If client ID is not configured via dart-define, prompt user for testing
    if (clientId.isEmpty) {
      final credentials = await _promptCredentialsDialog(context);
      if (credentials == null) return;
      clientId = credentials['client_id'];
      clientSecret = credentials['client_secret'];
    }

    setState(() => _isProcessing = true);
    try {
      final user = await ref.read(googleAccountProvider.notifier).signIn(
            clientId: clientId,
            clientSecret: clientSecret,
          );
      if (mounted) {
        ref.read(backupDestinationProvider.notifier).setDestination(BackupDestination.googleDrive);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected to Google Drive as ${user.email}'),
            backgroundColor: AppTheme.accentTeal,
          ),
        );
      }
    } catch (e) {
      if (mounted && e is! UserCancelledException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<Map<String, String>?> _promptCredentialsDialog(BuildContext context) async {
    final idController = TextEditingController();
    final secretController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Google Cloud Credentials'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'OAuth credentials were not provided via --dart-define. Enter your Desktop OAuth Client ID from Google Cloud Console (see docs/google_setup.md):',
                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'Client ID',
                  hintText: 'xxxx.apps.googleusercontent.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: secretController,
                decoration: const InputDecoration(
                  labelText: 'Client Secret (Optional for Desktop)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = idController.text.trim();
              if (id.isEmpty) return;
              Navigator.pop(ctx, {
                'client_id': id,
                'client_secret': secretController.text.trim(),
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _backupNow() async {
    final l10n = AppLocalizations.of(context)!;
    final destination = ref.read(backupDestinationProvider);
    final accountState = ref.read(googleAccountProvider);

    if (destination == BackupDestination.googleDrive && accountState.value == null) {
      await _handleConnectGoogle();
      if (ref.read(googleAccountProvider).value == null) return;
    }

    setState(() {
      _isProcessing = true;
      _currentProgress = null;
    });

    try {
      final service = ref.read(activeBackupServiceProvider);
      final result = await service.backupNow();
      ref.invalidate(lastBackupTimeProvider);

      if (mounted) {
        final message = destination == BackupDestination.googleDrive
            ? 'Backup successfully uploaded to Google Drive!'
            : '${l10n.backupSuccess} $result';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppTheme.accentTeal,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted && e is! UserCancelledException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.backupFailed(e.toString())),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _currentProgress = null;
        });
      }
    }
  }

  Future<void> _restoreBackup() async {
    final l10n = AppLocalizations.of(context)!;
    final destination = ref.read(backupDestinationProvider);
    final isDrive = destination == BackupDestination.googleDrive;

    if (isDrive) {
      final accountState = ref.read(googleAccountProvider);
      if (accountState.value == null) {
        await _handleConnectGoogle();
        if (ref.read(googleAccountProvider).value == null) return;
      }

      setState(() => _isProcessing = true);
      try {
        final driveService = ref.read(googleDriveBackupServiceProvider);
        final summary = await driveService.fetchLatestBackupSummary();

        if (summary == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No backup archives found in your Google Drive.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }

        if (!mounted) return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => RestoreDialog(summary: summary, isDrive: true),
        );

        if (confirmed != true) return;

        final restored = await driveService.restoreLatest();
        if (restored && mounted) {
          ref.invalidate(lastBackupTimeProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.restoreSuccess),
              backgroundColor: AppTheme.accentTeal,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        if (mounted && e is! UserCancelledException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.restoreFailed(e.toString())),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    } else {
      // Local restore
      setState(() => _isProcessing = true);
      try {
        final localService = ref.read(localBackupServiceProvider);
        final restored = await localService.restoreLatest();
        if (restored && mounted) {
          ref.invalidate(lastBackupTimeProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.restoreSuccess),
              backgroundColor: AppTheme.accentTeal,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        if (mounted && e is! UserCancelledException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.restoreFailed(e.toString())),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lastBackupAsync = ref.watch(lastBackupTimeProvider);
    final destination = ref.watch(backupDestinationProvider);
    final accountState = ref.watch(googleAccountProvider);
    final isOnlineAsync = ref.watch(isOnlineStreamProvider);
    final isOnline = isOnlineAsync.value ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backupAndRestore),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (kIsWeb)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.cloud_sync, color: AppTheme.primaryBlue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Google Drive backup is available in the Desktop app. Web relies on sync to the server.',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Offline mode status banner
                if (!isOnline || accountState.value == null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.withOpacity(0.25)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud_off_outlined, color: AppTheme.primaryBlue, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.offlineModeActive,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Main Backup Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.archive_outlined, color: AppTheme.primaryBlue, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.backupAndRestore,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.backupSubtitle,
                                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: AppTheme.borderSubtle),
                        const SizedBox(height: 16),

                        // Destination Selector
                        Text(
                          l10n.backupDestination,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDestinationCard(
                                title: l10n.localBackup,
                                subtitle: 'Export/restore SQLite file',
                                icon: Icons.folder_zip_outlined,
                                isSelected: destination == BackupDestination.local,
                                onTap: () => ref
                                    .read(backupDestinationProvider.notifier)
                                    .setDestination(BackupDestination.local),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDestinationCard(
                                title: l10n.googleDriveBackup,
                                subtitle: 'Cloud archive (opt-in)',
                                icon: Icons.cloud_upload_outlined,
                                isSelected: destination == BackupDestination.googleDrive,
                                onTap: () => ref
                                    .read(backupDestinationProvider.notifier)
                                    .setDestination(BackupDestination.googleDrive),
                              ),
                            ),
                          ],
                        ),

                        // Google Drive Account Section
                        if (destination == BackupDestination.googleDrive) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: accountState.when(
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (err, _) => Text('Auth error: $err', style: const TextStyle(color: Colors.red)),
                              data: (email) {
                                if (email != null) {
                                  return Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Icon(Icons.person, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.googleConnectedAs(email),
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              l10n.driveFolderInfo,
                                              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                            ),
                                          ],
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: _isProcessing
                                            ? null
                                            : () async {
                                                await ref.read(googleAccountProvider.notifier).signOut();
                                                ref
                                                    .read(backupDestinationProvider.notifier)
                                                    .setDestination(BackupDestination.local);
                                              },
                                        child: Text(l10n.disconnectGoogleDrive),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      const Icon(Icons.cloud_outlined, color: AppTheme.primaryBlue, size: 28),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.googleNotConnected,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              l10n.driveFolderInfo,
                                              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.login, size: 18),
                                        label: Text(l10n.connectGoogleDrive),
                                        onPressed: _isProcessing ? null : _handleConnectGoogle,
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Last Backup Info
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.history, color: AppTheme.textMuted, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                '${l10n.lastBackup}: ',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              lastBackupAsync.when(
                                loading: () => const Text('...', style: TextStyle(color: AppTheme.textMuted)),
                                error: (_, __) => const Text('Error', style: TextStyle(color: Colors.red)),
                                data: (timestamp) => Text(
                                  timestamp != null
                                      ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toLocal())
                                      : l10n.noBackupYet,
                                  style: TextStyle(
                                    color: timestamp != null ? AppTheme.accentTeal : AppTheme.textMuted,
                                    fontWeight: timestamp != null ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Progress Indicator
                        if (_currentProgress != null) ...[
                          const SizedBox(height: 20),
                          LinearProgressIndicator(value: _currentProgress!.percentage),
                          const SizedBox(height: 8),
                          Text(
                            _currentProgress!.message,
                            style: const TextStyle(fontSize: 12, color: AppTheme.primaryBlue, fontWeight: FontWeight.w500),
                          ),
                        ],

                        const SizedBox(height: 28),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: _isProcessing
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Icon(Icons.backup_outlined),
                                label: Text(l10n.backupNow),
                                onPressed: _isProcessing ? null : _backupNow,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.restore_outlined),
                                label: Text(
                                  destination == BackupDestination.googleDrive
                                      ? l10n.restoreFromDrive
                                      : l10n.restoreFromLocal,
                                ),
                                onPressed: _isProcessing ? null : _restoreBackup,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Backup History Header & List
                Row(
                  children: [
                    const Icon(Icons.receipt_long_outlined, color: AppTheme.primaryBlue, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      l10n.backupHistory,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const BackupHistoryList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryBlue : AppTheme.textMuted, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.primaryBlue, size: 20),
          ],
        ),
      ),
    );
  }
}
