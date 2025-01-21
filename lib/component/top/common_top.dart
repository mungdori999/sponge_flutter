import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/top_login_component.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/screen/login_screen.dart';
import 'package:sponge_app/screen/search_screen.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class CommonTop extends StatelessWidget {
  JwtUtil jwtUtil = new JwtUtil();
  late LoginAuth loginAuth;

  CommonTop({super.key});

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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '내 진단',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  },
                  icon: Icon(Icons.search)),
              TopLoginComponent(loginAuth: loginAuth),
            ],
          );
        });
  }
}
