import 'package:flutter/material.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/trainer/trainer.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/request/trainer_reqeust.dart';
import 'package:sponge_app/screen/settings_screen.dart';
import 'package:sponge_app/screen/trainer/craete/trainer_register.dart';
import 'package:sponge_app/screen/trainer/update/trainer_update.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class MyPageTop extends StatelessWidget {
  const MyPageTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            ),
          ),
          icon: Icon(Icons.settings),
        ),
        TextButton(
          onPressed: () async {
            JwtUtil jwtUtil = new JwtUtil();
            LoginAuth loginAuth = await jwtUtil.getJwtToken();
            if (loginAuth.loginType == LoginType.TRAINER.value) {
              Trainer trainer = await getMyInfo();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainerUpdate(
                    trainer: trainer,
                  ),
                ),
              );
            }
          },
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: Colors.black,
                size: 20,
              ),
              Text(
                '프로필 수정',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
