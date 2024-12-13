import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/write_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/gender.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';
import 'package:sponge_app/http/auth_response.dart';
import 'package:sponge_app/screen/trainer/history_profile.dart';
import 'package:sponge_app/screen/trainer/trainer_profile.dart';

class TrainerRegister extends StatefulWidget {
  final AuthResponse authResponse;

  TrainerRegister({super.key, required this.authResponse});

  @override
  State<TrainerRegister> createState() => _TrainerRegisterState();
}

class _TrainerRegisterState extends State<TrainerRegister> {
  TrainerCreate trainerCreate = new TrainerCreate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WriteTop(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '훈련사 등록에 필요한',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              '정보를 입력해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  '프로필',
                  style: TextStyle(
                      color: mediumGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                _RequiredStar(),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80, // 동그라미의 너비
                      height: 80, // 동그라미의 높이
                      decoration: BoxDecoration(
                        color: Colors.white, // 회색 배경색
                        shape: BoxShape.circle, // 동그라미 형태
                      ),
                      child: Icon(
                        Icons.person, // 사람 모양 아이콘
                        color: mainGrey, // 아이콘 색상
                        size: 35, // 아이콘 크기
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trainerCreate.name != ''
                              ? trainerCreate.name
                              : '이름을 입력하세요',
                          style: TextStyle(
                              color: trainerCreate.name != ''
                                  ? darkGrey
                                  : mainGrey,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              Gender.getDescriptionByCode(trainerCreate.gender),
                              style: TextStyle(color: mainGrey, fontSize: 16),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              trainerCreate.phone != ''
                                  ? trainerCreate.phone
                                  : '010-0000-0000',
                              style: TextStyle(color: mainGrey, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        final trainerCreate = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainerProfile(
                              trainerCreate: this.trainerCreate,
                            ),
                          ),
                        );
                        setState(() {
                          this.trainerCreate = trainerCreate;
                        });
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        color: mainGrey,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  '경력',
                  style: TextStyle(
                      color: mediumGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                _RequiredStar(),
              ],
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: lightGrey, // 선의 색상
                    width: 1.0, // 선의 두께
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '경력을 입력해주세요',
                      style: TextStyle(color: mainGrey, fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () async {
                        int years = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryRegister(
                              historyList: trainerCreate.historyList,
                              years: trainerCreate.years,
                            ),
                          ),
                        );
                        setState(() {
                        trainerCreate.years = years;
                        });
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        color: mainGrey,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  '지역',
                  style: TextStyle(
                      color: mediumGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                _RequiredStar(),
              ],
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: lightGrey, // 선의 색상
                    width: 1.0, // 선의 두께
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '지역을 선택해주세요',
                      style: TextStyle(color: mainGrey, fontSize: 16),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: mainGrey,
                      size: 30,
                    ),
                  ],
                ),
              ),
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
