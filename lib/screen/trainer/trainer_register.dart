import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/write_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/gender.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';
import 'package:sponge_app/http/auth_response.dart';
import 'package:sponge_app/screen/trainer/address_profile.dart';
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
  bool _enabled = false;

  _updateButton() {
    setState(() {
      _enabled = trainerCreate.name != '' &&
          trainerCreate.phone != '' &&
          trainerCreate.years != 0;
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: OutlinedButton(
            onPressed: _enabled ? () {} : null,
            style: OutlinedButton.styleFrom(
              backgroundColor: _enabled ? mainYellow : lightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              side: BorderSide.none,
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text(
              '다음',
              style: TextStyle(
                color: _enabled ? Colors.white : mainGrey,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
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
                                Gender.getDescriptionByCode(
                                    trainerCreate.gender),
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
                            _updateButton();
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
                  SizedBox(
                    width: 8,
                  ),
                  if (trainerCreate.historyList.isNotEmpty) ...[
                    Text(
                      trainerCreate.historyList.length.toString(),
                      style: TextStyle(
                          color: mainYellow,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    Text(
                      "/10",
                      style: TextStyle(
                          color: mainGrey,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ]
                ],
              ),
              if (trainerCreate.historyList.isEmpty) ...[
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
                              _updateButton();
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
              ] else ...[
                Column(
                  children: [
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
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '~${trainerCreate.years}년차',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
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
                                  _updateButton();
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
                      height: 8,
                    ),
                    Column(
                      children: trainerCreate.historyList.map((history) {
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          // 컨테이너 간격
                          padding: EdgeInsets.all(12),
                          // 내부 여백
                          decoration: BoxDecoration(
                            color: lightGrey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // 텍스트 왼쪽 정렬
                                  children: [
                                    Text(
                                      history.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          _formatDateString(history.startDt),
                                          style: TextStyle(
                                              color: mainGrey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          '~',
                                          style: TextStyle(
                                              color: mainGrey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        if (history.endDt != '')
                                          Text(
                                            _formatDateString(history.endDt),
                                            style: TextStyle(
                                                color: mainGrey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      history.description,
                                      // history의 description
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: mainGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ],
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
                      if (trainerCreate.addressList.length == 0) ...[
                        Text(
                          '지역을 선택해주세요',
                          style: TextStyle(color: mainGrey, fontSize: 16),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            ...trainerCreate.addressList.map((address) {
                              return Text(
                                '${address.city} ${address.town}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              );
                            }),
                          ],
                        ),
                      ],
                      IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressProfile(
                                addressList: trainerCreate.addressList,
                              ),
                            ),
                          );
                          setState(() {

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
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateString(String date) {
    if (date.length != 6) return date; // 길이가 6이 아니면 그대로 반환
    String year = date.substring(0, 4); // 앞의 4자리: 연도
    String month = date.substring(4, 6); // 뒤의 2자리: 월
    return "$year.$month";
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
