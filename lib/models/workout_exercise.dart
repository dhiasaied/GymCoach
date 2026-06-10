import 'package:flutter/material.dart';

class WorkoutExercise {
  const WorkoutExercise({
    required this.name,
    required this.setsReps,
    this.icon = Icons.fitness_center,
  });

  final String name;
  final String setsReps;
  final IconData icon;
}
