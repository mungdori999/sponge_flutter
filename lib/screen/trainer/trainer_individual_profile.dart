import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/profile_top.dart';
import 'package:sponge_app/component/trainer/trainer_profile.dart';
import 'package:sponge_app/component/trainer/trainer_profile_answer.dart';
import 'package:sponge_app/component/trainer/trainer_profile_history.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/answer/answer_response.dart';
import 'package:sponge_app/data/trainer/trainer.dart';
import 'package:sponge_app/request/answer_reqeust.dart';
import 'package:sponge_app/request/trainer_reqeust.dart';

class TrainerIndividualProfile extends StatefulWidget {
  final int id;

  const TrainerIndividualProfile({super.key, required this.id});

  @override
  State<TrainerIndividualProfile> createState() =>
      _TrainerIndividualProfileState();
}

class _TrainerIndividualProfileState extends State<TrainerIndividualProfile> {
  Trainer? trainer;
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

  Future<void> _initializeData() async {
    final trainerInfo = await getTrainer(widget.id);
    setState(() {
      trainer = trainerInfo;
    });
  }

  _initPage() {
    currentPage = 0;
    isLoading = false;
    hasMorePosts = true;
  }

  Future<void> _fetchMoreAnswer() async {
    if (isLoading || !hasMorePosts) return;
    setState(() {
      isLoading = true;
    });
    try {
      if (_selectedIndex == 3) {
        final List<AnswerBasicListResponse> newAnswerList =
            await getAnswerListByTrainerId(widget.id, currentPage);
        setState(() {
          if (newAnswerList.isEmpty) {
            hasMorePosts = false;
          } else {
            answerList.addAll(newAnswerList);
            currentPage++;
          }
        });
      }
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (trainer == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: ProfileTop(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TrainerProfile(
                  trainer: trainer!,
                ),
              ),
              Container(
                width: double.infinity,
                height: 8,
                color: lightGrey,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                              _initPage();
                            });
                          },
                          child: Text(
                            '경력',
                            style: TextStyle(
                              color:
                              _selectedIndex == 1 ? Colors.black : mainGrey,
                              fontSize: 16,
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
                            '리뷰',
                            style: TextStyle(
                              color:
                              _selectedIndex == 2 ? Colors.black : mainGrey,
                              fontSize: 16,
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
                  Expanded(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            _initPage();
                            answerList = await getAnswerListByTrainerId(widget.id,currentPage);
                            setState(() {
                              currentPage++;
                              _selectedIndex = 3; // 세 번째 버튼 선택 시
                            });
                          },
                          child: Text(
                            '활동내역',
                            style: TextStyle(
                              color:
                              _selectedIndex == 3 ? Colors.black : mainGrey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          height: 2,
                          color: _selectedIndex == 3 ? mediumGrey : lightGrey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              if (_selectedIndex == 1)
                TrainerProfileHistory(
                  historyList: trainer!.historyList,
                ),
              if (_selectedIndex == 3)
                Column(
                  children: [
                    TrainerProfileAnswer(
                      answerList: answerList,
                    ),
                    if (isLoading)
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
