import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/login_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/login/kakao_login_button.dart';
import 'package:sponge_app/login/login_modal.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const LoginTop(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 36,
            ),
            Text(
              '견주와 훈련사를 연결해',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
            ),
            Text(
              '문제행동 교정을 돕는 서비스',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
            ),
            Text(
              'Mongmi',
              style: TextStyle(
                  fontSize: 34, fontWeight: FontWeight.w700, color: mainYellow),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return LoginModal(
                      loginType: LoginType.USER.value,
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '견주로 로그인하기',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                '문제행동 작성하고',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainGrey,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '훈련사에게 상담받기',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainGrey,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Image.asset(
                            'asset/img/login1.png',
                            width: 70,
                            height: 70,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return LoginModal(
                      loginType: LoginType.TRAINER.value,
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '훈련사로 로그인하기',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                '문제행동 진단하고',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainGrey,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '더 많은 사람에게 홍보하기',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainGrey,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Image.asset(
                            'asset/img/login2.png',
                            width: 70,
                            height: 70,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
