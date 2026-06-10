import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({SettingsService? service})
      : _service = service ?? SettingsService();

  final SettingsService _service;
  AppSettings _settings = const AppSettings();
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  AppSettings get settings => _settings;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  bool get useMetricUnits => _settings.useMetricUnits;

  Future<void> init() async {
    _settings = await _service.load();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _settings = _settings.copyWith(notificationsEnabled: value);
    await _service.save(_settings);
    notifyListeners();
  }

  Future<void> setUseMetricUnits(bool value) async {
    _settings = _settings.copyWith(useMetricUnits: value);
    await _service.save(_settings);
    notifyListeners();
  }
}
