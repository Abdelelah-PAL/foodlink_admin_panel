class AuthData {
  String id;
  String? username;
  String email;
  String refreshToken;
  String token;

  AuthData({
    required this.id,
    required this.username,
    required this.email,
    required this.refreshToken,
    required this.token,
  });
  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      id: json['uid'],
      username: json['displayName'],
      email: json['email'],
      refreshToken: json['refreshToken'],
      token: json['idToken'],
    );
  }
}
