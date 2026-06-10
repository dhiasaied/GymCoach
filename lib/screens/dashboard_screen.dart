import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../models/activity_record.dart';
import '../providers/workout_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/glass_card.dart';
import 'workout_session_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<WorkoutProvider>().activities;

    return Stack(
      children: [
        MainScaffold(
          currentNav: BottomNavKey.training,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 72),
            child: FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.createWorkout),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.onPrimary),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.2,
                colors: [Color(0xFF1C3D2A), AppColors.background],
                stops: [0, 0.4],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerMargin,
                88,
                AppSpacing.containerMargin,
                140,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Elite Level 42',
                    style: AppTypography.labelLg(color: AppColors.primary).copyWith(
                      letterSpacing: 4,
                    ),
                  ),
                  Text('Good Morning, Athlete', style: AppTypography.headlineLg()),
                  Container(
                    margin: const EdgeInsets.only(top: AppSpacing.sm),
                    width: 96,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _StatCard(
                    icon: Icons.local_fire_department,
                    color: AppColors.tertiary,
                    title: 'Energy Burned',
                    value: '1,420',
                    unit: 'kcal',
                    progress: 0.72,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _StatCard(
                    icon: Icons.timer,
                    color: AppColors.primary,
                    title: 'Training Time',
                    value: '84',
                    unit: 'min',
                    subtitle: '+12% vs last week',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GlassCard(
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.aiCoach),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.smart_toy, color: AppColors.secondary),
                                Text(
                                  'AI Coach Focus',
                                  style: AppTypography.labelLg(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'LIVE',
                                style: AppTypography.labelMd(color: AppColors.secondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.base),
                        Text(
                          '"High intensity leg volume detected. Optimize recovery with 20g protein and mobility flow."',
                          style: AppTypography.bodyMd(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed(AppRoutes.aiCoach),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: AppColors.onSecondary,
                            ),
                            child: const Text('Talk to AI Coach'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Activity', style: AppTypography.headlineMd()),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.activityHistory),
                        child: Text(
                          'View All',
                          style: AppTypography.labelLg(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 96,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var i = 0; i < activities.take(3).length; i++) ...[
                          if (i > 0) const SizedBox(width: AppSpacing.md),
                          _ActivityTile(
                            activity: activities[i],
                            onTap: () => _openActivity(context, activities[i]),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Training Distribution', style: AppTypography.headlineMd()),
                        Text(
                          'Weekly volume by muscle group',
                          style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: 192,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _ChartBar(height: 0.4, color: AppColors.primary),
                              _ChartBar(height: 0.65, color: AppColors.primary),
                              _ChartBar(height: 0.85, color: AppColors.primary),
                              _ChartBar(height: 0.55, color: AppColors.tertiary),
                              _ChartBar(height: 0.95, color: AppColors.primary),
                              _ChartBar(height: 0.45, color: AppColors.tertiary),
                              _ChartBar(height: 0.7, color: AppColors.primary),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                              .map(
                                (d) => Text(
                                  d,
                                  style: AppTypography.labelMd(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const GymCoachBottomNav(),
      ],
    );
  }

  void _openActivity(BuildContext context, ActivityRecord activity) {
    final workoutId = activity.workoutId;
    if (workoutId == null) return;
    final workout = context.read<WorkoutProvider>().workoutById(workoutId);
    if (workout == null) return;
    openWorkoutSession(context, workout);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.unit,
    this.progress,
    this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String unit;
  final double? progress;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, fill: 1.0),
          Text(title.toUpperCase(), style: AppTypography.labelLg(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AppTypography.displayLg(color: color)),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(unit, style: AppTypography.labelMd(color: AppColors.onSurfaceVariant)),
              ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: AppColors.surfaceContainerLow,
                color: color,
              ),
            ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.trending_up, color: color, size: 16),
                const SizedBox(width: 4),
                Text(subtitle!, style: AppTypography.labelMd(color: color)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.activity,
    required this.onTap,
  });

  final ActivityRecord activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(activity.colorValue);
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        borderRadius: 12,
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(activity.icon, color: color, size: 32),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(activity.title, style: AppTypography.labelLg()),
                Text(activity.subtitle, style: AppTypography.labelMd(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: FractionallySizedBox(
          heightFactor: height,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }
}
