import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer.dart';

class TrainerProfile extends StatelessWidget {
  final Trainer trainer;

  const TrainerProfile({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    final String address = trainer.trainerAddressList.map((trainerAddress) {
      return '${trainerAddress.city} ${trainerAddress.town}';
    }).join(' / ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '안녕하세요',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: mainGrey),
        ),
        Row(
          children: [
            Text(
              '훈련사',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: mainGrey),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              trainer.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '입니다',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: mainGrey),
            ),
          ],
        ),
        SizedBox(height: 8,),
        Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '이름',
                              style: TextStyle(
                                  fontSize: 14, color: mainGrey),
                            ),
                            SizedBox(height: 12,),
                            Text(
                              '연차',
                              style: TextStyle(
                                  fontSize: 14, color: mainGrey),
                            ),
                          ],
                        ),
                        SizedBox(width: 50,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trainer.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 12,),
                            Text(
                              '${trainer.years}년차',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ClipOval(
                      child: trainer.profileImgUrl == ''
                          ? Container(
                        width: 70, // 동그라미의 너비
                        height: 70, // 동그라미의 높이
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // 회색 배경색
                          shape: BoxShape.circle, // 동그라미 형태
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.person, // 사람 모양 아이콘
                            color: Colors.white, // 아이콘 색상
                            size: 40, // 아이콘 크기
                          ),
                          onPressed: () {}, // 버튼 클릭 시 실행할 동작
                        ),
                      )
                          : Image.network(
                        trainer.profileImgUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '교육지역',
                      style: TextStyle(
                          fontSize: 14, color: mainGrey),
                    ),
                    SizedBox(width: 24,),
                    Expanded(
                      child: Container(
                        width:double.infinity,
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '소개',
                      style: TextStyle(
                          fontSize: 14, color: mainGrey),
                    ),
                    SizedBox(width: 45,),
                    Expanded(
                      child: Container(
                        width:double.infinity,
                        child: Text(
                          trainer.content,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '리뷰',
                      style: TextStyle(
                          fontSize: 14, color: mainGrey),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: mainYellow, size: 18),
                        Text(
                          '0',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '1:1 상담',
                      style: TextStyle(
                          fontSize: 14, color: mainGrey),
                    ),
                    Text(
                      '${trainer.chatCount}건',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '채택된 답변',
                      style: TextStyle(
                          fontSize: 14, color: mainGrey),
                    ),
                    Text(
                      '${trainer.adoptCount}건',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
