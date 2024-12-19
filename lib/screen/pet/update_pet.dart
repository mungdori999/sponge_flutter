import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/component/bottom/next_button.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/pet/pet.dart';
import 'package:sponge_app/data/pet/pet_create.dart';
import 'package:sponge_app/request/pet_request.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class UpdatePet extends StatefulWidget {
  final Pet pet;

  UpdatePet({super.key, required this.pet});

  @override
  State<UpdatePet> createState() => _UpdatePetState();
}

class _UpdatePetState extends State<UpdatePet> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _breedController;
  late TextEditingController _weightController;

  bool _isNeuteredChecked = false;
  int _selectedGender = 1;
  int _selectedAge = 0;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // 입력값 변경 모니터링
    _nameController = TextEditingController(text: widget.pet.name);
    _breedController = TextEditingController(text: widget.pet.breed);
    _ageController = TextEditingController(
      text: '${widget.pet.age} 살', // 선택된 나이를 표시
    );
    _weightController =
        TextEditingController(text: widget.pet.weight.toString());
    _selectedAge = widget.pet.age;
    if (widget.pet.gender % 2 == 0) {
      _isNeuteredChecked = true;
      _selectedGender = widget.pet.gender - 1;
    } else {
      _isNeuteredChecked = false;
      _selectedGender = widget.pet.gender;
    }
    _nameController.addListener(_updateButtonState);
    _ageController.addListener(_updateButtonState);
    _breedController.addListener(_updateButtonState);
    _weightController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _nameController.dispose();
    _ageController.dispose();
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
          title: Container(),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(), // 원하는 경우 FAB와 연동 가능
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '정말 삭제하시겠습니까?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: BorderSide.none,
                                        ),
                                        onPressed: () async {
                                          await deletePet(widget.pet.id);
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/',
                                                (Route<dynamic> route) => false,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('삭제되었습니다.'),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          '삭제',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: BorderSide.none,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // 다이얼로그 닫기
                                        },
                                        child: const Text(
                                          '취소',
                                          style: TextStyle(color: mainGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor:  Colors.red ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    side: BorderSide.none,
                    minimumSize: Size(MediaQuery.of(context).size.width/2.5, 48),
                  ),
                  child:  Text(
                    '삭제',
                    style: TextStyle(
                      color:  Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: _isButtonEnabled ? () {
                    PetCreate petCreate = _settingPet();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _UpdatePetImg(
                          id: widget.pet.id,
                          petCreate: petCreate,
                        ),
                      ),
                    );
                  } : null,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? mainYellow : lightGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    side: BorderSide.none,
                    minimumSize: Size(MediaQuery.of(context).size.width/2.5, 48),
                  ),
                  child: Text(
                    '다음',
                    style: TextStyle(
                      color: _isButtonEnabled ? Colors.white : mainGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                    '정보를 수정해주세요',
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
                    controller: _ageController,
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
                _selectedAge = index;
                _ageController.text = '${_selectedAge} 살';
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
    double width = MediaQuery
        .of(context)
        .size
        .width / 6;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = index;
          _updateButtonState();
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

class _UpdatePetImg extends StatelessWidget {
  final PetCreate petCreate;
  final int id;

  const _UpdatePetImg({super.key, required this.petCreate, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: OutlinedButton(
            onPressed: () {
              updatePet(id, petCreate);
              Provider.of<PageIndexProvider>(context,
                  listen: false)
                  .updateIndex(3);
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
            height: MediaQuery
                .of(context)
                .size
                .height,
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
                          '수정해주세요',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Image.asset('asset/img/basic_pet_camera.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
