enum JwtToken {
  accessToken("accessToken"),
  refreshToken("refreshToken");

  final String key;

  const JwtToken(this.key);
}
