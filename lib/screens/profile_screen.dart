import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../utils/toast_helper.dart';
import '../utils/validators.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/form_widgets.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showEdit = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AuthProvider>().profile;
    _nameController = TextEditingController(text: profile.fullName);
    _emailController = TextEditingController(text: profile.email);
    _weightController = TextEditingController(text: '${profile.weight}');
    _heightController = TextEditingController(text: '${profile.height.toInt()}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final nameError = Validators.name(_nameController.text);
    final emailError = Validators.email(_emailController.text);
    final weightError = Validators.weight(_weightController.text);
    final heightError = Validators.height(_heightController.text);
    final error = nameError ?? emailError ?? weightError ?? heightError;
    if (error != null) {
      showGymCoachToast(context, error);
      return;
    }

    await context.read<AuthProvider>().updateProfile(
          UserProfile(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            weight: double.parse(_weightController.text.replaceAll(',', '.')),
            height: double.parse(_heightController.text.replaceAll(',', '.')),
          ),
        );
    setState(() => _showEdit = false);
    showGymCoachToast(context, 'Profile updated successfully.');
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthProvider>().profile;

    return Stack(
      children: [
        MainScaffold(
          currentNav: BottomNavKey.profile,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.containerMargin,
              88,
              AppSpacing.containerMargin,
              140,
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: GymImage(source: 'assets/images/profile.jpg', fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: MediaQuery.sizeOf(context).width * 0.28,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.workspace_premium, size: 16, color: AppColors.onPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(profile.fullName, style: AppTypography.headlineMd()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Elite Level 42',
                      style: AppTypography.labelLg(color: AppColors.primary).copyWith(letterSpacing: 3),
                    ),
                    const Icon(Icons.bolt, color: AppColors.primary),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _StatCell('Workouts', '128'),
                          _StatCell('Calories', '45k', alignRight: true, valueColor: const Color(0xFFFF6D00)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          _StatCell('Total Hours', '180'),
                          _StatCell('Streak', '15D', alignRight: true, valueColor: AppColors.primary),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Weekly Goal', style: AppTypography.labelMd()),
                          Text('85%', style: AppTypography.labelMd(color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: 0.85,
                          minHeight: 6,
                          backgroundColor: AppColors.surface,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showEdit) ...[
                  const SizedBox(height: AppSpacing.lg),
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Edit Profile', style: AppTypography.headlineMd()),
                        const SizedBox(height: AppSpacing.md),
                        RecessedInputField(
                          controller: _nameController,
                          label: 'Full Name',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        RecessedInputField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: RecessedInputField(
                                controller: _weightController,
                                label: 'Weight (kg)',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: RecessedInputField(
                                controller: _heightController,
                                label: 'Height (cm)',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PrimarySubmitButton(label: 'SAVE CHANGES', onPressed: _saveProfile),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                _ProfileActionButton(
                  icon: Icons.settings_outlined,
                  label: 'SETTINGS',
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ProfileActionButton(
                  icon: Icons.help_outline,
                  label: 'HELP & SUPPORT',
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.help),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _showEdit = !_showEdit),
                    icon: const Icon(Icons.edit),
                    label: const Text('EDIT PROFILE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<AuthProvider>().logout();
                    if (!context.mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (_) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainer,
                    foregroundColor: AppColors.error,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
        const GymCoachBottomNav(current: BottomNavKey.profile),
      ],
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.primary),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell(
    this.label,
    this.value, {
    this.alignRight = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool alignRight;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTypography.labelMd(color: AppColors.onSurfaceVariant)),
          Text(
            value,
            style: AppTypography.headlineMd(color: valueColor ?? AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}
