import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Image.asset('asset/img/basic_pet.png', width: 40),
                  ],
                ),
                SizedBox(width: 12,),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "강훈련 훈련사님",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Text(
                      "임시 채팅입니다",
                      style: TextStyle(
                        color: mainGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Text(
              "오후 5:30",
              style: TextStyle(
                color: mainGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
