class LoginAuth {
  final int _id;
  final String _name;
  final String _loginType;
  final int _exp;

  LoginAuth({
    required int id,
    required String name,
    required String loginType,
    required int exp,
  })  : _id = id,
        _name = name,
        _loginType = loginType,
        _exp = exp;

  // 게터 추가
  int get id => _id;
  String get name => _name;
  String get loginType => _loginType;
  int get exp => _exp;

  // JSON 데이터를 받아 UserAuth 객체로 변환하는 팩토리 메서드
  factory LoginAuth.fromJson(Map<String, dynamic> json) {
    return LoginAuth(
      id: json['id'],
      name: json['name'],
      loginType: json['loginType'],
      exp: json['exp'],
    );
  }

  // 객체를 JSON 형태로 변환하는 메서드 (선택적)
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'loginType': _loginType,
      'exp': _exp,
    };
  }
}
