import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../providers/workout_provider.dart';
import '../utils/toast_helper.dart';
import '../utils/validators.dart';
import '../widgets/form_widgets.dart';
import '../widgets/glass_card.dart';
import 'workout_session_screen.dart';

class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController(text: '45');
  String _intensity = 'Moderate';
  String _category = 'mass';
  bool _loading = false;

  static const _intensities = ['Low', 'Moderate', 'High', 'Intense'];
  static const _categories = [
    ('mass', 'Mass / Strength'),
    ('weight-loss', 'Weight Loss'),
    ('endurance', 'Endurance'),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _createWorkout({required bool startNow}) async {
    final titleError = Validators.name(_titleController.text);
    if (titleError != null) {
      showGymCoachToast(context, titleError);
      return;
    }
    if (_descriptionController.text.trim().length < 10) {
      showGymCoachToast(context, 'Description must be at least 10 characters.');
      return;
    }
    final minutes = int.tryParse(_durationController.text.trim());
    if (minutes == null || minutes < 10 || minutes > 180) {
      showGymCoachToast(context, 'Duration must be between 10 and 180 minutes.');
      return;
    }

    setState(() => _loading = true);
    final workout = await context.read<WorkoutProvider>().createCustomWorkout(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          duration: '$minutes min',
          durationMinutes: minutes,
          intensity: _intensity,
          category: _category,
        );
    if (!mounted) return;
    setState(() => _loading = false);

    if (startNow) {
      Navigator.of(context).pop();
      openWorkoutSession(context, workout);
    } else {
      Navigator.of(context).pop(true);
      showGymCoachToast(context, 'Workout "${workout.title}" created.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Create Workout', style: AppTypography.headlineMd()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Build a custom training session',
                style: AppTypography.bodyMd(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              RecessedInputField(
                controller: _titleController,
                label: 'Workout Name',
                hint: 'Upper Body Power',
              ),
              const SizedBox(height: AppSpacing.md),
              RecessedInputField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your session goals...',
              ),
              const SizedBox(height: AppSpacing.md),
              RecessedInputField(
                controller: _durationController,
                label: 'Duration (minutes)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Intensity', style: AppTypography.labelLg()),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: _intensities.map((level) {
                  final selected = _intensity == level;
                  return ChoiceChip(
                    label: Text(level),
                    selected: selected,
                    onSelected: (_) => setState(() => _intensity = level),
                    selectedColor: AppColors.primary.withValues(alpha: 0.3),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Category', style: AppTypography.labelLg()),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                value: _category,
                dropdownColor: AppColors.surfaceContainer,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.$1,
                        child: Text(c.$2),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _category = v ?? 'mass'),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimarySubmitButton(
                label: _loading ? 'CREATING...' : 'SAVE WORKOUT',
                loading: _loading,
                onPressed: () => _createWorkout(startNow: false),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: _loading ? null : () => _createWorkout(startNow: true),
                child: const Text('CREATE & START NOW'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
