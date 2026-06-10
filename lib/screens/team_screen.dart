import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../constants/asset_paths.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_image.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  static const _members = [
    (
      name: 'Alex Mercer',
      role: 'Head Coach & AI Architect',
      bio: 'Designs adaptive training algorithms and recovery models.',
    ),
    (
      name: 'Sofia Chen',
      role: 'Performance Scientist',
      bio: 'Translates biomechanics data into actionable workout plans.',
    ),
    (
      name: 'Marcus Reid',
      role: 'Product Lead',
      bio: 'Builds the athlete experience from session flow to analytics.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Our Team', style: AppTypography.headlineMd()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GymImage(
                      source: AssetPaths.teamPhoto,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Neural Motion Team', style: AppTypography.headlineLg()),
                  Text(
                    'Architects of Performance',
                    style: AppTypography.labelLg(color: AppColors.primary).copyWith(letterSpacing: 3),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'We combine sports science, machine learning, and elite coaching experience to help athletes train smarter, recover faster, and perform at their peak.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLg(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Meet the Team', style: AppTypography.headlineMd()),
            const SizedBox(height: AppSpacing.md),
            ..._members.map(
              (member) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                        child: Text(
                          member.name.split(' ').map((p) => p[0]).take(2).join(),
                          style: AppTypography.labelLg(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member.name, style: AppTypography.labelLg()),
                            Text(
                              member.role.toUpperCase(),
                              style: AppTypography.labelMd(color: AppColors.primary),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              member.bio,
                              style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
