import 'package:buddymentor/core/network/api_endpoints.dart';
import 'package:buddymentor/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class MenteeProgramService {
  static Future<Response> fetchProgramOverview(ProductId) async {
    try {
      final response = await DioClient.dio.get(
        'prgm/${ProductId}/trial');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
