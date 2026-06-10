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

class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({super.key});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }

  void _openActivity(BuildContext context, ActivityRecord activity) {
    final provider = context.read<WorkoutProvider>();
    final workoutId = activity.workoutId;
    if (workoutId == null) return;
    final workout = provider.workoutById(workoutId);
    if (workout == null) return;
    openWorkoutSession(context, workout);
  }

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<WorkoutProvider>().activities;

    return Stack(
      children: [
        MainScaffold(
          currentNav: BottomNavKey.insights,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.containerMargin,
              88,
              AppSpacing.containerMargin,
              140,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Activity History', style: AppTypography.headlineLg()),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${activities.length} sessions logged',
                  style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (activities.isEmpty)
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'No activity yet. Complete a workout to see it here.',
                      style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                    ),
                  )
                else
                  ...activities.map(
                    (activity) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _ActivityHistoryTile(
                        activity: activity,
                        dateLabel: _formatDate(activity.completedAt),
                        onTap: () => _openActivity(context, activity),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const GymCoachBottomNav(current: BottomNavKey.insights),
      ],
    );
  }
}

class _ActivityHistoryTile extends StatelessWidget {
  const _ActivityHistoryTile({
    required this.activity,
    required this.dateLabel,
    required this.onTap,
  });

  final ActivityRecord activity;
  final String dateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Color(activity.colorValue).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(activity.icon, color: Color(activity.colorValue)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.title, style: AppTypography.labelLg()),
                  Text(
                    '$dateLabel • ${activity.durationMinutes} min',
                    style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
