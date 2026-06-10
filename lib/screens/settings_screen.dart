import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../providers/settings_provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/glass_card.dart';
import 'legal_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final workoutProvider = context.watch<WorkoutProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Settings', style: AppTypography.headlineMd()),
      ),
      body: settings.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.containerMargin),
              children: [
                Text('Preferences', style: AppTypography.headlineMd()),
                const SizedBox(height: AppSpacing.md),
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Push Notifications', style: AppTypography.labelLg()),
                        subtitle: Text(
                          'Receive workout reminders and AI insights',
                          style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                        ),
                        value: settings.notificationsEnabled,
                        onChanged: settings.setNotificationsEnabled,
                      ),
                      const Divider(height: AppSpacing.lg),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Metric Units', style: AppTypography.labelLg()),
                        subtitle: Text(
                          settings.useMetricUnits ? 'Kilograms & centimeters' : 'Pounds & inches',
                          style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                        ),
                        value: settings.useMetricUnits,
                        onChanged: settings.setUseMetricUnits,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Training Goals', style: AppTypography.headlineMd()),
                const SizedBox(height: AppSpacing.md),
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weekly Session Goal', style: AppTypography.labelLg()),
                      Text(
                        '${workoutProvider.weeklyGoal} sessions per week',
                        style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                      ),
                      Slider(
                        value: workoutProvider.weeklyGoal.toDouble(),
                        min: 2,
                        max: 7,
                        divisions: 5,
                        label: '${workoutProvider.weeklyGoal}',
                        activeColor: AppColors.primary,
                        onChanged: (value) =>
                            workoutProvider.setWeeklyGoal(value.round()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Support & Legal', style: AppTypography.headlineMd()),
                const SizedBox(height: AppSpacing.md),
                _SettingsLink(
                  icon: Icons.help_outline,
                  title: 'Help & FAQ',
                  subtitle: 'Answers to common questions',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.help),
                ),
                const SizedBox(height: AppSpacing.sm),
                _SettingsLink(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => openLegalDocument(context, LegalDocumentType.terms),
                ),
                const SizedBox(height: AppSpacing.sm),
                _SettingsLink(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => openLegalDocument(context, LegalDocumentType.privacy),
                ),
                const SizedBox(height: AppSpacing.sm),
                _SettingsLink(
                  icon: Icons.info_outline,
                  title: 'About GymCoach',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.about),
                ),
              ],
            ),
    );
  }
}

class _SettingsLink extends StatelessWidget {
  const _SettingsLink({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLg()),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                  ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}
