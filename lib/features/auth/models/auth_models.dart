class AuthUser {
  final String id;
  final int userType;

  AuthUser({
    required this.id,
    required this.userType,
  });

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      id: map['_id'] ?? '',
      userType: map['user_type'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_type': userType,
    };
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokens.fromMap(Map<String, dynamic> map) {
    return AuthTokens(
      accessToken: map['auth_token']['token'] ?? '',
      refreshToken: map['refresh']['token'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}

class AuthState {
  final AuthUser? user;
  final AuthTokens? tokens;
  final Map<String, dynamic>? fullUserData;
  final bool isAuthenticated;
  final bool isLoading;

  AuthState({
    this.user,
    this.tokens,
    this.fullUserData,
    this.isAuthenticated = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthUser? user,
    AuthTokens? tokens,
    Map<String, dynamic>? fullUserData,
    bool? isAuthenticated,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      fullUserData: fullUserData ?? this.fullUserData,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}