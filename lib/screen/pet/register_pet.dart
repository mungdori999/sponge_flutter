import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sponge_app/component/bottom/next_button.dart';
import 'package:sponge_app/component/top/register_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/pet/pet_create.dart';
import 'package:sponge_app/request/pet_image_request.dart';
import 'package:sponge_app/request/pet_request.dart';

class RegisterPet extends StatefulWidget {
  RegisterPet({super.key});

  @override
  State<RegisterPet> createState() => _RegisterPetState();
}

class _RegisterPetState extends State<RegisterPet> {
  bool _isNeuteredChecked = false;
  int _selectedGender = 1;
  int _selectedAge = 0;
  bool _isButtonEnabled = false;

  // TextEditingController 추가
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 입력값 변경 모니터링
    _nameController.addListener(_updateButtonState);
    _breedController.addListener(_updateButtonState);
    _weightController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      // 모든 TextField가 입력되었는지 확인
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          _breedController.text.isNotEmpty &&
          _weightController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w700);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const RegisterTop(),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        bottomNavigationBar: NextButton(
            enabled: _isButtonEnabled,
            nextPressed: () {
              PetCreate petCreate = _settingPet();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _RegisterPetImg(
                    petCreate: petCreate,
                  ),
                ),
              );
            }),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '반려견에 대한',
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
                        '반려견 이름',
                        style: textStyle,
                      ),
                      _RequiredStar(),
                    ],
                  ),
                  _CustomTextFiled(
                    text: '예) 멍멍이',
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        '나이',
                        style: textStyle,
                      ),
                      _RequiredStar(),
                    ],
                  ),
                  TextField(
                    readOnly: true,
                    cursorColor: mainYellow,
                    onTap: () {
                      _showAgePicker(context);
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: lightGrey, width: 1),
                        borderRadius: BorderRadius.zero,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: lightGrey, width: 1),
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    controller: TextEditingController(
                      text: '$_selectedAge 살', // 선택된 나이를 표시
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        '견종',
                        style: textStyle,
                      ),
                      _RequiredStar(),
                    ],
                  ),
                  _CustomTextFiled(
                    text: '예) 보더콜리 믹스',
                    controller: _breedController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        '몸무게',
                        style: textStyle,
                      ),
                      _RequiredStar(),
                    ],
                  ),
                  TextField(
                    controller: _weightController,
                    cursorColor: mainYellow,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: '몸무게를 입력하세요',
                      suffixText: 'kg',
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        '성별',
                        style: textStyle,
                      ),
                      _RequiredStar(),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isNeuteredChecked = !_isNeuteredChecked;
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _isNeuteredChecked
                                ? mainYellow
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // 체크박스와 텍스트 간 간격
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isNeuteredChecked = !_isNeuteredChecked;
                          });
                        },
                        child: Text(
                          '중성화 완료',
                          style: TextStyle(
                            color: _isNeuteredChecked ? mainYellow : mainGrey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton(1, '남아'),
                      SizedBox(width: 16), // 버튼 간 간격
                      _buildButton(3, '여아'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PetCreate _settingPet() {
    int gender = _isNeuteredChecked ? _selectedGender + 1 : _selectedGender;
    return new PetCreate(
        name: _nameController.text,
        breed: _breedController.text,
        gender: gender,
        age: _selectedAge,
        weight: double.parse(_weightController.text),
        petImgUrl: '');
  }

  void _showAgePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            itemExtent: 40,
            // 항목 높이
            scrollController:
                FixedExtentScrollController(initialItem: _selectedAge),
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedAge = index; // 선택된 나이 업데이트
              });
            },
            children: List<Widget>.generate(21, (int index) {
              return Center(
                child: Text(
                  '$index 살',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }),
          ),
        );
      },
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

class _CustomTextFiled extends StatelessWidget {
  final text;
  final TextEditingController controller;

  const _CustomTextFiled(
      {super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: mainYellow,
      decoration: InputDecoration(
        hintText: text,
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
    );
  }
}

class _RegisterPetImg extends StatefulWidget {
  final PetCreate petCreate;

  const _RegisterPetImg({super.key, required this.petCreate});

  @override
  State<_RegisterPetImg> createState() => _RegisterPetImgState();
}

class _RegisterPetImgState extends State<_RegisterPetImg> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const RegisterTop(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: OutlinedButton(
            onPressed: () async {
              if (imageFile != null) {
                widget.petCreate.petImgUrl = await uploadPetImg(imageFile!);
              }
              createPet(widget.petCreate);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (Route<dynamic> route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: mainYellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              side: BorderSide.none,
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text(
              '완료',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '반려견 대표사진을',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '등록해주세요',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await pickAndUploadImage();
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 150, // 동그라미의 너비
                            height: 150, // 동그라미의 높이
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200, // 배경색
                              shape: BoxShape.circle, // 동그라미 형태
                              image: imageFile != null
                                  ? DecorationImage(
                                      image:
                                          FileImage(imageFile!), // 선택한 이미지 표시
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: imageFile == null
                                ? Icon(
                                    Icons.pets_sharp, // 기본 아이콘
                                    color: Colors.grey,
                                    size: 60,
                                  )
                                : null,
                          ),
                          if (imageFile != null)
                            Positioned(
                              left: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    imageFile = null; // 이미지 파일 비우기
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close, // 엑스(X) 아이콘
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          // 오른쪽 아래 카메라 아이콘
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path); // 이미지 파일 저장
      });
    }
  }
}
