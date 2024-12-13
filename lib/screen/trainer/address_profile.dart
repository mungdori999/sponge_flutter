import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';

class AddressProfile extends StatelessWidget {
  const AddressProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '지역',
          style: TextStyle(
              color: mediumGrey, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close, // 'X' 아이콘
            color: Colors.black, // 아이콘 색상
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '주요 활동지역 선택',
                  style: TextStyle(
                      color: mediumGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                _RequiredStar(),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '(중복선택 가능)',
                  style: TextStyle(
                      color: mainGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 칸 간격 조정
              children: List.generate(5, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    height: 50, // 높이 설정
                    decoration: BoxDecoration(
                      color: lightGrey, // 배경색 (회색)
                      borderRadius: BorderRadius.circular(8), // 둥근 모서리
                    ),
                    child: Center(
                      child: Text(
                        '서울', // 텍스트
                        style: TextStyle(
                          color: mainGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequiredStar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '*',
      style: TextStyle(
        color: Colors.red,
        fontSize: 16, // 원하는 크기로 설정
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
