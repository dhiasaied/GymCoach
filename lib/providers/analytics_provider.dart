import 'package:flutter/foundation.dart';

import '../services/analytics_service.dart';

class AnalyticsProvider extends ChangeNotifier {
  AnalyticsProvider({AnalyticsService? service})
      : _service = service ?? AnalyticsService();

  final AnalyticsService _service;

  int _periodIndex = 0;

  int get periodIndex => _periodIndex;

  AnalyticsPeriodData get currentData => _service.dataForPeriod(_periodIndex);

  void setPeriodIndex(int index) {
    _periodIndex = index;
    notifyListeners();
  }
}
