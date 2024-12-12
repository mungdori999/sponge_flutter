import 'package:flutter/material.dart';
import 'package:sponge_app/component/bottom/next_button.dart';
import 'package:sponge_app/component/top/write_top.dart';
import 'package:sponge_app/const/category_code.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/pet/pet.dart';
import 'package:sponge_app/data/post/post.dart';
import 'package:sponge_app/data/post/post_update.dart';
import 'package:sponge_app/screen/write/select_pet.dart';
import 'package:sponge_app/screen/write/write_post.dart';

class SelectCategory extends StatefulWidget {
  final Pet pet;
  Set<int> selectedCategoryIndexList;
  PostResponse? post;

  SelectCategory({
    Key? key,
    required this.pet,
    this.selectedCategoryIndexList = const {},
    this.post = null,
  }) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  Map<int, String> categoryMap = CategoryCode.getAllDescription();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WriteTop(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: NextButton(
        enabled: widget.selectedCategoryIndexList.isNotEmpty,
        nextPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WritePost(
                pet: widget.pet,
                categoryCodeList: widget.selectedCategoryIndexList.toList()
                  ..sort(),
                post: widget.post,
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WriteProgress(progressIndex: 2),
            SizedBox(
              height: 16,
            ),
            Text(
              '문제행동에 해당되는',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              '내용을 선택해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 3,
                ),
                itemCount: categoryMap.keys.length,
                itemBuilder: (context, index) {
                  final customIndex = 100 + (index * 100);
                  return GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          if (widget.selectedCategoryIndexList
                              .contains(customIndex)) {
                            widget.selectedCategoryIndexList
                                .remove(customIndex); // 이미 선택된 경우 제거
                          } else {
                            widget.selectedCategoryIndexList
                                .add(customIndex); // 선택되지 않은 경우 추가
                          }
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.selectedCategoryIndexList
                                .contains(customIndex)
                            ? lightYellow
                            : lightGrey, // 선택된 항목은 노란색
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          categoryMap[index]!,
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.selectedCategoryIndexList
                                    .contains(customIndex)
                                ? mainYellow
                                : mainGrey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
