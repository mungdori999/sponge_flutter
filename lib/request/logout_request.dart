import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';
import 'package:sponge_app/token/jwt_token.dart';

Future<void> logout() async {
  var _dio = await authDio();
  final storage = new FlutterSecureStorage();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/logout',
  ).toString();
  try {
    // GET 요청 보내기
    final refreshToken = await storage.read(key: JwtToken.refreshToken.key);
    final response = await _dio.post(
      url,
      data: {JwtToken.refreshToken.key: refreshToken},
    );
    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      await storage.delete(key: JwtToken.accessToken.key);
      await storage.delete(key: JwtToken.refreshToken.key);
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
