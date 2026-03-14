import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddymentor/features/auth/data/models/auth_models.dart';
import 'package:buddymentor/features/auth/data/services/storage_service.dart';
import 'package:buddymentor/features/auth/data/services/auth_service.dart';

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  // Initialize auth state from storage
  Future<void> initializeAuth() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final user = await StorageService.getUser();
      final tokens = await StorageService.getTokens();
      
      print('🔄 Loading from storage: ID=${user?.id}, Type=${user?.userType}, UUID=${user?.uuid}');
      
      if (user != null && tokens != null) {
        state = state.copyWith(
          user: user,
          tokens: tokens,
          isAuthenticated: true,
          isLoading: false,
        );
        
        // Fetch full user data
        await fetchFullUserData();
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // Login/Signup success - save auth data
  Future<void> setAuthData(Map<String, dynamic> responseData) async {
    try {
      final userProfile = responseData['data']['user_profile'];
      print('💾 Saving user profile: ID=${userProfile['_id']}, Type=${userProfile['user_type']}, UUID=${userProfile['uuid']}');
      
      final user = AuthUser.fromMap(userProfile);
      final tokens = AuthTokens.fromMap(responseData['data']);
      
      // Save minimal user data to storage
      await StorageService.saveUser(user);
      await StorageService.saveTokens(tokens);
      
      print('✅ User saved to storage: ID=${user.id}, Type=${user.userType}, UUID=${user.uuid}');
      
      // Update state with minimal user data
      state = state.copyWith(
        user: user,
        tokens: tokens,
        isAuthenticated: true,
        isLoading: false,
      );
      
      // Fetch and store full user data
      await fetchFullUserData();
    } catch (e) {
      print('Error setting auth data: $e');
    }
  }

  // Fetch full user data by ID
  Future<void> fetchFullUserData() async {
    try {
      if (state.user?.id != null) {
        final response = await AuthService.getUserById(state.user!.id);
        if (response.statusCode == 200) {
          state = state.copyWith(
            fullUserData: response.data['data'],
          );
        }
      }
    } catch (e) {
      print('Error fetching full user data: $e');
      // Don't retry automatically, just log the error
    }
  }

  // Logout
  Future<void> logout() async {
    await StorageService.clearAuthData();
    state = AuthState();
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) return false;
      
      final response = await AuthService.refreshToken({'refresh_token': refreshToken});
      
      if (response.statusCode == 200) {
        final tokens = AuthTokens.fromMap(response.data['data']);
        await StorageService.saveTokens(tokens);
        
        state = state.copyWith(tokens: tokens);
        return true;
      }
      return false;
    } catch (e) {
      print('Refresh token error: $e');
      return false;
    }
  }

  // Get current access token
  String? get accessToken => state.tokens?.accessToken;
  
  // Check if user is authenticated
  bool get isAuthenticated => state.isAuthenticated;

  //get user profile
  AuthUser? get user => state.user;
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);