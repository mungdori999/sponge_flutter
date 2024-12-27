import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sponge_app/component/post/post_details.dart';
import 'package:sponge_app/component/top/common_top.dart';
import 'package:sponge_app/component/top/screen_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/answer/answer_response.dart';
import 'package:sponge_app/data/post/check_response.dart';
import 'package:sponge_app/data/post/post.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/request/answer_reqeust.dart';
import 'package:sponge_app/request/post_request.dart';
import 'package:sponge_app/screen/answer/write_answer.dart';
import 'package:sponge_app/token/jwtUtil.dart';
import 'package:sponge_app/util/convert.dart';

class PostScreen extends StatefulWidget {
  final int id;

  const PostScreen({super.key, required this.id});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  JwtUtil jwtUtil = new JwtUtil();
  bool trainerAnswer = true;
  LoginAuth? loginAuth;
  PostResponse? post;
  List<AnswerListResponse>? answerList = [];
  CheckResponse check =
      new CheckResponse(likeCheck: false, bookmarkCheck: false);

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    loginAuth = await jwtUtil.getJwtToken();
    post = await getPost(widget.id);
    answerList = await getAnswerList(widget.id);
    if (loginAuth!.loginType == LoginType.USER.value && loginAuth!.id != 0) {
      check = await getMyCheck(post!.id);
    }
    await Future.forEach(answerList!, (answer) {
      if (answer.trainerShortResponse.id == loginAuth!.id) {
        trainerAnswer = false;
      } else {
        trainerAnswer = true;
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const ScreenTop(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostDetails(
              post: post!,
              myPost: loginAuth!.id == post!.userId,
              check: check,
              loginType: loginAuth!.loginType,
            ),
            SizedBox(
              height: 24,
            ),
            if (loginAuth!.loginType == LoginType.TRAINER.value &&
                trainerAnswer) ...[
              Container(
                height: 8,
                color: lightGrey,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${loginAuth!.name} 훈련사님의',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        Text(
                          '진단이 필요한 게시글이에요',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WriteAnswer(
                              post: post!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                        decoration: BoxDecoration(
                          color: mainYellow,
                          border: Border.all(
                            color: mainYellow,
                            width: 1,
                          ), // 배경색 변경
                          borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                        ),
                        child: Text(
                          "답변 쓰기",
                          style: TextStyle(
                            color: Colors.white,
                            // 텍스트 색상 변경
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Container(
              height: 8,
              color: lightGrey,
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '답변 ${post?.answerCount}개',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '최신순',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '추천순',
                          style: TextStyle(
                              color: mainGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ...answerList!
                .map(
                  (answer) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: lightGrey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(14),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 44, // 이미지의 너비
                                      height: 44, // 이미지의 높이
                                      child: ClipOval(
                                        child: answer.trainerShortResponse
                                                    .profileImgUrl ==
                                                ''
                                            ? Container(
                                                width: 70, // 동그라미의 너비
                                                height: 70, // 동그라미의 높이
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .grey[300], // 회색 배경색
                                                  shape: BoxShape
                                                      .circle, // 동그라미 형태
                                                ),
                                                child: Icon(
                                                  Icons.person, // 사람 모양 아이콘
                                                  color: Colors.white, // 아이콘 색상
                                                  size: 30, // 아이콘 크기
                                                ),
                                              )
                                            : Image.network(
                                                answer.trainerShortResponse
                                                    .profileImgUrl,
                                                fit: BoxFit.cover, // 이미지 크기 조정
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${answer.trainerShortResponse.name} 훈련사님',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '채택된 답변 ${answer.trainerShortResponse.adoptCount}건',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: mediumGrey,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              '|',
                                              style: TextStyle(
                                                  color: mainGrey,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              '1:1상담 ${answer.trainerShortResponse.chatCount}회',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: mediumGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: ElevatedButton(
                                        onPressed: () async {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonGrey, // 배경색 설정
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8), // 모서리 둥글게 설정
                                          ),
                                          elevation: 0, // 그림자 제거
                                        ),
                                        child: Text(
                                          '답변채택하기',
                                          style: TextStyle(
                                            color: Colors.white, // 텍스트 색상 설정
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonGrey, // 배경색 설정
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8), // 모서리 둥글게 설정
                                          ),
                                          elevation: 0, // 그림자 제거
                                        ),
                                        child: Text(
                                          '1:1채팅하기',
                                          style: TextStyle(
                                            color: Colors.white, // 텍스트 색상 설정
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          answer.answerResponse.content,
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              Convert.convertTimeAgo(
                                  answer.answerResponse.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: mainGrey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12,),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
