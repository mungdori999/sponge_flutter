import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/top_login_component.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class ChatRoomTop extends StatelessWidget {
  JwtUtil jwtUtil = new JwtUtil();
  late LoginAuth loginAuth;

  ChatRoomTop({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginAuth>(
        future: jwtUtil.getJwtToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(); // 데이터 로딩 중
          }
          if (snapshot.hasError) {
            return Text('오류 발생: ${snapshot.error}');
          }
          loginAuth = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "내 채팅 상담",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TopLoginComponent(loginAuth: loginAuth),
            ],
          );
        });
  }
}
