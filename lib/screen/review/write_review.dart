import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/write_top.dart';
import 'package:sponge_app/const/color_const.dart';

class WriteReview extends StatefulWidget {
  const WriteReview({super.key});

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  late TextEditingController _contentController = TextEditingController();
  bool enabled = false;

  int _rating = 5; // 현재 별점 (0 ~ 5)
  void _updateRating(int index) {
    setState(() {
      _rating = index; // 정수형 별점 업데이트
    });
  }

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _contentController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      // 모든 TextField가 입력되었는지 확인
      enabled = _contentController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WriteTop(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton(
            onPressed: enabled
                ? () {
                    // 완료 버튼 동작
                  }
                : null,
            style: OutlinedButton.styleFrom(
              backgroundColor: enabled ? mainYellow : lightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              side: BorderSide.none,
              minimumSize: const Size(double.infinity, 48),
            ),
            child:  Text(
              '완료',
              style: TextStyle(
                color: enabled ? Colors.white : mainGrey,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "훈련사 리뷰 남기기",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    _updateRating(index + 1);
                  },
                  child: Icon(
                    Icons.star,
                    color: index < _rating ? mainYellow : lightGrey,
                    size: 40,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: lightGrey, // 배경색 설정
                borderRadius: BorderRadius.circular(10), // 둥근 테두리
              ),
              padding: const EdgeInsets.all(16.0), // 내부 여백
              child: TextField(
                maxLines: null,
                // 무제한 줄 입력 가능
                controller: _contentController,
                keyboardType: TextInputType.multiline,
                cursorColor: mainYellow,
                decoration: InputDecoration(
                  hintText: '내용을 입력해주세요.',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: mainGrey,
                  ),
                ),
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
