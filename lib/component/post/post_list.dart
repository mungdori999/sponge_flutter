import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sponge_app/component/post/category_list.dart';
import 'package:sponge_app/component/post/post_card.dart';
import 'package:sponge_app/const/category_code.dart';
import 'package:sponge_app/data/post/post_list_response.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';
import 'package:http/http.dart' as http;
import 'package:sponge_app/screen/post_screen.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  int selectedIndex = 0;
  List<String> categoryList =
      CategoryCode.values.map((category) => category.description).toList();
  List<Post> postList = [];

  @override
  void initState() {
    super.initState();
    fetchPostList(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24), // 왼쪽 상단 모서리
          topRight: Radius.circular(24), // 오른쪽 상단 모서리
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          CategoryList(
              categoryPressed: categoryPressed,
              categoryList: categoryList,
              selectedIndex: selectedIndex),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey[400],
          ),
          Column(
            children: [
              SizedBox(
                height: 8,
              ),
              ...postList
                  .map(
                    (post) => GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostScreen(id: post.id),
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: PostCard(post: post),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  void categoryPressed(int index) {
    setState(() {
      selectedIndex = index;
      int categoryCode = CategoryCode.getCodeByDescription(categoryList[index]);
      fetchPostList(categoryCode, 0);
    });
  }

  /**
   * postList 조회
   */
  Future<void> fetchPostList(int categoryCode, int page) async {
    // URI에 쿼리 파라미터를 추가
    final url = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: '${path}/post',
      queryParameters: {
        'categoryCode': categoryCode.toString(),
        'page': page.toString(),
      },
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == ok) {
        // UTF-8로 디코딩 후 JSON 데이터 파싱
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        // 데이터를 Post 객체로 변환하고 상태에 저장
        setState(() {
          postList = data.map((item) => Post.fromJson(item)).toList();
        });
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
