import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sponge_app/component/post/post_card.dart';
import 'package:sponge_app/component/search.dart';
import 'package:sponge_app/data/post/post_list_response.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';
import 'package:http/http.dart' as http;
import 'package:sponge_app/screen/post_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<Post> postList = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.chevron_left),
                    iconSize: 40,
                    padding: EdgeInsets.zero,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Search(
                        enabled: true,
                        controller: _controller,
                        onSearch: _onSearchSubmitted,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child:
                                PostCard(post: post), // post 변수를 PostCard에 전달
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendSearchRequest(String keyword, int page) async {
    final url = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: '${path}/post/search',
      queryParameters: {
        'keyword': keyword,
        'page': page.toString(),
      },
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == ok) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          postList = data.map((item) => Post.fromJson(item)).toList();
        });
        // 검색 결과에 따라 추가 작업을 수행할 수 있습니다.
      } else {
        print('Failed to fetch results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending search request: $e');
    }
  }

  // 아이콘이나 완료 버튼을 눌렀을 때 호출
  void _onSearchSubmitted() {
    final keyword = _controller.text;
    if (keyword.isNotEmpty) {
      _sendSearchRequest(keyword, 0);
    }
  }
}
