class AuthState {

 final String? token;
 final AuthUser? user;
  
  AuthState({this.token, required this.user});

  AuthState copyWith({String? token, AuthUser? user}) {
    return AuthState(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
} 


class AuthUser {
  final String? id;
  final String? email;
  final String? role;

  AuthUser({this.id, this.email, this.role});

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
    );
  }
  
}

