import 'package:flutter/foundation.dart';

import '../models/activity_record.dart';
import '../models/workout_card.dart';
import '../services/workout_service.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider({WorkoutService? service}) : _service = service ?? WorkoutService();

  final WorkoutService _service;

  List<WorkoutCardData> _allWorkouts = [];
  List<ActivityRecord> _activities = [];
  int _filterIndex = 0;
  int _weeklySessions = 0;
  int _weeklyGoal = 4;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  int get filterIndex => _filterIndex;
  int get weeklySessions => _weeklySessions;
  int get weeklyGoal => _weeklyGoal;
  double get weeklyProgress =>
      _weeklyGoal == 0 ? 0 : (_weeklySessions / _weeklyGoal).clamp(0.0, 1.0);

  List<WorkoutCardData> get filteredWorkouts =>
      _service.filterByCategory(_allWorkouts, _filterIndex);

  List<ActivityRecord> get activities => List.unmodifiable(_activities);

  WorkoutCardData get dailyRecommendation =>
      _service.getDailyRecommendation(_allWorkouts);

  Future<void> init() async {
    _allWorkouts = await _service.loadAllWorkouts();
    _activities = await _service.loadActivities();
    _weeklySessions = await _service.loadWeeklySessions();
    _weeklyGoal = await _service.loadWeeklyGoal();
    _isLoading = false;
    notifyListeners();
  }

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  WorkoutCardData? workoutById(String id) => _service.findById(id, _allWorkouts);

  Future<WorkoutCardData> createCustomWorkout({
    required String title,
    required String description,
    required String duration,
    required int durationMinutes,
    required String intensity,
    required String category,
  }) async {
    final workout = await _service.createCustomWorkout(
      title: title,
      description: description,
      duration: duration,
      durationMinutes: durationMinutes,
      intensity: intensity,
      category: category,
    );
    _allWorkouts = await _service.loadAllWorkouts();
    notifyListeners();
    return workout;
  }

  Future<void> completeSession(WorkoutCardData workout) async {
    final record = await _service.completeSession(workout);
    _activities = [record, ..._activities];
    _weeklySessions = await _service.loadWeeklySessions();
    notifyListeners();
  }

  Future<void> refreshActivities() async {
    _activities = await _service.loadActivities();
    notifyListeners();
  }

  Future<void> setWeeklyGoal(int goal) async {
    _weeklyGoal = goal;
    await _service.saveWeeklyGoal(goal);
    notifyListeners();
  }
}
