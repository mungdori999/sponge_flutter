import 'package:flutter/material.dart';
import 'package:sponge_app/screen/settings_screen.dart';

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
          onPressed: () {},
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
