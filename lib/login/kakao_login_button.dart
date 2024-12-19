import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/http/auth_response.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';
import 'package:sponge_app/screen/trainer/craete/trainer_register.dart';
import 'package:sponge_app/token/jwt_token.dart';

class KakaoLoginButton extends StatelessWidget {
  final String loginType;

  const KakaoLoginButton({super.key, required this.loginType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            AuthResponse authResponse =await kakaoLogin(loginType); // 로그인 작업 완료까지 기다린 후
            //로그인에 성공했다면
            if(authResponse.login) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/', // 홈 화면의 route 이름
                    (Route<dynamic> route) => false, // 모든 기존 화면을 제거하고 홈 화면만 남기기
              );
            }
            //훈련사로 처음 로그인이라면
            else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainerRegister(authResponse: authResponse,),
                ),
              );
            }

          },
          icon: Image.asset(
            'asset/img/kakao_logo.png',
            width: 30,
          ),
          label: Text(
            '카카오 로그인',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFE812), // Kakao 버튼 색상
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Future<AuthResponse> kakaoLogin(String loginType) async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    AuthResponse authResponse = new AuthResponse();
    if (await isKakaoTalkInstalled()) {
      print("카카오톡 있음");
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        authResponse = await _authToServer(token, loginType);
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return authResponse;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          authResponse = await _authToServer(token, loginType);
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      print("카카오톡 없음");
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
         authResponse = await _authToServer(token, loginType);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
    return authResponse;
  }

  Future<AuthResponse> _authToServer(OAuthToken token, String loginType) async {
    final dio = Dio();
    final secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: JwtToken.accessToken.key);
    await secureStorage.delete(key: JwtToken.refreshToken.key);
    // 견주로 로그인일시
    if (loginType == LoginType.USER.value) {
      final url = Uri(
        scheme: scheme,
        host: host,
        port: port,
        path: '${path}/auth/kakao/user',
      ).toString();
      final response = await dio.post(
        url,
        data: {
          JwtToken.accessToken.key: token.accessToken,
          'loginType': loginType,
        },
      );

      if (response.statusCode == ok) {
        print('서버로 전송 성공');
        final accessToken = response.headers.value('authorization');
        // Body에서 refreshToken 추출 및 저장
        final responseBody = response.data; // JSON 파싱
        final refreshToken = responseBody[JwtToken.refreshToken.key];

        // JWT 토큰 저장
        await secureStorage.write(
            key: JwtToken.accessToken.key, value: accessToken);
        await secureStorage.write(
            key: JwtToken.refreshToken.key, value: refreshToken);
      } else {
        print('서버 전송 실패: ${response.data}');
      }
    }
    // 훈련사로 로그인
    if (loginType == LoginType.TRAINER.value) {
      final url = Uri(
        scheme: scheme,
        host: host,
        port: port,
        path: '${path}/auth/kakao/trainer',
      ).toString();
      final response = await dio.post(
        url,
        data: {
          JwtToken.accessToken.key: token.accessToken,
          'loginType': loginType,
        },
      );
      if (response.statusCode == ok) {
        print('서버로 전송 성공');
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
        } else {
          final name = responseBody['name'];
          final email = responseBody['email'];
          return AuthResponse(email: email, name: name, login: false);
        }
      } else {
        print('서버 전송 실패: ${response.data}');
      }
    }
    return AuthResponse();
  }
}
