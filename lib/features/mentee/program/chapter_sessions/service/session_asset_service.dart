import 'package:dio/dio.dart';
import '../models/session_asset_model.dart';

class SessionAssetService {
  final Dio _dio;

  SessionAssetService(this._dio);

  /// [programType] – the program type from program overview model
  /// [sessionId] – the session/node ID
  Future<SessionContentResponse> fetchSessionContent({
    required int programType,
    required String sessionId,
  }) async {
    try {
      final response = await _dio.get('prgm/$programType/$sessionId/ast');

      if (response.statusCode == 200) {
        return SessionContentResponse.fromJson(
            response.data as Map<String, dynamic>);
      }

      throw Exception(
          'Failed to fetch session content: ${response.statusCode}');
    } on DioException catch (e) {
      // ✅ 404 = "Content not found" — return empty, no retry triggered
      if (e.response?.statusCode == 404) {
        return SessionContentResponse.empty();
      }
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch session content: $e');
    }
  }
}