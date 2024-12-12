import 'package:flutter/material.dart';
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
              if (loginAuth.id == 0)
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFF8F8F8),
                    foregroundColor: mainGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              if (loginAuth.id != 0)
                Row(
                  children: [
                    Text(
                      loginAuth.name,
                      style: TextStyle(
                          color: mainYellow,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      loginAuth.loginType == LoginType.USER.value ? '님' : '훈련사님',
                      style: TextStyle(
                          color: mainGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                      width: 40, // 동그라미의 너비
                      height: 40, // 동그라미의 높이
                      decoration: BoxDecoration(
                        color: Colors.grey[400], // 회색 배경색
                        shape: BoxShape.circle, // 동그라미 형태
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.person, // 사람 모양 아이콘
                          color: Colors.white, // 아이콘 색상
                          size: 24, // 아이콘 크기
                        ),
                        onPressed: () {}, // 버튼 클릭 시 실행할 동작
                      ),
                    ),
                  ],
                ),
            ],
          );
        });
  }
}
