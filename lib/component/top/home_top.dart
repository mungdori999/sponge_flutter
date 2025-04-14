import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/top_login_component.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/trainer/trainer.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/request/trainer_img_reqeust.dart';
import 'package:sponge_app/request/trainer_reqeust.dart';
import 'package:sponge_app/token/jwtUtil.dart';
import 'package:sponge_app/util/file_storage.dart';

class HomeTop extends StatefulWidget {
  HomeTop({super.key});

  @override
  State<HomeTop> createState() => _HomeTopState();
}

class _HomeTopState extends State<HomeTop> {
  JwtUtil jwtUtil = new JwtUtil();

  late LoginAuth loginAuth;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    loginAuth = await jwtUtil.getJwtToken();
    if (loginAuth.id != 0 && loginAuth.loginType == LoginType.TRAINER.value) {
      Trainer myInfo = await getMyTrainerInfo();
      if (myInfo.profileImgUrl != "") {
        await deleteSavedProfileImage();
        await getMyTrainerImg(myInfo.profileImgUrl);
      }
    }
    if (loginAuth.id != 0 && loginAuth.loginType == LoginType.USER.value) {
        await deleteSavedProfileImage();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator(color: mainYellow,);
    } else {
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
    }
  }
}
