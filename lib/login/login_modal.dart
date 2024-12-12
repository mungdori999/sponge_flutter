import 'package:flutter/material.dart';
import 'package:sponge_app/login/kakao_login_button.dart';

class LoginModal extends StatelessWidget {
  final String loginType;
  const LoginModal({super.key, required this.loginType});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.4,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              '로그인',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            KakaoLoginButton(loginType: loginType,), // Kakao 로그인 버튼 (아래에서 정의)
          ],
        ),
      ),
    );

  }

}
