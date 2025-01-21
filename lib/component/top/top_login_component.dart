import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/screen/login_screen.dart';

class TopLoginComponent extends StatelessWidget {
  final LoginAuth loginAuth;

  const TopLoginComponent({super.key, required this.loginAuth});

  Widget build(BuildContext context) {
    if (loginAuth.id == 0) {
      return TextButton(
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
      );
    } else {
      return Row(
        children: [
          Text(
            loginAuth.name,
            style: TextStyle(
                color: mainYellow, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            loginAuth.loginType == LoginType.USER.value ? '님' : '훈련사님',
            style: TextStyle(
                color: mainGrey, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            width: 12,
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {},
            ),
          ),
        ],
      );
    }
  }
}
