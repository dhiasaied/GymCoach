import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../models/workout_card.dart';
import '../providers/workout_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/form_widgets.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_image.dart';
import 'workout_detail_screen.dart';
import 'workout_session_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _filters = [
    'All Programs',
    'Mass',
    'Weight Loss',
    'Endurance',
  ];

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();
    final workouts = workoutProvider.filteredWorkouts;
    final recommendation = workoutProvider.dailyRecommendation;

    return Stack(
      children: [
        MainScaffold(
          currentNav: BottomNavKey.training,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 72, right: 8),
            child: FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.createWorkout),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.onPrimary),
            ),
          ),
          body: workoutProvider.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.containerMargin,
                    88,
                    AppSpacing.containerMargin,
                    140,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Workout Hub', style: AppTypography.headlineLg()),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Precision training plans for elite performance.',
                        style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GlassCard(
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.dashboard),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.dashboard_outlined, color: AppColors.primary),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Athlete Dashboard', style: AppTypography.labelLg()),
                                  Text(
                                    'Energy, training time & recent activity',
                                    style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      FilterChipBar(
                        labels: _filters,
                        selectedIndex: workoutProvider.filterIndex,
                        onSelected: workoutProvider.setFilterIndex,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (workouts.isEmpty)
                        GlassCard(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Text(
                            'No programs match this filter.',
                            style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                          ),
                        )
                      else
                        ...workouts.map(
                          (w) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: WorkoutCardWidget(data: w),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.xl),
                      _AiRecommendation(
                        recommendation: recommendation,
                        weeklyProgress: workoutProvider.weeklyProgress,
                        weeklySessions: workoutProvider.weeklySessions,
                        weeklyGoal: workoutProvider.weeklyGoal,
                      ),
                    ],
                  ),
                ),
        ),
        const GymCoachBottomNav(current: BottomNavKey.training),
      ],
    );
  }
}

class WorkoutCardWidget extends StatelessWidget {
  const WorkoutCardWidget({super.key, required this.data});

  final WorkoutCardData data;

  Color _tagColor() {
    switch (data.tagColor) {
      case 'secondary':
        return AppColors.secondary;
      case 'tertiary':
        return AppColors.tertiaryFixedDim;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openWorkoutDetail(context, data),
      child: GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      border: data.isFeatured
          ? Border.all(color: AppColors.primary.withValues(alpha: 0.5))
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.isFeatured)
            Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.stars, color: AppColors.primary, fill: 1.0),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 192,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GymImage(source: data.imagePath, opacity: 0.6),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xCC000000), Colors.transparent],
                        ),
                      ),
                      child: Text(
                        data.tag.toUpperCase(),
                        style: AppTypography.labelMd(color: _tagColor()).copyWith(
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(data.title, style: AppTypography.headlineMd()),
          const SizedBox(height: AppSpacing.xs),
          Text(
            data.description,
            style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(data.duration, style: AppTypography.labelMd(color: AppColors.onSurfaceVariant)),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(Icons.bolt, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(data.intensity, style: AppTypography.labelMd(color: AppColors.onSurfaceVariant)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  openWorkoutSession(context, data);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.usePlayButton
                        ? AppColors.primary
                        : AppColors.surfaceContainerHighest,
                    border: data.usePlayButton
                        ? null
                        : Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Icon(
                    data.usePlayButton ? Icons.play_arrow : Icons.chevron_right,
                    color: data.usePlayButton ? AppColors.onPrimary : AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

class _AiRecommendation extends StatelessWidget {
  const _AiRecommendation({
    required this.recommendation,
    required this.weeklyProgress,
    required this.weeklySessions,
    required this.weeklyGoal,
  });

  final WorkoutCardData recommendation;
  final double weeklyProgress;
  final int weeklySessions;
  final int weeklyGoal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Coach Recommendation',
                      style: AppTypography.headlineMd(color: AppColors.primary),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text.rich(
                      TextSpan(
                        text:
                            'Based on your recent sleep data and recovery score (88/100), we recommend a high-intensity ',
                        style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                        children: [
                          TextSpan(
                            text: recommendation.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' session today.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => openWorkoutSession(context, recommendation),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimaryContainer,
                      ),
                      child: const Text('Start Daily Target'),
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.smart_toy_outlined, color: AppColors.primary, size: 48),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Text(
                'WEEKLY PROGRESS',
                style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.base),
              SizedBox(
                width: 128,
                height: 128,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: weeklyProgress,
                      strokeWidth: 8,
                      backgroundColor: AppColors.surfaceContainerHighest,
                      color: AppColors.primary,
                    ),
                    Text(
                      '${(weeklyProgress * 100).round()}%',
                      style: AppTypography.headlineMd(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '$weeklySessions of $weeklyGoal sessions completed',
                style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
