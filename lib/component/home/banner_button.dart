import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';

class BannerButton extends StatelessWidget {
  const BannerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w700,
    );
    return Container(
      height: 250,
      width: double.infinity,
      color: mainYellow,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '내 반려동물 행동에',
              style: textStyle,
            ),
            Text(
              '정확한 해결방법을',
              style: textStyle,
            ),
            Text(
              '모르겠다면?',
              style: textStyle,
            ),
            SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () {},
              child: Text('무료로 진단 받아보기 >',
                  style: textStyle.copyWith(fontSize: 16)),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF403E3C),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
