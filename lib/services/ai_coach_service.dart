import 'package:flutter/material.dart';

import '../constants/asset_paths.dart';
import '../models/workout_card.dart';
import '../models/workout_exercise.dart';

class AiCoachService {
  String generateReply(String userMessage) {
    final text = userMessage.toLowerCase();

    if (text.contains('leg') || text.contains('squat')) {
      return 'For leg day, prioritize compound movements first. I recommend starting with squats, then RDLs, and finishing with calf work. Your recovery score supports heavy loading today.';
    }
    if (text.contains('recovery') || text.contains('rest') || text.contains('sleep')) {
      return 'Your recovery metrics look solid at 88%. If you feel fatigued, switch to mobility work. Otherwise, a moderate-to-high intensity session is safe.';
    }
    if (text.contains('diet') || text.contains('nutrition') || text.contains('protein')) {
      return 'Target 1.8–2.2g protein per kg of body weight on training days. Post-workout, aim for 25–30g protein within 60 minutes.';
    }
    if (text.contains('hiit') || text.contains('cardio') || text.contains('fat')) {
      return 'For fat loss, combine 2–3 HIIT sessions with steady-state cardio. Metabolic Shred or Fat Burn HIIT Pro would fit your current profile.';
    }
    if (text.contains('plan') || text.contains('program') || text.contains('workout')) {
      return 'I can build a full session for you. Tap "GENERATE FULL WORKOUT" below to launch a Plyometric-Power Cluster tailored to your fatigue levels.';
    }

    return 'Got it. Based on your training history and recovery data, I suggest focusing on progressive overload this week. Ask me about legs, recovery, nutrition, or request a full workout plan.';
  }

  static const voiceSamples = [
    'What should I train today?',
    'How is my recovery looking?',
    'Generate a leg day workout for me.',
  ];

  WorkoutCardData generateFullWorkout() {
    return WorkoutCardData(
      id: 'ai-generated-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Plyometric-Power Cluster',
      description:
          'AI-generated session targeting explosive power with controlled fatigue management.',
      duration: '55 min',
      durationMinutes: 55,
      intensity: 'High',
      tag: 'AI Generated • Power',
      tagColor: 'primary',
      category: 'mass',
      imagePath: AssetPaths.powerLift,
      usePlayButton: true,
      exercises: const [
        WorkoutExercise(name: 'Box Jumps (Reactive)', setsReps: '4 Sets x 6 Reps', icon: Icons.auto_mode),
        WorkoutExercise(name: 'Goblet Squats (Explosive)', setsReps: '3 Sets x 8 Reps'),
        WorkoutExercise(name: 'Broad Jumps', setsReps: '3 Sets x 5 Reps', icon: Icons.directions_run),
        WorkoutExercise(name: 'Med Ball Slams', setsReps: '4 Sets x 10 Reps'),
      ],
    );
  }
}
