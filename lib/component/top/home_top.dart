import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/top_login_component.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/screen/login_screen.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class HomeTop extends StatelessWidget {
  JwtUtil jwtUtil = new JwtUtil();
  late LoginAuth loginAuth;

  HomeTop({super.key});

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
              Image.asset(
                'asset/img/logo.png',
                width: 150,
              ),
              TopLoginComponent(loginAuth: loginAuth),
            ],
          );
        });
  }
}
