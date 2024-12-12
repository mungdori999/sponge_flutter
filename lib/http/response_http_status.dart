enum ResponseHttpStatus {
  EXPIRE_ACCESS_TOKEN(4000),
  EXPIRE_REFRESH_TOKEN(4100);

  final int code;

  const ResponseHttpStatus(this.code);

  int get value => code;
}
