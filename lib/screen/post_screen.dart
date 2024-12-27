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

class PostScreen extends StatefulWidget {
  final int id;

  const PostScreen({super.key, required this.id});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  JwtUtil jwtUtil = new JwtUtil();
  bool trainerAnswer = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Future(() async {
      final loginAuth = await jwtUtil.getJwtToken();
      final post = await getPost(widget.id);
      CheckResponse checkResponse =
          new CheckResponse(likeCheck: false, bookmarkCheck: false);
      final answerList = await getAnswerList(widget.id);
      if (loginAuth.loginType == LoginType.USER.value && loginAuth.id != 0) {
        checkResponse = await getMyCheck(post.id);
      }
      await Future.forEach(answerList, (answer) {
        if (answer.trainerShortResponse.id == loginAuth.id) {
          trainerAnswer = false;
        } else {
          trainerAnswer = true;
        }
      });
      return [loginAuth, post, checkResponse, answerList];
    }), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(); // 데이터 로딩 중
      }
      if (snapshot.hasError) {
        print(snapshot.error);
        return Text('오류 발생: ${snapshot.error}');
      }
      if (snapshot.hasData) {
        final results = snapshot.data as List;
        final LoginAuth loginAuth = results[0];
        final PostResponse post = results[1];
        final CheckResponse check = results[2];
        final List<AnswerListResponse> answerList = results[3];
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
                  post: post,
                  myPost: loginAuth.id == post.userId,
                  check: check,
                  loginType: loginAuth.loginType,
                ),
                SizedBox(
                  height: 24,
                ),
                if (loginAuth.loginType == LoginType.TRAINER.value &&
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
                              '${loginAuth.name} 훈련사님의',
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
                                  post: post,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 30),
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                  ),
                  child: Column(
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }
}
