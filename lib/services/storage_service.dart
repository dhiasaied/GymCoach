import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class StorageService {
  static const _loggedInKey = 'gymcoach_logged_in';
  static const _onboardingSeenKey = 'gymcoach_onboarding_seen';
  static const _profileKey = 'gymcoach_profile';
  static const _usersKey = 'gymcoach_users';
  static const _activitiesKey = 'gymcoach_activities';
  static const _customWorkoutsKey = 'gymcoach_custom_workouts';
  static const _weeklySessionsKey = 'gymcoach_weekly_sessions';
  static const _weeklyGoalKey = 'gymcoach_weekly_goal';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  Future<void> setOnboardingSeen(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, value);
  }

  Future<UserProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return UserProfile(
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      weight: (map['weight'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
    );
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _profileKey,
      jsonEncode({
        'fullName': profile.fullName,
        'email': profile.email,
        'weight': profile.weight,
        'height': profile.height,
      }),
    );
  }

  Future<Map<String, String>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, value as String));
  }

  Future<void> saveUsers(Map<String, String> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<List<Map<String, dynamic>>> loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_activitiesKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<void> saveActivities(List<Map<String, dynamic>> activities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activitiesKey, jsonEncode(activities));
  }

  Future<List<Map<String, dynamic>>> loadCustomWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_customWorkoutsKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<void> saveCustomWorkouts(List<Map<String, dynamic>> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customWorkoutsKey, jsonEncode(workouts));
  }

  Future<int> loadWeeklySessions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_weeklySessionsKey) ?? 0;
  }

  Future<void> saveWeeklySessions(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_weeklySessionsKey, count);
  }

  Future<int> loadWeeklyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_weeklyGoalKey) ?? 4;
  }

  Future<void> saveWeeklyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_weeklyGoalKey, goal);
  }
}
