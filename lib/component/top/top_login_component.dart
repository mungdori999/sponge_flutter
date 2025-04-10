import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/screen/login_screen.dart';
import 'package:sponge_app/util/file_storage.dart';

class TopLoginComponent extends StatefulWidget {
  final LoginAuth loginAuth;

  const TopLoginComponent({super.key, required this.loginAuth});

  @override
  State<TopLoginComponent> createState() => _TopLoginComponentState();
}

class _TopLoginComponentState extends State<TopLoginComponent> {
  File? profileImage;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    profileImage = await getSavedProfileImage();

    setState(() {
      // 이미지캐시 삭제
      imageCache.clear();
      imageCache.clearLiveImages();
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      return Container();
    } else {
      if (widget.loginAuth.id == 0) {
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
              widget.loginAuth.name,
              style: TextStyle(
                  color: mainYellow, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              widget.loginAuth.loginType == LoginType.USER.value ? '님' : '훈련사님',
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
                color: lightGrey,
                shape: BoxShape.circle,
                image: profileImage != null
                    ? DecorationImage(
                  image: FileImage(profileImage!),
                  // 선택한 이미지 표시
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: profileImage == null
                  ? Icon(
                Icons.person, // 사람 모양 아이콘
                color: mainGrey, // 아이콘 색상
                size: 25, // 아이콘 크기
              )
                  : null,
            ),
          ],
        );
      }
    }
  }
}
