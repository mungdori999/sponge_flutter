import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sponge_app/component/answer/answer_like_button.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/answer/adopt_answer_create.dart';
import 'package:sponge_app/data/answer/answer_response.dart';
import 'package:sponge_app/data/chat/chat_room_create.dart';
import 'package:sponge_app/data/post/post.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/request/answer_reqeust.dart';
import 'package:sponge_app/request/chat_room_request.dart';
import 'package:sponge_app/request/trainer_img_reqeust.dart';
import 'package:sponge_app/screen/answer/update_answer.dart';
import 'package:sponge_app/screen/post_screen.dart';
import 'package:sponge_app/screen/trainer/trainer_individual_profile.dart';
import 'package:sponge_app/util/convert.dart';

class AnswerDetails extends StatefulWidget {
  final AnswerDetailsListResponse answer;
  final LoginAuth loginAuth;
  final VoidCallback deleteButton;
  final PostResponse post;

  const AnswerDetails(
      {super.key,
      required this.answer,
      required this.loginAuth,
      required this.deleteButton,
      required this.post});

  @override
  State<AnswerDetails> createState() => _AnswerDetailsState();
}

class _AnswerDetailsState extends State<AnswerDetails> {
  bool isLoading = true;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _getImageFile();
  }

  void _getImageFile() async {
    if (widget.post.pet.petImgUrl != "")
      imageBytes = await getOtherTrainerImg(
          widget.answer.trainerShortResponse.profileImgUrl);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.answer.checkAdopt ? lightYellow : lightGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainerIndividualProfile(
                            id: widget.answer.trainerShortResponse.id,
                            loginAuth: widget.loginAuth,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        if (!isLoading) ...[
                          ClipOval(
                            child: Container(
                              width: 44, // 동그라미의 너비
                              height: 44, // 동그라미의 높이
                              decoration: BoxDecoration(
                                color: Colors.white, // 회색 배경색
                                shape: BoxShape.circle,
                                image: imageBytes != null
                                    ? DecorationImage(
                                        image: MemoryImage(imageBytes!),
                                        fit: BoxFit.cover,
                                      )
                                    : null, // 동그라미 형태
                              ),
                              child: imageBytes == null
                                  ? Icon(
                                      Icons.person,
                                      color: mainGrey,
                                      size: 30,
                                    )
                                  : null,
                            ),
                          ),
                        ] else ...[
                          ClipOval(
                            child: Container(
                              width: 44,
                              height: 44,
                              color: lightGrey,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: mainGrey, // 로딩바 색상
                                  strokeWidth: 3.0, // 로딩바 두께
                                ),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.answer.trainerShortResponse.name} 훈련사님',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                Text(
                                  '채택된 답변 ${widget.answer.trainerShortResponse.adoptCount}건',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: mediumGrey,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '|',
                                  style:
                                      TextStyle(color: mainGrey, fontSize: 12),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '1:1상담 ${widget.answer.trainerShortResponse.chatCount}회',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: mediumGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  if (widget.loginAuth.loginType == LoginType.USER.value &&
                      widget.loginAuth.id == widget.post.userId)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!widget.answer.checkAdopt)
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "선택한 답변을 채택하시겠어요?",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                "답변이 도움이 되었나요?",
                                                style: TextStyle(
                                                  color: mediumGrey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                "답변 채택 시 훈련사에게 큰 도움이 될 수 있어요.",
                                                style: TextStyle(
                                                  color: mediumGrey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        lightYellow,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                    side: BorderSide.none,
                                                    minimumSize: Size(
                                                        double.infinity, 48),
                                                  ),
                                                  child: Text(
                                                    '닫기',
                                                    style: TextStyle(
                                                        color: mainYellow,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: OutlinedButton(
                                                  onPressed: () async {
                                                    AdoptAnswerCreate adoptAnswerCreate =
                                                        new AdoptAnswerCreate(
                                                            answerId: widget
                                                                .answer
                                                                .answerResponse
                                                                .id,
                                                            trainerId: widget
                                                                .answer
                                                                .trainerShortResponse
                                                                .id,
                                                            postId: widget
                                                                .answer
                                                                .answerResponse
                                                                .postId);
                                                    await createAdoptAnswer(
                                                        adoptAnswerCreate);
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                      context,
                                                      '/',
                                                      // 초기 화면으로 이동 (모든 스택 제거)
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    );
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PostScreen(
                                                                id: widget
                                                                    .answer
                                                                    .answerResponse
                                                                    .postId),
                                                      ),
                                                    );
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    backgroundColor: mainYellow,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                    side: BorderSide.none,
                                                    minimumSize: Size(
                                                        double.infinity, 48),
                                                  ),
                                                  child: Text(
                                                    '채택하기',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonGrey, // 배경색 설정
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // 모서리 둥글게 설정
                                ),
                                elevation: 0, // 그림자 제거
                              ),
                              child: Text(
                                '답변채택하기',
                                style: TextStyle(
                                  color: Colors.white, // 텍스트 색상 설정
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: widget.answer.checkAdopt
                              ? MediaQuery.of(context).size.width / 1.2
                              : MediaQuery.of(context).size.width / 2.5,
                          child: ElevatedButton(
                            onPressed: () async {
                              createChatRoom(new ChatRoomCreate(
                                  trainerId:
                                      widget.answer.trainerShortResponse.id));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.answer.checkAdopt
                                  ? mainYellow
                                  : buttonGrey, // 배경색 설정
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // 모서리 둥글게 설정
                              ),
                              elevation: 0, // 그림자 제거
                            ),
                            child: Text(
                              '1:1채팅하기',
                              style: TextStyle(
                                color: Colors.white, // 텍스트 색상 설정
                                fontWeight: FontWeight.w700,
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
          if (widget.answer.checkAdopt) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: mainYellow,
              ),
              child: Text(
                '채택한 답변',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
          Text(
            widget.answer.answerResponse.content,
            style: TextStyle(
              color: darkGrey,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnswerLikeButton(
                answerId: widget.answer.answerResponse.id,
                loginType: widget.loginAuth.loginType,
                likeCount: widget.answer.answerResponse.likeCount,
                flag: widget.answer.answerCheckResponse.likeCheck,
              ),
              Row(
                children: [
                  Text(
                    Convert.convertTimeAgo(
                        widget.answer.answerResponse.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: mainGrey,
                    ),
                  ),
                  if (widget.loginAuth.loginType == LoginType.TRAINER.value &&
                      widget.loginAuth.id ==
                          widget.answer.trainerShortResponse.id)
                    PopupMenuButton(
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateAnswer(
                                post: widget.post,
                                answer: widget.answer,
                              ),
                            ),
                          );
                        } else if (value == 2) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  '선택한 답변을 삭제하시겠어요?',
                                  textAlign: TextAlign.center,
                                ),
                                titleTextStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: ElevatedButton(
                                          onPressed: widget.deleteButton,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: mainYellow,
                                            // 배경색 설정
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      16), // 모서리 둥글게 설정
                                            ),
                                            elevation: 0, // 그림자 제거
                                          ),
                                          child: Text(
                                            '네',
                                            style: TextStyle(
                                              color: Colors.white, // 텍스트 색상 설정
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                lightYellow, // 배경색 설정
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      16), // 모서리 둥글게 설정
                                            ),
                                            elevation: 0, // 그림자 제거
                                          ),
                                          child: Text(
                                            '아니오',
                                            style: TextStyle(
                                              color: mainYellow, // 텍스트 색상 설정
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Text('답변 수정'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Text('답변 삭제'),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
