class AppSettings {
  const AppSettings({
    this.notificationsEnabled = true,
    this.useMetricUnits = true,
  });

  final bool notificationsEnabled;
  final bool useMetricUnits;

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? useMetricUnits,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      useMetricUnits: useMetricUnits ?? this.useMetricUnits,
    );
  }
}
