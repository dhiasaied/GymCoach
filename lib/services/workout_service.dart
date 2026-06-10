import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/asset_paths.dart';
import '../models/activity_record.dart';
import '../models/workout_card.dart';
import '../models/workout_exercise.dart';
import 'storage_service.dart';

class WorkoutService {
  WorkoutService({StorageService? storage}) : _storage = storage ?? StorageService();

  final StorageService _storage;

  static const defaultExercises = [
    WorkoutExercise(name: 'Warm-up Flow', setsReps: '1 Set x 10 min'),
    WorkoutExercise(name: 'Main Compound Lift', setsReps: '4 Sets x 6 Reps'),
    WorkoutExercise(name: 'Accessory Work', setsReps: '3 Sets x 10 Reps'),
    WorkoutExercise(name: 'Cooldown Stretch', setsReps: '1 Set x 5 min'),
  ];

  static const seedWorkouts = [
    WorkoutCardData(
      id: 'hypertrophy-max',
      title: 'Hypertrophy Max',
      description:
          'Optimized volume for rapid muscle density and explosive power.',
      duration: '75 min',
      durationMinutes: 75,
      intensity: 'High',
      tag: 'Advanced • Strength',
      tagColor: 'primary',
      category: 'mass',
      imagePath:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD0q6IaVo1CY4fwoCwOpCsfoayA7nGYrIaGOp9SY-baMxzBua1ufpGjhg7MPRSNsXg6EPaIVO3HPcbrI4Tdb60UribO7USkUHjpE2Ve-Ib1IR3qBzJtOK42MXOC37Z84589u4HHs8rqa4bzR3HqE896TXN_kE5p5m47cCSH_hdvPkALkzQoo_h2di4iSe-2XEeIB2BPHY4muMIDOfQKvfkReux10aU-tWEC8XQTCKJDKgBn1Pd6bX9A4TQvdU9ZW36nYWFPMAuF84s',
      isFeatured: true,
      usePlayButton: true,
      exercises: [
        WorkoutExercise(name: 'Barbell Squat', setsReps: '5 Sets x 5 Reps'),
        WorkoutExercise(name: 'Romanian Deadlift', setsReps: '4 Sets x 8 Reps'),
        WorkoutExercise(name: 'Leg Press', setsReps: '3 Sets x 12 Reps'),
        WorkoutExercise(name: 'Calf Raises', setsReps: '4 Sets x 15 Reps'),
      ],
    ),
    WorkoutCardData(
      id: 'metabolic-shred',
      title: 'Metabolic Shred',
      description:
          'High-intensity intervals designed to incinerate fat and boost V02 max.',
      duration: '45 min',
      durationMinutes: 45,
      intensity: 'Intense',
      tag: 'Intermediate • Burn',
      tagColor: 'secondary',
      category: 'weight-loss',
      imagePath:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAmAyYqWBN-PaiK5syFsDOcovhSOt02tW7NJuSS9l9wjiEPKCJjNqMACyg9AwkK0KYe_irv52Kg5FXjVdZfWQf7AieE54iaGXerProLbtiGGXQ_yMqvfruGpUhhdkS_O4tjE9KVmsFVoXu31ZACPVOrnfKCsESgrCzqy3fsdpgR4B4JVHlBkUBVKulENao391O9JoEyPub77ERVMtyGb2uqmqTosD48UJVHDi43Jx-gy2MgjALPJSYhV7FfPVXjpRtp588rjzKYFAA',
      exercises: [
        WorkoutExercise(name: 'Burpees', setsReps: '5 Sets x 30 sec'),
        WorkoutExercise(name: 'Kettlebell Swings', setsReps: '4 Sets x 20 Reps'),
        WorkoutExercise(name: 'Mountain Climbers', setsReps: '4 Sets x 40 sec'),
        WorkoutExercise(name: 'Battle Ropes', setsReps: '3 Sets x 45 sec'),
      ],
    ),
    WorkoutCardData(
      id: 'endurance-engine',
      title: 'Endurance Engine',
      description: 'Build a relentless aerobic base with steady-state progression.',
      duration: '60 min',
      durationMinutes: 60,
      intensity: 'Moderate',
      tag: 'Beginner • Stamina',
      tagColor: 'tertiary',
      category: 'endurance',
      imagePath:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBttn8LaUmk_OozUasUiCeozbh2xUsYG27GjrW1g7cOAVke5wzFdo-xUAP-QUCX3y_Sf0o35re4NA_C_iTaOZOcefdhH0PxUN3KWgWUjwRG6T2VKf3YF_wmN_TwmUD_e7qfZrBaaoZHEuD43KQObb7h2YYPDQrjSLcwktNGsIe6qiLP-8DQDAoB2dliVW64o9s5UKcJFlbkSVan9kF9j0f2z_jjwWPGO10MVQPKEW4XBJY-Rmd0fmdSEarMF4i8wu_liRH887TpZuI',
      exercises: [
        WorkoutExercise(name: 'Treadmill Intervals', setsReps: '6 Sets x 5 min'),
        WorkoutExercise(name: 'Rowing Machine', setsReps: '3 Sets x 10 min'),
        WorkoutExercise(name: 'Cycling Cooldown', setsReps: '1 Set x 10 min'),
      ],
    ),
    WorkoutCardData(
      id: 'restore-flow',
      title: 'Restore Flow',
      description:
          'Gentle yoga and mobility flows to accelerate recovery and restore full range of motion.',
      duration: '40 min',
      durationMinutes: 40,
      intensity: 'Low',
      tag: 'Beginner • Recovery',
      tagColor: 'tertiary',
      category: 'endurance',
      imagePath: AssetPaths.recoveryYoga,
      exercises: [
        WorkoutExercise(name: 'Cat-Cow Stretch', setsReps: '2 Sets x 10 Reps', icon: Icons.self_improvement),
        WorkoutExercise(name: 'Hip Flexor Flow', setsReps: '3 Sets x 60 sec', icon: Icons.self_improvement),
        WorkoutExercise(name: 'Thoracic Rotation', setsReps: '2 Sets x 8 Reps', icon: Icons.self_improvement),
      ],
    ),
    WorkoutCardData(
      id: 'core-fortress',
      title: 'Core Fortress',
      description:
          'Progressive core stability drills engineered for spine protection and athletic balance.',
      duration: '50 min',
      durationMinutes: 50,
      intensity: 'Moderate',
      tag: 'Intermediate • Strength Core',
      tagColor: 'secondary',
      category: 'mass',
      imagePath: AssetPaths.coreStability,
      exercises: [
        WorkoutExercise(name: 'Plank Hold', setsReps: '4 Sets x 60 sec'),
        WorkoutExercise(name: 'Pallof Press', setsReps: '3 Sets x 12 Reps'),
        WorkoutExercise(name: 'Hanging Leg Raises', setsReps: '3 Sets x 10 Reps'),
      ],
    ),
    WorkoutCardData(
      id: 'titan-protocol',
      title: 'Titan Protocol',
      description:
          'Maximal compound lifts targeting peak neural drive and absolute strength gains.',
      duration: '80 min',
      durationMinutes: 80,
      intensity: 'Very High',
      tag: 'Advanced • Power Lift',
      tagColor: 'primary',
      category: 'mass',
      imagePath: AssetPaths.powerLift,
      exercises: [
        WorkoutExercise(name: 'Deadlift', setsReps: '5 Sets x 3 Reps'),
        WorkoutExercise(name: 'Bench Press', setsReps: '5 Sets x 5 Reps'),
        WorkoutExercise(name: 'Overhead Press', setsReps: '4 Sets x 6 Reps'),
      ],
    ),
    WorkoutCardData(
      id: 'fat-burn-hiit-pro',
      title: 'Fat Burn HIIT Pro',
      description:
          'Explosive metabolic circuits engineered for maximum calorie burn and fat oxidation.',
      duration: '35 min',
      durationMinutes: 35,
      intensity: 'Extreme',
      tag: 'Pro • Fat Burn',
      tagColor: 'secondary',
      category: 'weight-loss',
      imagePath: AssetPaths.hiitPro,
      exercises: [
        WorkoutExercise(name: 'Box Jumps', setsReps: '4 Sets x 6 Reps', icon: Icons.auto_mode),
        WorkoutExercise(name: 'Goblet Squats', setsReps: '3 Sets x 8 Reps'),
        WorkoutExercise(name: 'Sprint Intervals', setsReps: '6 Sets x 30 sec', icon: Icons.directions_run),
      ],
    ),
  ];

  static const filterCategories = ['all', 'mass', 'weight-loss', 'endurance'];

  Future<List<WorkoutCardData>> loadAllWorkouts() async {
    final customRaw = await _storage.loadCustomWorkouts();
    final custom = customRaw.map(_workoutFromJson).toList();
    return [...seedWorkouts, ...custom];
  }

  WorkoutCardData? findById(String id, List<WorkoutCardData> workouts) {
    for (final workout in workouts) {
      if (workout.id == id) return workout;
    }
    return null;
  }

  List<WorkoutCardData> filterByCategory(
    List<WorkoutCardData> workouts,
    int filterIndex,
  ) {
    if (filterIndex <= 0 || filterIndex >= filterCategories.length) {
      return workouts;
    }
    final category = filterCategories[filterIndex];
    return workouts.where((w) => w.category == category).toList();
  }

  WorkoutCardData getDailyRecommendation(List<WorkoutCardData> workouts) {
    return workouts.firstWhere(
      (w) => w.id == 'hypertrophy-max',
      orElse: () => workouts.first,
    );
  }

  Future<List<ActivityRecord>> loadActivities() async {
    final raw = await _storage.loadActivities();
    if (raw.isEmpty) {
      return _defaultActivities();
    }
    return raw.map(ActivityRecord.fromJson).toList();
  }

  List<ActivityRecord> _defaultActivities() {
    final now = DateTime.now();
    return [
      ActivityRecord(
        id: 'seed-1',
        title: 'Heavy Pull Day',
        subtitle: 'Yesterday • 1h 22m',
        durationMinutes: 82,
        completedAt: now.subtract(const Duration(days: 1)),
        icon: Icons.fitness_center,
        colorValue: AppColors.primary.value,
        workoutId: 'titan-protocol',
      ),
      ActivityRecord(
        id: 'seed-2',
        title: 'Zone 2 Cardio',
        subtitle: '2 days ago • 45m',
        durationMinutes: 45,
        completedAt: now.subtract(const Duration(days: 2)),
        icon: Icons.directions_run,
        colorValue: AppColors.tertiary.value,
        workoutId: 'endurance-engine',
      ),
      ActivityRecord(
        id: 'seed-3',
        title: 'Active Recovery',
        subtitle: '3 days ago • 30m',
        durationMinutes: 30,
        completedAt: now.subtract(const Duration(days: 3)),
        icon: Icons.self_improvement,
        colorValue: AppColors.secondary.value,
        workoutId: 'restore-flow',
      ),
    ];
  }

  Future<ActivityRecord> completeSession(WorkoutCardData workout) async {
    final activities = await loadActivities();
    final now = DateTime.now();
    final record = ActivityRecord(
      id: 'activity-${now.millisecondsSinceEpoch}',
      title: workout.title,
      subtitle: 'Just now • ${workout.duration}',
      durationMinutes: workout.durationMinutes,
      completedAt: now,
      icon: Icons.fitness_center,
      colorValue: AppColors.primary.value,
      workoutId: workout.id,
    );

    final updated = [record, ...activities];
    await _storage.saveActivities(updated.map((a) => a.toJson()).toList());

    final weeklyCount = await _storage.loadWeeklySessions();
    await _storage.saveWeeklySessions(weeklyCount + 1);

    return record;
  }

  Future<WorkoutCardData> createCustomWorkout({
    required String title,
    required String description,
    required String duration,
    required int durationMinutes,
    required String intensity,
    required String category,
  }) async {
    final id = 'custom-${DateTime.now().millisecondsSinceEpoch}';
    final workout = WorkoutCardData(
      id: id,
      title: title,
      description: description,
      duration: duration,
      durationMinutes: durationMinutes,
      intensity: intensity,
      tag: 'Custom • $intensity',
      tagColor: 'primary',
      category: category,
      imagePath: AssetPaths.coreStability,
      usePlayButton: true,
      exercises: defaultExercises,
    );

    final customRaw = await _storage.loadCustomWorkouts();
    customRaw.add(_workoutToJson(workout));
    await _storage.saveCustomWorkouts(customRaw);
    return workout;
  }

  Future<int> loadWeeklySessions() => _storage.loadWeeklySessions();

  Future<int> loadWeeklyGoal() => _storage.loadWeeklyGoal();

  Future<void> saveWeeklyGoal(int goal) => _storage.saveWeeklyGoal(goal);

  Map<String, dynamic> _workoutToJson(WorkoutCardData workout) => {
        'id': workout.id,
        'title': workout.title,
        'description': workout.description,
        'duration': workout.duration,
        'durationMinutes': workout.durationMinutes,
        'intensity': workout.intensity,
        'tag': workout.tag,
        'tagColor': workout.tagColor,
        'category': workout.category,
        'imagePath': workout.imagePath,
        'usePlayButton': workout.usePlayButton,
        'exercises': workout.exercises
            .map(
              (e) => {
                'name': e.name,
                'setsReps': e.setsReps,
                'iconCodePoint': e.icon.codePoint,
              },
            )
            .toList(),
      };

  WorkoutCardData _workoutFromJson(Map<String, dynamic> json) {
    final exercisesRaw = (json['exercises'] as List?) ?? [];
    return WorkoutCardData(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      duration: json['duration'] as String,
      durationMinutes: json['durationMinutes'] as int? ?? 45,
      intensity: json['intensity'] as String,
      tag: json['tag'] as String,
      tagColor: json['tagColor'] as String? ?? 'primary',
      category: json['category'] as String? ?? 'mass',
      imagePath: json['imagePath'] as String,
      usePlayButton: json['usePlayButton'] as bool? ?? true,
      exercises: exercisesRaw
          .map(
            (e) => WorkoutExercise(
              name: (e as Map)['name'] as String,
              setsReps: e['setsReps'] as String,
              icon: IconData(e['iconCodePoint'] as int? ?? Icons.fitness_center.codePoint),
            ),
          )
          .toList(),
    );
  }
}
