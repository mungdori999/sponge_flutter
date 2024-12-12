import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sponge_app/http/response_http_status.dart';
import 'package:sponge_app/token/jwt_token.dart';

Future<Dio> tokenDio() async {
  var dio = Dio();
  final _storage = new FlutterSecureStorage();

  dio.interceptors.clear();
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.data != null) {
          final responseData = error.response?.data;
          if (responseData['resCode'] ==
              ResponseHttpStatus.EXPIRE_REFRESH_TOKEN.code) {
            await _storage.delete(key: JwtToken.accessToken.key);
            await _storage.delete(key: JwtToken.refreshToken.key);
          }
        }
        return handler.next(error);
      },
    ),
  );
  return dio;
}
