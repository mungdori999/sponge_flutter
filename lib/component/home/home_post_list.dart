import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/component/post/category_list.dart';
import 'package:sponge_app/component/home/home_post_card.dart';
import 'package:sponge_app/const/category_code.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:http/http.dart' as http;
import 'package:sponge_app/data/post/post_list_response.dart';
import 'package:sponge_app/http/status_code.dart';
import 'dart:convert';

import 'package:sponge_app/http/url.dart';
import 'package:sponge_app/screen/post_screen.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class HomePostList extends StatefulWidget {
  final VoidCallback latestPostListPressed;

  const HomePostList({super.key, required this.latestPostListPressed});

  @override
  State<HomePostList> createState() => _HomePostListState();
}

class _HomePostListState extends State<HomePostList> {
  List<String> categoryList =
      CategoryCode.values.map((category) => category.description).toList();
  List<Post> postList = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchPostList(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: widget.latestPostListPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '최신 진단사례',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              CategoryList(
                categoryPressed: categoryPressed,
                categoryList: categoryList,
                selectedIndex: selectedIndex,
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1,
          color: Colors.grey[400],
        ),
        Container(
          color: lightGrey,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 16),
                ...postList
                    .map((post) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostScreen(id: post.id),
                            ),
                          ),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: HomePostCard(
                                  post: post), // post 변수를 PostCard에 전달
                            ),
                          ),
                        ))
                    .toList(),
                SizedBox(height: 16,),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<PageIndexProvider>(context,
                        listen: false)
                        .updateIndex(1);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: mainGrey, backgroundColor: Colors.white, // 텍스트 색상
                    elevation: 4, // 그림자 효과
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 내부 여백
                    side: BorderSide.none, // 테두리 없애기
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Row의 크기를 자식에 맞게
                    children: [
                      Text(
                        '진단사례 보러가기',
                        style: TextStyle(color: mainGrey, fontSize: 16), // 텍스트 색상
                      ),
                      SizedBox(width: 8), // 텍스트와 아이콘 간의 간격
                      Icon(Icons.add, color: mainYellow), // 아이콘 색상
                    ],
                  ),
                ),
                SizedBox(height: 16,),
              ],
            ),
          ),
        )
      ],
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
