import 'package:flutter/material.dart';
import 'package:sponge_app/component/trainer/trainer_profile.dart';
import 'package:sponge_app/component/trainer/trainer_profile_history.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer.dart';
import 'package:sponge_app/request/trainer_reqeust.dart';

class MyPageTrainerScreen extends StatefulWidget {
  const MyPageTrainerScreen({super.key});

  @override
  State<MyPageTrainerScreen> createState() => _MyPageTrainerScreenState();
}

class _MyPageTrainerScreenState extends State<MyPageTrainerScreen> {
  Trainer? trainer;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final myInfo = await getMyInfo();

    setState(() {
      trainer = myInfo;
    });
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                            _selectedIndex = 1; // 첫 번째 버튼 선택 시
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
                        onPressed: () {
                          setState(() {
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
          ],
        ),
      ),
    );
  }
}
