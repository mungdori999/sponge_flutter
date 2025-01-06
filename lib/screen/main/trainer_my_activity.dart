import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/answer/answer_response.dart';
import 'package:sponge_app/request/answer_reqeust.dart';
import 'package:sponge_app/screen/post_screen.dart';
import 'package:sponge_app/util/convert.dart';

class TrainerMyActivity extends StatefulWidget {
  const TrainerMyActivity({super.key});

  @override
  State<TrainerMyActivity> createState() => _TrainerMyActivityState();
}

class _TrainerMyActivityState extends State<TrainerMyActivity> {
  int _selectedIndex = 1;
  List<AnswerBasicListResponse> answerList = [];
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
    final List<AnswerBasicListResponse> myAnswer =
        await getMyAnswer(currentPage);
    setState(() {
      answerList.addAll(myAnswer);
      currentPage++;
    });
  }

  Future<void> _fetchMoreAnswer() async {
    if (isLoading || !hasMorePosts) return;
    setState(() {
      isLoading = true;
    });
    try {
      final List<AnswerBasicListResponse> newAnswerList = await getMyAnswer(currentPage);
      setState(() {
        if (newAnswerList.isEmpty) {
          hasMorePosts = false;
        } else {
          answerList.addAll(newAnswerList);
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
      _fetchMoreAnswer();
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
                          setState(() {
                            _selectedIndex = 1; // 첫 번째 버튼 선택 시
                          });
                        },
                        child: Text(
                          '작성한 답변',
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
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        child: Text(
                          '채팅상담',
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
                    ...answerList
                        .map(
                          (answer) => GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostScreen(
                                    id: answer.answerResponse.postId),
                              ),
                            ),
                            child: Column(
                              children: [
                                Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: answer.checkAdopt
                                                ? mainYellow
                                                : lightGrey,
                                          ),
                                          child: Text(
                                            answer.checkAdopt ? '채택됌' : '채택 안됌',
                                            style: TextStyle(
                                              color: answer.checkAdopt
                                                  ? Colors.white
                                                  : mainGrey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          answer.answerResponse.content,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.thumb_up_outlined,
                                                    color: mainGrey,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    '추천 ${answer.answerResponse.likeCount}',
                                                    style: TextStyle(
                                                      color: mainGrey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              Convert.convertTimeAgo(answer
                                                  .answerResponse.createdAt),
                                              style: TextStyle(
                                                  color: mediumGrey,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
              )
          ],
        ),
      ),
    );
  }
}
