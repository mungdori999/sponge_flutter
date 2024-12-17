import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';

class TrainerProfile extends StatefulWidget {
  TrainerCreate trainerCreate;

  TrainerProfile({super.key, required this.trainerCreate});

  @override
  State<TrainerProfile> createState() => _TrainerProfileState();
}

class _TrainerProfileState extends State<TrainerProfile> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  int _selectedGender = 1;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.trainerCreate.name ?? '');
    _phoneController = TextEditingController(text: widget.trainerCreate.phone ?? '');
    _selectedGender = widget.trainerCreate.gender;
    _nameController.addListener(_updateButtonState);
    _phoneController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      // 모든 TextField가 입력되었는지 확인
      enabled =
          _nameController.text.isNotEmpty && _phoneController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '프로필',
            style: TextStyle(
                color: mediumGrey, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close, // 'X' 아이콘
              color: Colors.black, // 아이콘 색상
            ),
            onPressed: () {
              Navigator.pop(context, widget.trainerCreate);
            },
          ),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton(
              onPressed: () {
                widget.trainerCreate.name = _nameController.text;
                widget.trainerCreate.gender = _selectedGender;
                widget.trainerCreate.phone = _phoneController.text;
                Navigator.pop(context, widget.trainerCreate);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: enabled ? mainYellow : lightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                side: BorderSide.none,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                '저장',
                style: TextStyle(
                  color: enabled ? Colors.white : mainGrey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100, // 동그라미의 너비
                        height: 100, // 동그라미의 높이
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200, // 회색 배경색
                          shape: BoxShape.circle, // 동그라미 형태
                        ),
                        child: Icon(
                          Icons.person, // 사람 모양 아이콘
                          color: Colors.grey, // 아이콘 색상
                          size: 40, // 아이콘 크기
                        ),
                      ),
                      // 오른쪽 아래 카메라 아이콘
                      Positioned(
                        right: 0, // 오른쪽 정렬
                        bottom: 0, // 아래쪽 정렬
                        child: Container(
                          width: 30, // 카메라 아이콘 컨테이너 너비
                          height: 30, // 카메라 아이콘 컨테이너 높이
                          decoration: BoxDecoration(
                            color: Colors.white, // 배경색
                            shape: BoxShape.circle, // 동그라미 모양
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26, // 그림자 색상
                                blurRadius: 4, // 그림자 흐림 정도
                                offset: Offset(2, 2), // 그림자 위치
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt, // 카메라 아이콘
                            color: Colors.grey, // 아이콘 색상
                            size: 16, // 아이콘 크기
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        '이름',
                        style: TextStyle(
                            color: mediumGrey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                      _RequiredStar(),
                    ],
                  ),
                  TextField(
                    controller: _nameController,
                    cursorColor: mainYellow,
                    decoration: InputDecoration(
                      hintText: "예) 김훈련",
                      hintStyle: TextStyle(
                        color: mainGrey,
                      ),
                      focusColor: mainGrey,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: lightGrey, width: 1),
                        borderRadius: BorderRadius.zero,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainGrey, width: 1),
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        '성별',
                        style: TextStyle(
                            color: mediumGrey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                      _RequiredStar(),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton(1, '남'),
                      _buildButton(3, '여'),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        '전화번호',
                        style: TextStyle(
                            color: mediumGrey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                      _RequiredStar(),
                    ],
                  ),
                  TextField(
                    controller: _phoneController,
                    cursorColor: mainYellow,
                    keyboardType: TextInputType.number,
                    // 숫자 키보드 설정
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
                    ],
                    decoration: InputDecoration(
                      hintText: "예) 01012341234",
                      hintStyle: TextStyle(
                        color: mainGrey,
                      ),
                      focusColor: mainGrey,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: lightGrey, width: 1),
                        borderRadius: BorderRadius.zero,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainGrey, width: 1),
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(int index, String text) {
    bool isSelected = _selectedGender == index;
    double width = MediaQuery.of(context).size.width / 6;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = index; // 선택된 버튼 인덱스 업데이트
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: width),
        decoration: BoxDecoration(
          color: isSelected ? mainYellow : Colors.white,
          border: Border.all(
            color: mainYellow,
            width: 1,
          ), // 배경색 변경
          borderRadius: BorderRadius.circular(8), // 모서리 둥글게
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : mainYellow, // 텍스트 색상 변경
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
