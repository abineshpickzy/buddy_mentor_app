import 'package:dio/dio.dart';
import '../models/program_overview_model.dart';
import '../../../../core/network/api_endpoints.dart';

class ProgramOverviewService {
  final Dio _dio;

  ProgramOverviewService(this._dio);

  Future<ProgramOverview> fetchtrialProgram(String productId) async {
    try {
      final trialProgramEndpoint = "prgm/$productId/trial";
    
      final response = await _dio.get(trialProgramEndpoint);
      
      if (response.data['success'] == true) {
        return ProgramOverview.fromJson(response.data);
      } else {
        throw Exception('API returned success: false - ${response.data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Failed to fetch program: $e');
    }
  }

   Future<ProgramOverview> fetchProgram(String productId,int type) async {
    try {
      final enrolledProgramEndpoint = "prgm/$type/$productId/ovw";

      final response = await _dio.get(enrolledProgramEndpoint);
      
      if (response.data['success'] == true) {
        return ProgramOverview.fromJson(response.data);
      } else {
        throw Exception('API returned success: false - ${response.data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Failed to fetch program: $e');
    }
  }

  // TODO: Implement when API is ready
  Future<bool> markSessionComplete(String sessionId) async {
    // Placeholder for future API call
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<bool> enrollProgram(String programId,productId,productType) async {
    try {
      final response = await _dio.post(
        'prgm/enroll',
        data: {'program_id': programId,
        "product_id" : productId,
         'type': productType
        
        },
      );
      
      if (response.data['success'] == true) {
        return true;
      } else {
        throw Exception('Enrollment failed: ${response.data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Failed to enroll in program: $e');
    }
  }
}