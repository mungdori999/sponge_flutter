import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';

class RegisterTop extends StatelessWidget {
  const RegisterTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '프로필',
      style: TextStyle(
        color: mainGrey,
        fontSize: 20,
        fontWeight: FontWeight.w700
      ),
    );
  }
}
