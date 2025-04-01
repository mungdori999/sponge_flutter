import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';
import 'package:sponge_app/request/trainer_img_reqeust.dart';
import 'package:sponge_app/request/trainer_reqeust.dart';
import 'package:sponge_app/screen/trainer/craete/trainer_success.dart';

class ContentCreate extends StatefulWidget {
  TrainerCreate trainerCreate;
  File? imageFile;

  ContentCreate(
      {super.key, required this.trainerCreate, required this.imageFile});

  @override
  State<ContentCreate> createState() => _ContentCreateState();
}

class _ContentCreateState extends State<ContentCreate> {
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController =
        TextEditingController(text: widget.trainerCreate.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로 가기 버튼
            onPressed: () {
              widget.trainerCreate.content = _contentController.text;
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: OutlinedButton(
              onPressed: () async {
                widget.trainerCreate.content = _contentController.text;
                if (widget.imageFile != null) {
                  String profileImg = await uploadTrainerImg(widget.imageFile!);
                  widget.trainerCreate.profileImgUrl = profileImg;
                } else {
                  widget.trainerCreate.profileImgUrl = "";
                }
                await createTrainer(widget.trainerCreate);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainerSuccess(),
                  ),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '나를 소개할 수 있는',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Text(
                  '간단한 자기소개를 작성해보세요',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '자기소개',
                  style: TextStyle(
                      color: mediumGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: lightGrey, // 배경색 설정
                    borderRadius: BorderRadius.circular(10), // 둥근 테두리
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8), // 내부 여백
                  child: TextField(
                    maxLength: 100,
                    maxLines: 30,
                    controller: _contentController,
                    keyboardType: TextInputType.multiline,
                    cursorColor: mainYellow,
                    decoration: InputDecoration(
                      hintText: '간단한 자기소개를 입력하면 견주들의 신뢰를 얻는데 도움이 될 수 있어요',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: mainGrey,
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
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
