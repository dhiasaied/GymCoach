import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

class SettingsService {
  static const _notificationsKey = 'gymcoach_notifications_enabled';
  static const _metricUnitsKey = 'gymcoach_use_metric_units';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
      useMetricUnits: prefs.getBool(_metricUnitsKey) ?? true,
    );
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, settings.notificationsEnabled);
    await prefs.setBool(_metricUnitsKey, settings.useMetricUnits);
  }
}
