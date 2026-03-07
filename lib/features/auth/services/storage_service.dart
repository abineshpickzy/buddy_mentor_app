import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';

class StorageService {
  static const _secureStorage = FlutterSecureStorage();
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  // Save tokens securely
  static Future<void> saveTokens(AuthTokens tokens) async {
    await _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  // Get tokens
  static Future<AuthTokens?> getTokens() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    
    if (accessToken != null && refreshToken != null) {
      return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
    }
    return null;
  }

  // Save user data
  static Future<void> saveUser(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toMap()));
  }

  // Get user data
  static Future<AuthUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    
    if (userData != null) {
      return AuthUser.fromMap(jsonDecode(userData));
    }
    return null;
  }

  // Clear all auth data
  static Future<void> clearAuthData() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Get access token only
  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  // Get refresh token only
  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }
}