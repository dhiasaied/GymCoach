class AnalyticsPeriodData {
  const AnalyticsPeriodData({
    required this.label,
    required this.muscleBars,
    required this.weightValue,
    required this.weightChange,
    required this.records,
    required this.distributionBars,
  });

  final String label;
  final List<double> muscleBars;
  final String weightValue;
  final String weightChange;
  final List<(String, String)> records;
  final List<double> distributionBars;
}

class AnalyticsService {
  static const periods = ['7 Days', '30 Days', '6 Months'];

  AnalyticsPeriodData dataForPeriod(int index) {
    switch (index) {
      case 1:
        return const AnalyticsPeriodData(
          label: '30 Days',
          muscleBars: [0.55, 0.5, 0.78, 0.68, 0.48, 0.72],
          weightValue: '83.6',
          weightChange: '-3.1kg this month',
          records: [
            ('Deadlift', '182 kg'),
            ('Bench Press', '127 kg'),
            ('Squat', '158 kg'),
          ],
          distributionBars: [0.35, 0.55, 0.72, 0.48, 0.88, 0.4, 0.62],
        );
      case 2:
        return const AnalyticsPeriodData(
          label: '6 Months',
          muscleBars: [0.72, 0.58, 0.95, 0.82, 0.65, 0.88],
          weightValue: '81.4',
          weightChange: '-5.8kg over 6 months',
          records: [
            ('Deadlift', '190 kg'),
            ('Bench Press', '132 kg'),
            ('Squat', '165 kg'),
          ],
          distributionBars: [0.5, 0.62, 0.78, 0.55, 0.92, 0.48, 0.75],
        );
      default:
        return const AnalyticsPeriodData(
          label: '7 Days',
          muscleBars: [0.65, 0.45, 0.9, 0.75, 0.55, 0.85],
          weightValue: '84.2',
          weightChange: '-2.4kg this month',
          records: [
            ('Deadlift', '180 kg'),
            ('Bench Press', '125 kg'),
            ('Squat', '155 kg'),
          ],
          distributionBars: [0.4, 0.65, 0.85, 0.55, 0.95, 0.45, 0.7],
        );
    }
  }
}
