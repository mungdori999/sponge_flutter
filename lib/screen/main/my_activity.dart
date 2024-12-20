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

  _initPage() {
    currentPage = 0;
    isLoading = false;
    hasMorePosts = true;
  }

  Future<void> _initializeData() async {
    final List<Post> myPost = _selectedIndex == 1
        ? await getMyPost(currentPage)
        : _selectedIndex == 2
            ? await getMyPostByBookmark(currentPage)
            : [];

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
      final List<Post> newPosts = _selectedIndex == 1
          ? await getMyPost(currentPage)
          : _selectedIndex == 2
              ? await getMyPostByBookmark(currentPage)
              : [];
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
      _fetchMorePosts();
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
                        onPressed: () async {
                          _initPage();
                          postList = await getMyPost(currentPage);
                          currentPage++;
                          if (postList.length < 10) hasMorePosts = false;
                          setState(() {
                            _selectedIndex = 1; // 첫 번째 버튼 선택 시
                          });
                        },
                        child: Text(
                          '활동내역',
                          style: TextStyle(
                            color:
                                _selectedIndex == 1 ? Colors.black : mainGrey,
                            fontSize: 16,
                            fontWeight: _selectedIndex == 1
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 2, // 선의 두께
                        color: _selectedIndex == 1 ? mediumGrey : lightGrey,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          _initPage();
                          postList = await getMyPostByBookmark(currentPage);
                          currentPage++;
                          if (postList.length < 10) hasMorePosts = false;
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        child: Text(
                          '저장한글',
                          style: TextStyle(
                            color:
                                _selectedIndex == 2 ? Colors.black : mainGrey,
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
            if (_selectedIndex == 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내가쓴 글',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                    if (isLoading)
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (!hasMorePosts)
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text('더 이상 게시글이 없습니다.'),
                        ),
                      ),
                  ],
                ),
              ),
            if (_selectedIndex == 2)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '저장한 글',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                    if (isLoading)
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (!hasMorePosts)
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text('더 이상 게시글이 없습니다.'),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
