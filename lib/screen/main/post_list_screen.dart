import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/component/post/category_list.dart';
import 'package:sponge_app/component/post/post_card.dart';
import 'package:sponge_app/const/category_code.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/pet/pet.dart';
import 'package:sponge_app/data/post/post_list_response.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/request/pet_request.dart';
import 'package:sponge_app/request/post_request.dart';
import 'package:sponge_app/screen/post_screen.dart';
import 'package:sponge_app/screen/write/select_pet.dart';
import 'package:sponge_app/token/jwtUtil.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0;
  List<Post> postList = [];
  int currentPage = 0;
  bool isLoading = false;
  bool hasMorePosts = true;

  List<String> categoryList =
      CategoryCode.values.map((category) => category.description).toList();

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
    final List<Post> post = await getAllPost(0, currentPage);
    setState(() {
      postList.addAll(post);
      currentPage++;
    });
  }

  Future<void> _fetchMorePosts() async {
    if (isLoading || !hasMorePosts) return;
    setState(() {
      isLoading = true;
    });
    try {
      int categoryCode = CategoryCode.getCodeByDescription(categoryList[selectedIndex]);
      final List<Post> newPosts = await getAllPost(categoryCode, currentPage);
      print(currentPage);
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
      body: SingleChildScrollView(
        controller: _scrollController,
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
              Container(
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
                                    builder: (context) =>
                                        PostScreen(id: post.id),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: PostCard(post: post),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          JwtUtil jwtUtil = JwtUtil();
          LoginAuth loginAuth = await jwtUtil.getJwtToken();
          if (loginAuth.id == 0 ||
              loginAuth.loginType != LoginType.USER.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('주의'),
                    content: Text('견주 로그인이 필요합니다.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Provider.of<PageIndexProvider>(context, listen: false)
                              .updateIndex(0);
                        },
                        child: Text('닫기'),
                      ),
                    ],
                  );
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

  void categoryPressed(int index) async {
    selectedIndex = index;
    int categoryCode = CategoryCode.getCodeByDescription(categoryList[index]);
    final List<Post> post = await getAllPost(categoryCode, 0);
    setState(() {
      postList = [];
      postList.addAll(post);
      _initPage();
      currentPage++;
    });
  }
}
