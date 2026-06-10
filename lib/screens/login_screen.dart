import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../constants/asset_paths.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../utils/toast_helper.dart';
import '../utils/validators.dart';
import '../widgets/auth_background.dart';
import '../widgets/captcha_widget.dart';
import '../widgets/form_widgets.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaKey = GlobalKey<CaptchaWidgetState>();
  bool _obscure = true;
  bool _loading = false;
  String? _bannerError;
  String? _emailError;
  String? _passwordError;
  String? _captchaError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _bannerError = null;
      _emailError = Validators.email(_emailController.text);
      _passwordError = Validators.loginPassword(_passwordController.text);
      final captcha = _captchaKey.currentState;
      _captchaError = Validators.captchaVerified(captcha?.isVerified);
      if (_captchaError == null && captcha != null && captcha.isVerified) {
        _captchaError = Validators.captchaAnswer(
          captcha.inputValue,
          captcha.expectedCode,
        );
        if (_captchaError?.contains('Incorrect') == true) {
          captcha.refresh();
        }
      }
    });

    final errors = [_emailError, _passwordError, _captchaError]
        .whereType<String>()
        .toList();
    if (errors.isNotEmpty) {
      setState(() => _bannerError = errors.first);
      return;
    }

    setState(() => _loading = true);
    final error = await context.read<AuthProvider>().login(
          _emailController.text.trim(),
          _passwordController.text,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (error != null) {
      setState(() => _bannerError = error);
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Welcome Back', style: AppTypography.headlineMd()),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Access your training protocols.',
                        style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.lg),
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
                        onChanged: (_) {
                          if (_emailError != null) setState(() => _emailError = null);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Security Code',
                            style: AppTypography.labelLg(color: AppColors.onSurfaceVariant),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(AppRoutes.forgotPassword),
                            child: Text(
                              'Forgot?',
                              style: AppTypography.labelMd(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      RecessedInputField(
                        controller: _passwordController,
                        hint: '••••••••',
                        icon: Icons.lock,
                        obscureText: _obscure,
                        errorText: _passwordError,
                        onChanged: (_) {
                          if (_passwordError != null) setState(() => _passwordError = null);
                        },
                        suffix: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      PasswordStrengthBar(password: _passwordController.text),
                      const SizedBox(height: AppSpacing.sm),
                      CaptchaWidget(
                        key: _captchaKey,
                        errorText: _captchaError,
                        onCodeChanged: (_) {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PrimarySubmitButton(
                        label: _loading ? 'SIGNING IN...' : 'SIGN IN',
                        loading: _loading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: Text(
                              'SECURE CONNECT',
                              style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              label: 'Google',
                              child: const GymImage(
                                source: AssetPaths.googleIcon,
                                width: 20,
                                height: 20,
                              ),
                              onTap: () async {
                                final error = await context
                                    .read<AuthProvider>()
                                    .socialLogin(SocialProvider.google);
                                if (!context.mounted) return;
                                if (error != null) {
                                  showGymCoachToast(context, error);
                                  return;
                                }
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.home);
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _SocialButton(
                              label: 'Apple',
                              icon: Icons.apps,
                              onTap: () async {
                                final error = await context
                                    .read<AuthProvider>()
                                    .socialLogin(SocialProvider.apple);
                                if (!context.mounted) return;
                                if (error != null) {
                                  showGymCoachToast(context, error);
                                  return;
                                }
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.home);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'New athlete? ',
                            style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pushNamed(AppRoutes.register),
                            child: Text(
                              'Recruit Now',
                              style: AppTypography.bodyMd(color: AppColors.primary)
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    this.icon,
    this.child,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      borderRadius: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (child != null) child!,
          if (icon != null)
            Icon(icon, color: AppColors.onSurface.withValues(alpha: 0.8)),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.labelLg()),
        ],
      ),
    );
  }
}
