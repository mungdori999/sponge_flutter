import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sponge_app/component/post/post_details.dart';
import 'package:sponge_app/component/top/common_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/post/check_response.dart';
import 'package:sponge_app/data/post/post.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/request/post_request.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class PostScreen extends StatefulWidget {
  final int id;

  const PostScreen({super.key, required this.id});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  JwtUtil jwtUtil = new JwtUtil();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Future(() async {
      final userAuth = await jwtUtil.getJwtToken();
      final post = await getPost(widget.id);
      CheckResponse checkResponse = new CheckResponse(likeCheck: false, bookmarkCheck: false);
      if (userAuth.loginType == LoginType.USER.value && userAuth.id != 0) {
        checkResponse = await getMyCheck(post.id);
      }
      return [userAuth, post,checkResponse];
    }), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(); // 데이터 로딩 중
      }
      if (snapshot.hasError) {
        return Text('오류 발생: ${snapshot.error}');
      }
      if (snapshot.hasData) {
        final results = snapshot.data as List;
        final LoginAuth userAuth = results[0];
        final PostResponse post = results[1];
        final CheckResponse check = results[2];

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const CommonTop(),
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                PostDetails(
                  post: post,
                  myPost: userAuth.id == post.userId,
                  check: check,
                ),
                SizedBox(
                  height: 24,
                ),
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
                )
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }
}
