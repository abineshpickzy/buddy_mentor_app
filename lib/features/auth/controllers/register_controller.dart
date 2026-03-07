import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../services/auth_service.dart';
import 'auth_controller.dart';

class RegisterController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
      // Any initialization if needed
  }

  String _md5Hash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<String?> verifySignup(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final response = await AuthService.signupVerify(data);
      state = const AsyncData(null);
      print('Verification response: ${response.data}');
      return null; // Success
    } catch (error) {
      if (error.toString().contains('DioException')) {
        try {
          final dioError = error as dynamic;
          if (dioError.response != null) {
            final errorMessage = dioError.response.data['message'] ?? 'Verification failed';
            state = AsyncError(error, StackTrace.current);
            return errorMessage;
          }
        } catch (e) {
          // Error parsing response
        }
      }
      state = AsyncError(error, StackTrace.current);
      return 'Verification failed. Please try again.';
    }
  }

  Future<String?> signup(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      // Encrypt password with MD5 if it exists
      if (data['password'] != null) {
        data['password'] = _md5Hash(data['password']);
      }
      final response = await AuthService.signup(data);
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        // Save auth data using auth controller
        ref.read(authControllerProvider.notifier).setAuthData(response.data);
        state = const AsyncData(null);
        return null; // Success
      } else {
        final errorMessage = response.data['message'] ?? 'Signup failed';
        state = const AsyncData(null);
        return errorMessage;
      }
    } catch (error) {
      if (error.toString().contains('DioException')) {
        try {
          final dioError = error as dynamic;
          if (dioError.response != null) {
            final errorMessage = dioError.response.data['message'] ?? 'Signup failed';
            state = AsyncError(error, StackTrace.current);
            return errorMessage;
          }
        } catch (e) {
          // Error parsing response
        }
      }
      state = AsyncError(error, StackTrace.current);
      return 'Signup failed. Please try again.';
    }
  }
}

final RegisterControllerProvider = AsyncNotifierProvider<RegisterController, void>(
  RegisterController.new,
);