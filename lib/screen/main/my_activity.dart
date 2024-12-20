import 'package:flutter/material.dart';
import 'package:sponge_app/component/home/home_post_card.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/post/post_list_response.dart';
import 'package:sponge_app/request/post_request.dart';
import 'package:sponge_app/screen/post_screen.dart';

class MyActivity extends StatefulWidget {
  const MyActivity({super.key});

  @override
  State<MyActivity> createState() => _MyActivityState();
}

class _MyActivityState extends State<MyActivity> {
  int _selectedIndex = 1;
  List<Post> postList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  bool isLoading = false;
  bool hasMorePosts = true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeData();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  Future<void> _initializeData() async {
    final myPost = await getMyPost(currentPage);

    setState(() {
      postList.addAll(myPost);
      currentPage++;
    });
  }
  Future<void> _fetchMorePosts() async {
    if (isLoading || !hasMorePosts) return;
    setState(() {
      isLoading = true;
    });

    try {
      final newPosts = await getMyPost(currentPage);
      setState(() {
        if (newPosts.isEmpty) {
          hasMorePosts = false;
        } else {
          postList.addAll(newPosts);
          currentPage++;
        }
      });
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if(_selectedIndex==1) {
      _fetchMorePosts();
      }
      if(_selectedIndex==2) {

      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1; // 첫 번째 버튼 선택 시
                          });
                        },
                        child: Text(
                          '활동내역',
                          style: TextStyle(
                            color: _selectedIndex == 1 ? Colors.black : mainGrey,
                            fontSize: 16,
                            fontWeight: _selectedIndex == 1
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 2, // 선의 두께
                        color: _selectedIndex == 1
                            ? mediumGrey
                            : lightGrey, // 선택된 버튼은 검정색, 나머지는 회색
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2; // 두 번째 버튼 선택 시
                          });
                        },
                        child: Text(
                          '저장한글',
                          style: TextStyle(
                            color: _selectedIndex == 2 ? Colors.black : mainGrey,
                            fontSize: 16,
                            fontWeight: _selectedIndex == 2
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 2,
                        color: _selectedIndex == 2 ? mediumGrey : lightGrey,
                      ),

                    ],
                  ),
                ),
              ],
            ),
            if(_selectedIndex ==1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('내가쓴 글',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                  ...postList
                      .map(
                        (post) => GestureDetector(
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
                          child: HomePostCard(post: post),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
