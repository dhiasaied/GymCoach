import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../constants/asset_paths.dart';
import '../providers/auth_provider.dart';
import '../utils/toast_helper.dart';
import '../utils/validators.dart';
import '../widgets/auth_background.dart';
import '../widgets/form_widgets.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_image.dart';
import 'legal_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _terms = false;
  bool _obscure = true;
  bool _loading = false;
  String? _bannerError;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _termsError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _bannerError = null;
      _nameError = Validators.name(_nameController.text);
      _emailError = Validators.email(_emailController.text);
      _passwordError = Validators.password(_passwordController.text);
      _confirmError = Validators.confirmPassword(
        _confirmController.text,
        _passwordController.text,
      );
      _termsError = Validators.terms(_terms);
    });

    final errors = [_nameError, _emailError, _passwordError, _confirmError, _termsError]
        .whereType<String>()
        .toList();
    if (errors.isNotEmpty) {
      setState(() => _bannerError = errors.first);
      return;
    }

    setState(() => _loading = true);
    final error = await context.read<AuthProvider>().register(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
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
                      Text('Join the Elite', style: AppTypography.headlineMd()),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Start your transformation today.',
                        style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (_bannerError != null) ...[
                        FormBannerError(message: _bannerError!),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      RecessedInputField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'John Doe',
                        icon: Icons.person,
                        errorText: _nameError,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RecessedInputField(
                        controller: _emailController,
                        label: 'Identity',
                        hint: 'Email Address',
                        icon: Icons.alternate_email,
                        keyboardType: TextInputType.emailAddress,
                        errorText: _emailError,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RecessedInputField(
                        controller: _passwordController,
                        label: 'Security Code',
                        hint: '••••••••',
                        icon: Icons.lock,
                        obscureText: _obscure,
                        errorText: _passwordError,
                        onChanged: (_) => setState(() {}),
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
                      const SizedBox(height: AppSpacing.md),
                      RecessedInputField(
                        controller: _confirmController,
                        label: 'Confirm Security Code',
                        hint: '••••••••',
                        icon: Icons.shield,
                        obscureText: true,
                        errorText: _confirmError,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _terms,
                            onChanged: (v) => setState(() => _terms = v ?? false),
                            activeColor: AppColors.primary,
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'I agree to the ',
                                style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () => openLegalDocument(
                                        context,
                                        LegalDocumentType.terms,
                                      ),
                                      child: Text(
                                        'Terms of Service',
                                        style: AppTypography.labelMd(color: AppColors.primary)
                                            .copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () => openLegalDocument(
                                        context,
                                        LegalDocumentType.privacy,
                                      ),
                                      child: Text(
                                        'Privacy Policy',
                                        style: AppTypography.labelMd(color: AppColors.primary)
                                            .copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_termsError != null)
                        Text(_termsError!, style: AppTypography.labelMd(color: AppColors.error)),
                      const SizedBox(height: AppSpacing.md),
                      PrimarySubmitButton(
                        label: _loading ? 'CREATING ACCOUNT...' : 'CREATE ACCOUNT',
                        loading: _loading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                          child: Text.rich(
                            TextSpan(
                              text: 'Already an athlete? ',
                              style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: AppTypography.bodyMd(color: AppColors.primary)
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
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
