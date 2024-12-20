import 'package:flutter/material.dart';
import 'package:sponge_app/component/mypage/alert_login.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/screen/main/trainer_my_activity.dart';
import 'package:sponge_app/screen/main/user_my_activity.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class SelectMyActivity extends StatefulWidget {
  const SelectMyActivity({super.key});

  @override
  State<SelectMyActivity> createState() => _SelectMyActivityState();
}

class _SelectMyActivityState extends State<SelectMyActivity> {
  JwtUtil jwtUtil = JwtUtil();
  LoginAuth? loginAuth;

  @override
  void initState() {
    super.initState();
    _initializeData();
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
    } else {
      setState(() {});
    }
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
        return TrainerMyActivity();
      }
      // 유저 프로필
      if (loginAuth!.loginType == LoginType.USER.value) {
        return UserMyActivity();
      }
    }
    return Container();
  }
}
