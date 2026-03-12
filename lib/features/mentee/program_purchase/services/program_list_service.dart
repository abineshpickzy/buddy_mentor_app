import 'package:dio/dio.dart';
import '../models/program_list_model.dart';
import '../../../../core/network/api_endpoints.dart';

class ProgramListService {
  final Dio _dio;

  ProgramListService(this._dio);

  Future<List<Program>> getPrograms() async {
    try {
      final response = await _dio.get(ApiEndpoints.programListNew);
      
      if (response.data['success'] == true) {
        final List<dynamic> programsData = response.data['programs'] ?? [];
        return programsData.map((json) => Program.fromJson(json)).toList();
      } else {
        throw Exception('API returned success: false');
      }
    } catch (e) {
      throw Exception('Failed to load programs: $e');
    }
  }

  Future<ProgramStats> getProgramStats() async {
    try {
      // This endpoint might not exist yet, so using static data
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