import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/responsive_card.dart';
import 'auth_state_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginScreen({super.key, this.onLoginSuccess});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Local login form state
  final _loginFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Register form state
  bool _isRegisterMode = false;
  final _registerFormKey = GlobalKey<FormState>();
  final _regUsernameController = TextEditingController();
  final _regDisplayNameController = TextEditingController();
  final _regPasswordController = TextEditingController();
  final _regConfirmPasswordController = TextEditingController();
  final _regSecurityAnswerController = TextEditingController();
  String _selectedSecurityQuestion = 'What is your primary school name?';
  bool _regObscurePassword = true;

  static const List<String> _securityQuestions = [
    'What is your primary school name?',
    'What is your pet name?',
    'What city was your shop founded in?',
    'What is your mother\'s maiden name?',
    'What is your favorite Nepali dish?',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _regUsernameController.dispose();
    _regDisplayNameController.dispose();
    _regPasswordController.dispose();
    _regConfirmPasswordController.dispose();
    _regSecurityAnswerController.dispose();
    super.dispose();
  }

  Future<void> _handleLocalLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;
    final success = await ref.read(authStateProvider.notifier).loginLocal(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
    if (success && mounted && widget.onLoginSuccess != null) {
      widget.onLoginSuccess!();
    }
  }

  Future<void> _handleLocalRegister() async {
    if (!_registerFormKey.currentState!.validate()) return;
    if (_regPasswordController.text != _regConfirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.passwordsDoNotMatch ?? 'Passwords do not match'),
          backgroundColor: AppTheme.dangerRed,
        ),
      );
      return;
    }

    final success = await ref.read(authStateProvider.notifier).registerLocal(
          username: _regUsernameController.text.trim(),
          password: _regPasswordController.text,
          displayName: _regDisplayNameController.text.trim().isNotEmpty ? _regDisplayNameController.text.trim() : null,
          securityQuestion: _selectedSecurityQuestion,
          securityAnswer: _regSecurityAnswerController.text.trim(),
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.accountCreatedSuccess ?? 'Account created! Please sign in.'),
          backgroundColor: AppTheme.accentTeal,
        ),
      );
      setState(() {
        _isRegisterMode = false;
        _usernameController.text = _regUsernameController.text.trim();
        _passwordController.clear();
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final success = await ref.read(authStateProvider.notifier).loginGoogle();
    if (success && mounted && widget.onLoginSuccess != null) {
      widget.onLoginSuccess!();
    }
  }

  void _showForgotPasswordDialog() {
    final l10n = AppLocalizations.of(context);
    final resetUsernameCtrl = TextEditingController();
    final resetAnswerCtrl = TextEditingController();
    final resetNewPassCtrl = TextEditingController();
    String resetQuestion = _securityQuestions.first;
    final resetFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n?.resetPassword ?? 'Reset Password'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: resetFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: resetUsernameCtrl,
                      decoration: InputDecoration(
                        labelText: l10n?.usernameLabel ?? 'Username',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? (l10n?.usernameRequired ?? 'Username required')
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: resetQuestion,
                      decoration: InputDecoration(
                        labelText: l10n?.securityQuestionLabel ?? 'Security Question',
                        prefixIcon: const Icon(Icons.help_outline),
                      ),
                      isExpanded: true,
                      items: _securityQuestions.map((q) => DropdownMenuItem(value: q, child: Text(q, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => resetQuestion = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: resetAnswerCtrl,
                      decoration: InputDecoration(
                        labelText: l10n?.securityAnswerLabel ?? 'Security Answer',
                        prefixIcon: const Icon(Icons.key_outlined),
                      ),
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? (l10n?.securityAnswerRequired ?? 'Answer required')
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: resetNewPassCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n?.newPasswordLabel ?? 'New Password',
                        prefixIcon: const Icon(Icons.lock_reset),
                      ),
                      validator: (val) => (val == null || val.length < 4)
                          ? (l10n?.passwordLengthError ?? 'Minimum 4 characters')
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n?.cancel ?? 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!resetFormKey.currentState!.validate()) return;
                final success = await ref.read(authStateProvider.notifier).resetPasswordLocal(
                      username: resetUsernameCtrl.text.trim(),
                      securityAnswer: resetAnswerCtrl.text.trim(),
                      newPassword: resetNewPassCtrl.text,
                    );
                if (success) {
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n?.passwordResetSuccess ?? 'Password updated! Please sign in.'),
                        backgroundColor: AppTheme.accentTeal,
                      ),
                    );
                  }
                }
              },
              child: Text(l10n?.resetPassword ?? 'Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ResponsiveCard(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Branding Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.receipt_long, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n?.appTitle ?? 'Sajilo Billing',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n?.loginSubtitle ?? 'Fast, offline-first Nepali retail POS',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'NextGen Innovations Pvt. Ltd.',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentTeal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Error notification if present
                  if (authState.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.dangerRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.dangerRed.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppTheme.dangerRed, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: const TextStyle(fontSize: 12, color: AppTheme.dangerRed),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Tab bar (Local vs Google)
                  TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.primaryBlue,
                    unselectedLabelColor: AppTheme.textMuted,
                    indicatorColor: AppTheme.primaryBlue,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                        icon: const Icon(Icons.lock_outline, size: 18),
                        text: l10n?.localLoginTab ?? 'Local Sign In',
                      ),
                      Tab(
                        icon: const Icon(Icons.account_circle_outlined, size: 18),
                        text: l10n?.googleLoginTab ?? 'Google Account',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Tab Bar View content
                  SizedBox(
                    height: _isRegisterMode ? 460 : 310,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: Local Login / Register
                        _isRegisterMode ? _buildRegisterForm(l10n, authState) : _buildLoginForm(l10n, authState),

                        // Tab 2: Google Sign In
                        _buildGoogleSignInTab(l10n, authState),
                      ],
                    ),
                  ),

                  const Divider(height: 24),
                  // Footer branding
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified, size: 13, color: AppTheme.accentTeal),
                      const SizedBox(width: 5),
                      Text(
                        l10n?.offlineNotice ?? '100% Offline-Safe: Local login works without internet.',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(AppLocalizations? l10n, AuthState authState) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: l10n?.usernameLabel ?? 'Username',
              hintText: l10n?.usernameHint ?? 'Enter username',
              prefixIcon: const Icon(Icons.person_outline, size: 20),
            ),
            validator: (val) => (val == null || val.trim().isEmpty) ? (l10n?.usernameRequired ?? 'Username required') : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: l10n?.passwordLabel ?? 'Password',
              hintText: l10n?.passwordHint ?? 'Enter password',
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (val) => (val == null || val.isEmpty) ? (l10n?.passwordRequired ?? 'Password required') : null,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordDialog,
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: Text(
                l10n?.forgotPassword ?? 'Forgot Password?',
                style: const TextStyle(fontSize: 12, color: AppTheme.primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: authState.isLoading ? null : _handleLocalLogin,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: authState.isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(l10n?.signIn ?? 'Sign In', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => setState(() => _isRegisterMode = true),
              child: Text(
                l10n?.dontHaveAccount ?? 'Need an account? Register',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(AppLocalizations? l10n, AuthState authState) {
    return Form(
      key: _registerFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _regDisplayNameController,
              decoration: InputDecoration(
                labelText: l10n?.displayNameLabel ?? 'Display Name (Optional)',
                hintText: l10n?.displayNameHint ?? 'e.g., Ram Shrestha',
                prefixIcon: const Icon(Icons.badge_outlined, size: 20),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _regUsernameController,
              decoration: InputDecoration(
                labelText: l10n?.usernameLabel ?? 'Username',
                hintText: l10n?.usernameHint ?? 'Enter username',
                prefixIcon: const Icon(Icons.person_outline, size: 20),
              ),
              validator: (val) => (val == null || val.trim().isEmpty) ? (l10n?.usernameRequired ?? 'Username required') : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _regPasswordController,
              obscureText: _regObscurePassword,
              decoration: InputDecoration(
                labelText: l10n?.passwordLabel ?? 'Password',
                hintText: l10n?.passwordHint ?? 'Enter password',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(_regObscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
                  onPressed: () => setState(() => _regObscurePassword = !_regObscurePassword),
                ),
              ),
              validator: (val) => (val == null || val.length < 4) ? (l10n?.passwordLengthError ?? 'Min 4 characters') : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _regConfirmPasswordController,
              obscureText: _regObscurePassword,
              decoration: InputDecoration(
                labelText: l10n?.confirmPasswordLabel ?? 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_reset, size: 20),
              ),
              validator: (val) => (val == null || val.isEmpty) ? (l10n?.passwordRequired ?? 'Confirm password') : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedSecurityQuestion,
              decoration: InputDecoration(
                labelText: l10n?.securityQuestionLabel ?? 'Security Question',
                prefixIcon: const Icon(Icons.help_outline, size: 20),
              ),
              isExpanded: true,
              items: _securityQuestions.map((q) => DropdownMenuItem(value: q, child: Text(q, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedSecurityQuestion = val);
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _regSecurityAnswerController,
              decoration: InputDecoration(
                labelText: l10n?.securityAnswerLabel ?? 'Security Answer',
                hintText: l10n?.securityAnswerHint ?? 'Answer used for recovery',
                prefixIcon: const Icon(Icons.key_outlined, size: 20),
              ),
              validator: (val) => (val == null || val.trim().isEmpty) ? (l10n?.securityAnswerRequired ?? 'Answer required') : null,
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: authState.isLoading ? null : _handleLocalRegister,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppTheme.accentTeal,
                foregroundColor: Colors.white,
              ),
              child: authState.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(l10n?.register ?? 'Create Account', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 6),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _isRegisterMode = false),
                child: Text(
                  l10n?.haveAccount ?? 'Already have an account? Sign In',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSignInTab(AppLocalizations? l10n, AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_sync, size: 48, color: AppTheme.primaryBlue),
        const SizedBox(height: 12),
        Text(
          l10n?.googleSignInPrompt ?? 'Sign in with your Google account to enable Google Drive backups and multi-device sync.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: authState.isLoading ? null : _handleGoogleSignIn,
          icon: const Icon(Icons.login, color: AppTheme.primaryBlue),
          label: authState.isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(
                  l10n?.googleSignInButton ?? 'Sign in with Google',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
          ),
        ),
      ],
    );
  }
}

