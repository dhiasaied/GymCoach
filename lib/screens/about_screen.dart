import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../constants/asset_paths.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_image.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainScaffold(
          currentNav: BottomNavKey.about,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              88,
              AppSpacing.gutter,
              140,
            ),
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.fitness_center, color: AppColors.primary, size: 48),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('GymCoach', style: AppTypography.displayLgMobile()),
                Text(
                  'Your Intelligent Fitness Coach Powered by AI',
                  textAlign: TextAlign.center,
                  style: AppTypography.labelLg(color: AppColors.primary).copyWith(letterSpacing: 3),
                ),
                const SizedBox(height: AppSpacing.xl),
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Text(
                        'The Intelligence Hub',
                        style: AppTypography.headlineMd(color: AppColors.primary),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'The intelligent fitness ecosystem driven by advanced AI to track, optimize, and transform your training journey. We bridge the gap between complex data and actionable peak performance.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLg(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Core Capabilities', style: AppTypography.headlineMd()),
                const SizedBox(height: AppSpacing.lg),
                _FeatureCard(
                  icon: Icons.smart_toy,
                  color: AppColors.secondaryContainer,
                  title: 'AI Coach',
                  body: 'Real-time adaptive feedback based on your biological markers.',
                  onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.aiCoach),
                ),
                const SizedBox(height: AppSpacing.md),
                _FeatureCard(
                  icon: Icons.calendar_month,
                  color: AppColors.primary,
                  title: 'Workout Plans',
                  body: 'Dynamically generated routines tailored to your equipment and goals.',
                  onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.home),
                ),
                const SizedBox(height: AppSpacing.md),
                _FeatureCard(
                  icon: Icons.monitor_heart_outlined,
                  color: AppColors.tertiaryContainer,
                  title: 'Progress Tracking',
                  body: 'Advanced visualization of volume, intensity, and muscle fatigue.',
                  onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.progressAnalytics),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  '"To empower human potential through intelligent technology and disciplined movement."',
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineMd().copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: AppSpacing.xl),
                GlassCard(
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.team),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GymImage(
                          source: AssetPaths.teamPhoto,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Neural Motion Team', style: AppTypography.headlineMd()),
                            Text(
                              'Architects of Performance',
                              style: AppTypography.labelLg(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Version 2.4.0 (Build 89)',
                  style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
        const GymCoachBottomNav(current: BottomNavKey.about),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.2),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: AppTypography.labelLg()),
          const SizedBox(height: AppSpacing.xs),
          Text(body, textAlign: TextAlign.center, style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
