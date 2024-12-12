import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/screen/register_pet.dart';

class AddPet extends StatelessWidget {
  const AddPet({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPet(),
        ),
      ),
      child: DottedBorder(
        color: mainGrey,
        strokeWidth: 1,
        dashPattern: [6, 3],
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: mainYellow,
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
                  '나의 반려견을 소개해주세요!',
                  style: TextStyle(
                    color: mainGrey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '프로필 작성하기',
                  style: TextStyle(
                      color: mainYellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
