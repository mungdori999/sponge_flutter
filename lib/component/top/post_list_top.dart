import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/screen/login_screen.dart';
import 'package:sponge_app/screen/search_screen.dart';

class PostListTop extends StatelessWidget {
  const PostListTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '진단사례',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Spacer(),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchScreen()), // 화면 이동
              );
            },
            icon: Icon(Icons.search)),
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
      ],
    );
  }
}
