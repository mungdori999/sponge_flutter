import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/token/jwt_token.dart';

class JwtUtil {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<LoginAuth> getJwtToken() async {
    // secure storage에서 JWT 토큰 읽기
    String? accessToken = await _storage.read(key: JwtToken.accessToken.key);
    print(accessToken);
    String? refreshToken = await _storage.read(key: JwtToken.refreshToken.key);
    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      // 토큰이 없거나 비어 있는 경우 기본값 반환
      return LoginAuth(id: 0, name: '', loginType: '', exp: 0);
    }

    final refreshPayload = _decodePayload(refreshToken);
    // JSON 문자열을 Map으로 변환
    final Map<String, dynamic> refreshPayloadMap = jsonDecode(refreshPayload);
    final int? exp = refreshPayloadMap['exp'] as int?;

    if (exp == null) {
      return LoginAuth(id: 0, name: '', loginType: '', exp: 0);
    }
    // 현재 시간과 비교
    final DateTime expirationDate =
        DateTime.fromMillisecondsSinceEpoch(exp * 1000); // 초 → 밀리초 변환
    if (expirationDate.isBefore(_getCurrentTime())) {
      await _storage.delete(key: JwtToken.accessToken.key);
      await _storage.delete(key: JwtToken.refreshToken.key);
      return LoginAuth(id: 0, name: '', loginType: '', exp: 0);
    }

    try {
      // JWT의 페이로드 디코딩
      final payload = _decodePayload(accessToken);
      // JSON 문자열을 Map으로 변환
      final Map<String, dynamic> payloadMap = jsonDecode(payload);

      // UserAuth 객체 생성 및 반환
      return LoginAuth.fromJson(payloadMap);
    } catch (e) {
      print('JWT 디코딩 실패: $e');
      // 오류 발생 시 기본값 반환
      return LoginAuth(id: 0, name: '', loginType: '', exp: 0);
    }
  }

  /// JWT의 페이로드를 디코딩합니다.
  String _decodePayload(String jwtToken) {
    // JWT는 .으로 구분된 3개의 파트로 구성됨
    final parts = jwtToken.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid JWT structure');
    }

    // 페이로드 부분 (두 번째 파트)만 디코딩
    final payload = parts[1];

    // Base64 URL 포맷을 표준 Base64로 변환 후 디코딩
    return utf8.decode(base64Url.decode(_normalizeBase64Url(payload)));
  }

  /// Base64 URL 문자열을 표준 Base64 문자열로 정규화합니다.
  String _normalizeBase64Url(String input) {
    String output = input.replaceAll('-', '+').replaceAll('_', '/');
    while (output.length % 4 != 0) {
      output += '=';
    }
    return output;
  }

  DateTime _getCurrentTime() {
    return DateTime.now(); // 현재 시간을 가져옴
  }
}
