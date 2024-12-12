import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/component/bottom/next_button.dart';
import 'package:sponge_app/component/top/write_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/gender.dart';
import 'package:sponge_app/data/pet/pet.dart';
import 'package:sponge_app/screen/write/select_category.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class SelectPet extends StatefulWidget {
  final List<Pet> petList;

  SelectPet({super.key, required this.petList});

  @override
  State<SelectPet> createState() => _SelectPetState();
}

class _SelectPetState extends State<SelectPet> {
  int _selectedIndex = 0;
  Pet? pet;

  @override
  void initState() {
    super.initState();
    pet = widget.petList.length != 0 ? widget.petList[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    bool enabledNext = widget.petList.length != 0 ? true : false;
    return Scaffold(
      appBar: AppBar(
        title: WriteTop(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: NextButton(
        enabled: enabledNext,
        nextPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectCategory(
                pet: pet!,
                selectedCategoryIndexList: {},
              ),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WriteProgress(
                progressIndex: 1,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '문제행동 교정이 필요한',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Text(
                '강아지를 선택해주세요',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              if (widget.petList.length == 0) ...[
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<PageIndexProvider>(context, listen: false)
                        .updateIndex(3);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: AddPetComponent(),
                ),
              ],
              if (widget.petList.length != 0) ...[
                ...widget.petList.asMap().entries.map((entry) {
                  int index = entry.key; // 현재 인덱스
                  Pet pet = entry.value;
                  return Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            this.pet = pet;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: _selectedIndex == index
                                ? lightYellow
                                : lightGrey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              pet.petImgUrl == ''
                                  ? Image.asset('asset/img/basic_pet.png',
                                      width: 80)
                                  : Image.network(pet.petImgUrl, width: 80),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        pet.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    pet.breed,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: mediumGrey,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${Gender.getDescriptionByCode(pet.gender)}ㆍ${pet.age}살ㆍ${pet.weight}kg',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: mediumGrey,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: _selectedIndex == index
                                      ? mainYellow
                                      : checkGrey,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class WriteProgress extends StatelessWidget {
  TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 16);
  final int progressIndex;
  List<int> indexList = [1, 2, 3];

  WriteProgress({super.key, required this.progressIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...indexList
            .map(
              (index) => Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: index <= progressIndex
                          ? mainYellow
                          : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        index.toString(),
                        style: textStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                ],
              ),
            )
            .toList()
      ],
    );
  }
}

class AddPetComponent extends StatelessWidget {
  const AddPetComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: mainGrey,
      strokeWidth: 1,
      dashPattern: [6, 3],
      borderType: BorderType.RRect,
      radius: Radius.circular(12),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: checkGrey,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28 * 0.6, // 아이콘 크기 비율
                  ),
                ),
              ),
              Text(
                '강아지 추가하기',
                style: TextStyle(
                  color: darkGrey,
                  fontSize: 16,
                ),
              ),
              Text(
                '등록된 강아지가 없어요.',
                style: TextStyle(
                    color: mainGrey, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
