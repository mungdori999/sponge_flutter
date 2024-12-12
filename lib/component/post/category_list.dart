import 'package:flutter/material.dart';
import 'package:sponge_app/const/category_code.dart';
import 'package:sponge_app/const/color_const.dart';

class CategoryList extends StatelessWidget {
  final Function(int) categoryPressed;
  final List<String> categoryList;
  final int selectedIndex;

  const CategoryList(
      {super.key,
      required this.categoryPressed,
      required this.categoryList,
      required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // 고정된 높이 설정
      child: ListView(
        physics: PageScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: categoryList
            .asMap()
            .map(
              (index, e) {
                bool isSelected = index == selectedIndex;
                return MapEntry(
                  index,
                  TextButton(
                    onPressed: () => categoryPressed(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              e,
                              style: TextStyle(
                                color: isSelected ? mainYellow : mainGrey,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            if (isSelected)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: mainYellow,
                                ),
                                height: 3,
                                width: e.length * 15,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
            .values
            .toList(), // 값을 List로 변환
      ),
    );
  }
}
