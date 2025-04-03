import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/gender.dart';
import 'package:sponge_app/data/pet/pet.dart';
import 'package:sponge_app/screen/pet/register_pet.dart';
import 'package:sponge_app/screen/pet/update_pet.dart';
import 'package:sponge_app/util/file_storage.dart';

class PetCardList extends StatefulWidget {
  final List<Pet> petList;
  final bool myPage;

  const PetCardList({super.key, required this.petList, required this.myPage});

  @override
  State<PetCardList> createState() => _PetCardListState();
}

class _PetCardListState extends State<PetCardList> {
  final PageController _controller = PageController(); // PageView 컨트롤러
  int _currentIndex = 0;
  bool isLoading = true;
  Map<int, File?> imageList = {};

  @override
  void initState() {
    super.initState();
    _getImageFile();
  }

  void _getImageFile() async {
    int sequence = 1;
    for (Pet pet in widget.petList) {
      File? image = null;
      if (pet.petImgUrl != "") {
        image = await getSavedPetImage(sequence);
      }
      imageList[sequence] = image;
      sequence++;
    }
    setState(() {
      // 이미지캐시 삭제
      imageCache.clear();
      imageCache.clearLiveImages();
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // 리소스 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              ...widget.petList.asMap().entries.map((entry) {
                int index = entry.key + 1;
                Pet pet = entry.value;
                final imageFile = imageList[index];
                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '반려견이름',
                                  style:
                                      TextStyle(fontSize: 14, color: mainGrey),
                                ),
                                Text(
                                  pet.name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: mainYellow,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            if (!isLoading) ...[
                              ClipOval(
                                child: Container(
                                  width: 80, // 동그라미의 너비
                                  height: 80, // 동그라미의 높이
                                  decoration: BoxDecoration(
                                    color: lightGrey, // 회색 배경색
                                    shape: BoxShape.circle,
                                    image: imageFile != null
                                        ? DecorationImage(
                                            image: FileImage(imageFile),
                                            fit: BoxFit.cover,
                                          )
                                        : null, // 동그라미 형태
                                  ),
                                  child: imageFile == null
                                      ? Icon(
                                          Icons.pets,
                                          color: mainGrey,
                                          size: 35,
                                        )
                                      : null,
                                ),
                              ),
                            ] else ...[
                              ClipOval(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  color: lightGrey,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: mainGrey, // 로딩바 색상
                                      strokeWidth: 3.0, // 로딩바 두께
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '견종',
                                  style: TextStyle(
                                    color: mainGrey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '기본정보',
                                  style: TextStyle(
                                    color: mainGrey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet.breed,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${Gender.getDescriptionByCode(pet.gender)} ${pet.age}살 ${pet.weight}kg',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList()
            ],
          ),
        ),
        if (widget.myPage)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePet(
                      pet: widget.petList[_currentIndex],
                      petImage: imageList[_currentIndex + 1],
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // 추가 여백 없애기
                  minimumSize: Size.zero, // 최소 크기 설정
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
                ),
                child: Text(
                  '수정하기',
                  style: TextStyle(
                    fontSize: 14,
                    color: mediumGrey,
                  ),
                ),
              ),
            ],
          ),
        if (!widget.myPage)
          SizedBox(
            height: 8,
          ),
        if (widget.petList.length > 1)
          SmoothPageIndicator(
            controller: _controller, // PageController 연결
            count: widget.petList.length, // 슬라이드 수
            effect: WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: mainYellow,
            ),
          ),
        SizedBox(
          height: 8,
        ),
        if (widget.myPage)
          OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPet(),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: mainYellow, width: 0.5),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              minimumSize: Size(0, 0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20, // 동그라미의 너비
                  height: 20, // 동그라미의 높이
                  decoration: BoxDecoration(
                    color: mainYellow, // 회색 배경색
                    shape: BoxShape.circle, // 동그라미 형태
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '반려견 추가하기',
                  style: TextStyle(
                      color: mainYellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
