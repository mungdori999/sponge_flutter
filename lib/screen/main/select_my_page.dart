import 'package:flutter/material.dart';
import 'package:sponge_app/component/mypage/alert_login.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/screen/main/my_page_trainer_screen.dart';
import 'package:sponge_app/screen/main/my_page_user_screen.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class SelectMyPage extends StatefulWidget {
  const SelectMyPage({super.key});

  @override
  State<SelectMyPage> createState() => _SelectMyPageState();
}

class _SelectMyPageState extends State<SelectMyPage> {
  JwtUtil jwtUtil = JwtUtil();
  LoginAuth? loginAuth;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    if (loginAuth == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // 훈련사 프로필
      if (loginAuth!.loginType == LoginType.TRAINER.value) {
        return MyPageTrainerScreen();
      }
      // 유저 프로필
      if (loginAuth!.loginType == LoginType.USER.value) {
        return MyPageUserScreen(loginAuth: loginAuth!);
      }
    }
    return Container();
  }

  _initializeData() async {
    loginAuth = await jwtUtil.getJwtToken();
    if (loginAuth == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertLogin();
          },
        );
      });
    }
    else {
      setState(() {});
    }

  }
}
