import 'package:buddymentor/core/network/api_endpoints.dart';
import 'package:buddymentor/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class AuthService {
   static Future<Response> signupVerify(Map<String, dynamic> data) async {
    try {
      
      final response = await DioClient.dio.post(
        ApiEndpoints.signupVerify,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
}

    static Future<Response> signup(Map<String, dynamic> data) async {
      try {
        final response = await DioClient.dio.post(
          ApiEndpoints.signup,
          data: data,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    static Future<Response> passwordLogin(Map<String, dynamic> data) async {
      print('Attempting login with data: $data');
      try {
        final response = await DioClient.dio.post(
          ApiEndpoints.passwordLogin,
          data: data,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    static Future<Response> refreshToken(Map<String, dynamic> data) async {
      try {
        final response = await DioClient.dio.post(
          ApiEndpoints.refreshToken,
          data: data,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    static Future<Response> requestOtp(Map<String, dynamic> data) async {
      try {
        final response = await DioClient.dio.post(
          ApiEndpoints.requestOtp,
          data: data,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    static Future<Response> verifyResetOtp(Map<String, dynamic> data) async {
      try {
        final response = await DioClient.dio.post(
          ApiEndpoints.verifyResetOtp,
          data: data,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    static Future<Response> resetPassword(Map<String, dynamic> data) async {
      try {
        final response = await DioClient.dio.post(
          ApiEndpoints.resetPassword,
          data: data,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    static Future<Response> getDisciplineList() async {
      try {
        final response = await DioClient.dio.get(
          ApiEndpoints.disciplineList,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    static Future<Response> getCountryList() async {
      try {
        final response = await DioClient.dio.get(
          ApiEndpoints.countryList,
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }

    static Future<Response> getUserById(String userId) async {
      try {
        final response = await DioClient.dio.get(
          'auth/$userId/vw',
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }
}

