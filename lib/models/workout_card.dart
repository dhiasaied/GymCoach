import 'workout_exercise.dart';

class WorkoutCardData {
  const WorkoutCardData({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.intensity,
    required this.tag,
    required this.tagColor,
    required this.imagePath,
    required this.category,
    this.isFeatured = false,
    this.usePlayButton = false,
    this.exercises = const [],
    this.durationMinutes = 45,
  });

  final String id;
  final String title;
  final String description;
  final String duration;
  final String intensity;
  final String tag;
  final String tagColor;
  final String imagePath;
  final String category;
  final bool isFeatured;
  final bool usePlayButton;
  final List<WorkoutExercise> exercises;
  final int durationMinutes;

  WorkoutCardData copyWith({
    String? id,
    String? title,
    String? description,
    String? duration,
    String? intensity,
    String? tag,
    String? tagColor,
    String? imagePath,
    String? category,
    bool? isFeatured,
    bool? usePlayButton,
    List<WorkoutExercise>? exercises,
    int? durationMinutes,
  }) {
    return WorkoutCardData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      tag: tag ?? this.tag,
      tagColor: tagColor ?? this.tagColor,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      isFeatured: isFeatured ?? this.isFeatured,
      usePlayButton: usePlayButton ?? this.usePlayButton,
      exercises: exercises ?? this.exercises,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
