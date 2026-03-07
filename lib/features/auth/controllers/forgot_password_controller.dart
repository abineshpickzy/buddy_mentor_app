import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:buddymentor/features/auth/data/services/auth_service.dart';

class ForgotPasswordController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  String _md5Hash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<String?> requestOtp(String email) async {
    state = const AsyncValue.loading();
    try {
      await AuthService.requestOtp({'email': email});
      state = const AsyncValue.data(null);
      return null; // Success
    } catch (error) {
      if (error.toString().contains('DioException')) {
        try {
          final dioError = error as dynamic;
          if (dioError.response != null) {
            final errorMessage = dioError.response.data['message'] ?? 'Failed to send OTP';
            state = AsyncValue.error(error, StackTrace.current);
            return errorMessage;
          }
        } catch (e) {
          // Error parsing response
        }
      }
      state = AsyncValue.error(error, StackTrace.current);
      return 'Failed to send OTP. Please try again.';
    }
  }

  Future<String?> verifyResetOtp(String email, String otp) async {
    state = const AsyncValue.loading();
    try {
      await AuthService.verifyResetOtp({
        'email': email,
        'otp': int.parse(otp),
      });
      state = const AsyncValue.data(null);
      return null; // Success
    } catch (error) {
      if (error.toString().contains('DioException')) {
        try {
          final dioError = error as dynamic;
          if (dioError.response != null) {
            final errorMessage = dioError.response.data['message'] ?? 'Invalid OTP';
            state = AsyncValue.error(error, StackTrace.current);
            return errorMessage;
          }
        } catch (e) {
          // Error parsing response
        }
      }
      state = AsyncValue.error(error, StackTrace.current);
      return 'Invalid OTP. Please try again.';
    }
  }

  Future<String?> resetPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final hashedPassword = _md5Hash(password);
      await AuthService.resetPassword({
        'email': email,
        'password': hashedPassword,
      });
      state = const AsyncValue.data(null);
      return null; // Success
    } catch (error) {
      if (error.toString().contains('DioException')) {
        try {
          final dioError = error as dynamic;
          if (dioError.response != null) {
            final errorMessage = dioError.response.data['message'] ?? 'Failed to reset password';
            state = AsyncValue.error(error, StackTrace.current);
            return errorMessage;
          }
        } catch (e) {
          // Error parsing response
        }
      }
      state = AsyncValue.error(error, StackTrace.current);
      return 'Failed to reset password. Please try again.';
    }
  }
}

final forgotPasswordControllerProvider = NotifierProvider<ForgotPasswordController, AsyncValue<void>>(
  ForgotPasswordController.new,
);