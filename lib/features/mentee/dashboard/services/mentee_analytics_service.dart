// import 'package:buddymentor/core/network/api_endpoints.dart';
// import 'package:buddymentor/core/network/dio_client.dart';
// import 'package:dio/dio.dart';

class MenteeAnalyticsService {
  static Future<Map<String, dynamic>> fetchAnalytics() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return static data for testing
    return {
      'success': true,
      'data': {
        'completed_weeks': 2,
        'in_progress_weeks': 1,
        'remaining_weeks': 13,
        'weekly_progress': {
          'Week 1': 100.0,
          'Week 2': 75.0,
          'Week 3': 0.0,
        },
        'time_spent': {
          'today': '2h 30m',
          'this_week': '8h 45m',
          'total': '25h 15m',
        },
      },
    };
  }
}