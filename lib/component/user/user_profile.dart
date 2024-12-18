import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/user/user.dart';

class UserProfile extends StatelessWidget {
  final UserResponse user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              user.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              '견주님의',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: mainGrey),
            ),
          ],
        ),
        Text(
          '프로필이에요',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: mainGrey),
        ),

      ],
    );
  }
}
