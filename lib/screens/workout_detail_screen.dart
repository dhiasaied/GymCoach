import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../models/workout_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_image.dart';
import 'workout_session_screen.dart';

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key, required this.workout});

  final WorkoutCardData workout;

  Color _tagColor() {
    switch (workout.tagColor) {
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
    final exercises = workout.exercises;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Program Details', style: AppTypography.headlineMd()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 220,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GymImage(source: workout.imagePath, fit: BoxFit.cover),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xCC000000), Colors.transparent],
                          ),
                        ),
                        child: Text(
                          workout.tag.toUpperCase(),
                          style: AppTypography.labelLg(color: _tagColor()).copyWith(
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(workout.title, style: AppTypography.headlineLg()),
            const SizedBox(height: AppSpacing.sm),
            Text(
              workout.description,
              style: AppTypography.bodyLg(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _InfoChip(Icons.schedule, workout.duration),
                const SizedBox(width: AppSpacing.sm),
                _InfoChip(Icons.bolt, workout.intensity),
                const SizedBox(width: AppSpacing.sm),
                _InfoChip(Icons.category, workout.category),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Exercise Plan', style: AppTypography.headlineMd()),
            const SizedBox(height: AppSpacing.md),
            if (exercises.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'This program includes a guided warm-up, main block, and finisher tailored to your intensity level.',
                  style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                ),
              )
            else
              ...exercises.map(
                (exercise) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Icon(exercise.icon, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exercise.name, style: AppTypography.labelLg()),
                              Text(
                                exercise.setsReps,
                                style: AppTypography.labelMd(color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () => openWorkoutSession(context, workout),
              icon: const Icon(Icons.play_arrow),
              label: const Text('START WORKOUT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size.fromHeight(52),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('BACK TO HUB'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(label, style: AppTypography.labelMd()),
        ],
      ),
    );
  }
}

void openWorkoutDetail(BuildContext context, WorkoutCardData workout) {
  Navigator.of(context).pushNamed(
    AppRoutes.workoutDetail,
    arguments: workout,
  );
}
