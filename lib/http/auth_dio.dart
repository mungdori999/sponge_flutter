import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sponge_app/http/response_http_status.dart';
import 'package:sponge_app/http/token_dio.dart';
import 'package:sponge_app/http/url.dart';
import 'package:sponge_app/token/jwt_token.dart';

Future<Dio> authDio() async {
  var dio = Dio();

  final storage = new FlutterSecureStorage();

  dio.interceptors.clear();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 기기에 저장된 AccessToken 로드
        final accessToken = await storage.read(key: JwtToken.accessToken.key);

        // 매 요청마다 헤더에 AccessToken을 포함
        options.headers['Authorization'] = accessToken;
        return handler.next(options);
      },
      onError: (error, handler) async {
        print(error);
        if (error.response?.data != null) {
          final responseData = error.response?.data;

          //  액세스토큰이 만료되었다면
          if (responseData['resCode'] == ResponseHttpStatus.EXPIRE_ACCESS_TOKEN.code) {
            final refreshToken = await storage.read(key: JwtToken.refreshToken.key);

            if (refreshToken == null) {}
            // 새로운 액세스 토큰 요청
            var _tokenDio = await tokenDio();
            final url = Uri(
              scheme: scheme,
              host: host,
              port: port,
              path: '${path}/auth/reissue',
            ).toString();

            final refreshResponse = await _tokenDio.post(
              url,
              data: {JwtToken.refreshToken.key: refreshToken},
            );
            if (refreshResponse.statusCode == 200) {
              final newAccessToken = refreshResponse.headers.value('authorization');
              final responseBody = refreshResponse.data;
              final newRefreshToken = responseBody[JwtToken.refreshToken.key];
              // 새 토큰 저장
              await storage.write(key: JwtToken.accessToken.key, value: newAccessToken);
              await storage.write(key: JwtToken.refreshToken.key, value: newRefreshToken);

              // 실패했던 요청을 새 액세스 토큰으로 재시도
              final options = error.requestOptions;
              options.headers['Authorization'] = newAccessToken;

              // 기존 Dio 인스턴스를 사용해 재요청
              final retryResponse = await dio.fetch(options);
              return handler.resolve(retryResponse);
            }
          }
        }
        // 다른 에러는 기본 처리
        return handler.next(error);
      },
    ),
  );
  return dio;
}
