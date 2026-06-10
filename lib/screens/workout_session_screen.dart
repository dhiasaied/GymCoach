import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../constants/app_routes.dart';
import '../models/workout_card.dart';
import '../providers/workout_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/gym_image.dart';

class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({super.key, required this.workout});

  final WorkoutCardData workout;

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _currentExercise = 0;
  bool _isCompleting = false;

  List<_SessionExercise> get _exercises {
    if (widget.workout.exercises.isNotEmpty) {
      return widget.workout.exercises
          .map((e) => _SessionExercise(e.name, e.setsReps, e.icon))
          .toList();
    }
    return const [
      _SessionExercise('Warm-up', '1 Set x 10 min', Icons.wb_sunny_outlined),
      _SessionExercise('Main Block', '4 Sets x 8 Reps', Icons.fitness_center),
      _SessionExercise('Finisher', '3 Sets x 12 Reps', Icons.bolt),
    ];
  }

  Future<void> _completeWorkout() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    await context.read<WorkoutProvider>().completeSession(widget.workout);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final exercises = _exercises;
    final progress = (_currentExercise + 1) / exercises.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.workout.title, style: AppTypography.headlineMd()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 180,
                child: GymImage(source: widget.workout.imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Exercise ${_currentExercise + 1} of ${exercises.length}',
              style: AppTypography.labelLg(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.surfaceContainerHighest,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Icon(
                    exercises[_currentExercise].icon,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    exercises[_currentExercise].name,
                    style: AppTypography.headlineMd(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    exercises[_currentExercise].setsReps,
                    style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _currentExercise > 0
                        ? () => setState(() => _currentExercise--)
                        : null,
                    child: const Text('PREVIOUS'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentExercise < exercises.length - 1
                        ? () => setState(() => _currentExercise++)
                        : _completeWorkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                    ),
                    child: Text(
                      _currentExercise < exercises.length - 1
                          ? 'NEXT EXERCISE'
                          : (_isCompleting ? 'SAVING...' : 'COMPLETE'),
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

class _SessionExercise {
  const _SessionExercise(this.name, this.setsReps, this.icon);

  final String name;
  final String setsReps;
  final IconData icon;
}

void openWorkoutSession(BuildContext context, WorkoutCardData workout) {
  Navigator.of(context).pushNamed(
    AppRoutes.workoutSession,
    arguments: workout,
  );
}
