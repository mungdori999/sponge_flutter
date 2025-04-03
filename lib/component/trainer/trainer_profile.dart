import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer.dart';
import 'package:sponge_app/util/file_storage.dart';

class TrainerProfile extends StatefulWidget {
  final Trainer trainer;

  const TrainerProfile({super.key, required this.trainer});

  @override
  State<TrainerProfile> createState() => _TrainerProfileState();
}

class _TrainerProfileState extends State<TrainerProfile> {
  File? imageFile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getImageFile();
  }

  void _getImageFile() async {
    if (widget.trainer.profileImgUrl != "") imageFile = await getSavedProfileImage();
    setState(() {
      // 이미지캐시 삭제
      imageCache.clear();
      imageCache.clearLiveImages();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String address =
        widget.trainer.trainerAddressList.map((trainerAddress) {
      return '${trainerAddress.city} ${trainerAddress.town}';
    }).join(' / ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '안녕하세요',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: mainGrey),
        ),
        Row(
          children: [
            Text(
              '훈련사',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: mainGrey),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              widget.trainer.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '입니다',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: mainGrey),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '이름',
                              style: TextStyle(fontSize: 14, color: mainGrey),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              '연차',
                              style: TextStyle(fontSize: 14, color: mainGrey),
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
                              widget.trainer.name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              '${widget.trainer.years}년차',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
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
                                    image: FileImage(imageFile!),
                                    // 선택한 이미지 표시
                                    fit: BoxFit.cover,
                                  )
                                : null, // 동그라미 형태
                          ),
                          child: imageFile == null
                              ? Icon(
                                  Icons.person, // 사람 모양 아이콘
                                  color: mainGrey, // 아이콘 색상
                                  size: 35, // 아이콘 크기
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
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '교육지역',
                      style: TextStyle(fontSize: 14, color: mainGrey),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '소개',
                      style: TextStyle(fontSize: 14, color: mainGrey),
                    ),
                    SizedBox(
                      width: 45,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          widget.trainer.content,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '리뷰',
                      style: TextStyle(fontSize: 14, color: mainGrey),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: mainYellow, size: 18),
                        Text(
                          widget.trainer.score.toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '1:1 상담',
                      style: TextStyle(fontSize: 14, color: mainGrey),
                    ),
                    Text(
                      '${widget.trainer.chatCount}건',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '채택된 답변',
                      style: TextStyle(fontSize: 14, color: mainGrey),
                    ),
                    Text(
                      '${widget.trainer.adoptCount}건',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
