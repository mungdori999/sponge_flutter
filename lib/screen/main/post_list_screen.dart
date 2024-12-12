import 'package:flutter/material.dart';
import 'package:sponge_app/component/mypage/alert_login.dart';
import 'package:sponge_app/component/post/post_list.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/pet/pet.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/request/pet_request.dart';
import 'package:sponge_app/screen/write/select_pet.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: lightGrey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내 반려동물 문제행동에 대해',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '전문가가 직접 알려드려요.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () {
                        // 버튼 클릭 동작 추가
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Row 크기를 내부 요소만큼으로 제한
                        children: [
                          Text(
                            '문제 행동 상담받기',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: mainYellow,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PostList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          JwtUtil jwtUtil = JwtUtil();
          LoginAuth loginAuth = await jwtUtil.getJwtToken();
          if (loginAuth.id == 0 || loginAuth.loginType != LoginType.USER.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertLogin();
                },
              );
            });
          } else {
            List<Pet> petList = await getMyPet();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectPet(
                  petList: petList,
                ),
              ),
            );
          }
        },
        backgroundColor: mainYellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // 완전히 둥글게
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 오른쪽 아래 고정
    );
  }
}
