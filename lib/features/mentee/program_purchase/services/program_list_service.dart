import 'package:dio/dio.dart';
import '../models/program_list_model.dart';

class ProgramListService {
  final Dio _dio;

  ProgramListService(this._dio);

  Future<List<Program>> getPrograms() async {
    try {
      // Replace with your actual API endpoint
      // final response = await _dio.get('/api/programs');
      
      // Sample data for now - replace with actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      final sampleData = [
        {
          'id': '1',
          'title': 'EPC Core Foundation',
          'description': 'Master the fundamentals of Engineering, Procurement & Construction with comprehensive modules covering industry best practices.',
          'weeks': 16,
          'learners': 1240,
          'rating': 4.9,
          'tag': 'Enrolled',
          'isEnrolled': true,
        },
        {
          'id': '2',
          'title': 'Advanced Engineering Practice',
          'description': 'Deep dive into advanced engineering methodologies, project management and cutting-edge technologies.',
          'weeks': 12,
          'learners': 860,
          'rating': 4.6,
          'price': '₹4,999',
          'tag': 'Popular',
          'isEnrolled': false,
        },
        {
          'id': '3',
          'title': 'Digital Transformation in Engineering',
          'description': 'Learn how digital technologies are revolutionizing the engineering industry and project delivery.',
          'weeks': 8,
          'learners': 520,
          'rating': 4.8,
          'price': '₹3,499',
          'tag': 'New',
          'isEnrolled': false,
        },
      ];

      return sampleData.map((json) => Program.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load programs: $e');
    }
  }

  Future<ProgramStats> getProgramStats() async {
    try {
      // Replace with your actual API endpoint
      // final response = await _dio.get('/api/program-stats');
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      final statsData = {
        'totalPrograms': 3,
        'activeLearners': '5,500+',
        'avgRating': 4.7,
      };

      return ProgramStats.fromJson(statsData);
    } catch (e) {
      throw Exception('Failed to load program stats: $e');
    }
  }
}