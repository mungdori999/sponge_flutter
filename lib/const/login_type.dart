
enum LoginType{
  TRAINER("trainer"), USER("user");

  final String loginType;

  const LoginType(this.loginType);

  String get value => loginType;

}