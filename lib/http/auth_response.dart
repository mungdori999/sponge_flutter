class AuthResponse {
  String email;
  String name;
  bool login;

  // 생성자 (기본값 제공)
  AuthResponse({
    this.email = '',
    this.name = '',
    this.login = true,
  });
}
