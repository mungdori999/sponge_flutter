import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sponge_app/data/trainer/trainer.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';
import 'package:sponge_app/token/jwt_token.dart';

Future<Trainer> getMyInfo() async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/trainer/my_info',
  ).toString();
  try {
    // GET 요청 보내기
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final dynamic data = response.data; // Dio에서 응답 데이터는 바로 data로 접근 가능
      return Trainer.fromJson(data); // 받은 데이터를 User 객체로 변환
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
Future<void> createTrainer(TrainerCreate trainerCreate) async {
  final _dio = Dio();
  final secureStorage = FlutterSecureStorage();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/trainer',
  ).toString();

  try {
    final response = await _dio.post(url, data: trainerCreate.toJson());

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final responseBody = response.data;
      if (responseBody['login']) {
        final accessToken = response.headers.value('authorization');
        // Body에서 refreshToken 추출 및 저장
        final refreshToken = responseBody[JwtToken.refreshToken.key];
        // JWT 토큰 저장
        await secureStorage.write(
            key: JwtToken.accessToken.key, value: accessToken);
        await secureStorage.write(
            key: JwtToken.refreshToken.key, value: refreshToken);
      }
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
