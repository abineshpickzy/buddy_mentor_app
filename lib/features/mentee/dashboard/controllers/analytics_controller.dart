import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddymentor/features/mentee/dashboard/services/mentee_analytics_service.dart';

class AnalyticsData {
  final int completedWeeks;
  final int inProgressWeeks;
  final int remainingWeeks;
  final Map<String, double> weeklyProgress;
  final Map<String, String> timeSpent;

  AnalyticsData({
    required this.completedWeeks,
    required this.inProgressWeeks,
    required this.remainingWeeks,
    required this.weeklyProgress,
    required this.timeSpent,
  });
}

class AnalyticsNotifier extends AsyncNotifier<AnalyticsData> {
  @override
  Future<AnalyticsData> build() async {
    return fetchAnalytics();
  }

  Future<AnalyticsData> fetchAnalytics() async {
    state = const AsyncValue.loading();
    try {
      final response = await MenteeAnalyticsService.fetchAnalytics();
      final data = response['data'];
      final analyticsData = AnalyticsData(
        completedWeeks: data['completed_weeks'],
        inProgressWeeks: data['in_progress_weeks'],
        remainingWeeks: data['remaining_weeks'],
        weeklyProgress: Map<String, double>.from(data['weekly_progress']),
        timeSpent: Map<String, String>.from(data['time_spent']),
      );
      state = AsyncValue.data(analyticsData);
      return analyticsData;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

final analyticsProvider = AsyncNotifierProvider<AnalyticsNotifier, AnalyticsData>(
  () => AnalyticsNotifier(),
);