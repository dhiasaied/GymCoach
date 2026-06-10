import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../widgets/auth_background.dart';
import '../widgets/form_widgets.dart';
import '../widgets/glass_card.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _success = false;
  String? _bannerError;
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _emailError = Validators.email(_emailController.text);
      _bannerError = _emailError;
    });
    if (_emailError != null) return;

    setState(() => _loading = true);
    final error = await context.read<AuthProvider>().requestPasswordReset(
          _emailController.text.trim(),
        );
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (error != null) {
        _bannerError = error;
      } else {
        _success = true;
      }
    });
  }

  void _resend() async {
    setState(() {
      _success = false;
    });
    await _submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              const BrandHeader(),
              const SizedBox(height: AppSpacing.xl),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceContainerHigh,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.lock_reset, color: AppColors.primary, size: 32),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Recover Access', style: AppTypography.headlineMd()),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Enter your email to receive a secure reset link.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (!_success) ...[
                        if (_bannerError != null) ...[
                          FormBannerError(message: _bannerError!),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        RecessedInputField(
                          controller: _emailController,
                          label: 'Identity',
                          hint: 'Email Address',
                          icon: Icons.alternate_email,
                          keyboardType: TextInputType.emailAddress,
                          errorText: _emailError,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PrimarySubmitButton(
                          label: _loading ? 'PROCESSING...' : 'SEND RESET LINK',
                          loading: _loading,
                          onPressed: _submit,
                        ),
                      ] else ...[
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.1),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(Icons.mark_email_read, color: AppColors.primary, size: 32),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text('Check your inbox', style: AppTypography.headlineMd()),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'A secure link has been sent to your email address.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                        ),
                        TextButton(
                          onPressed: _resend,
                          child: Text(
                            'Resend link?',
                            style: AppTypography.labelLg(color: AppColors.primary),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back, size: 18, color: AppColors.onSurfaceVariant),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Back to Login',
                              style: AppTypography.labelLg(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
