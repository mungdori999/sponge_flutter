import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';

class TrainerMyActivity extends StatefulWidget {
  const TrainerMyActivity({super.key});

  @override
  State<TrainerMyActivity> createState() => _TrainerMyActivityState();
}

class _TrainerMyActivityState extends State<TrainerMyActivity> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }
}
