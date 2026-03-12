import 'package:dio/dio.dart';
import '../models/program_overview_model.dart';
import '../../../../core/network/api_endpoints.dart';

class ProgramOverviewService {
  final Dio _dio;

  ProgramOverviewService(this._dio);

  Future<ProgramOverview> fetchProgram(String productId) async {
    try {
      final endpoint = "prgm/$productId/trial";
      final response = await _dio.get(endpoint);
      
      if (response.data['success'] == true) {
        return ProgramOverview.fromJson(response.data);
      } else {
        throw Exception('API returned success: false - ${response.data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Failed to fetch program: $e');
    }
  }
}