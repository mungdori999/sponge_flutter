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
import 'package:sponge_app/screen/answer/update_answer.dart';
import 'package:sponge_app/screen/post_screen.dart';
import 'package:sponge_app/screen/trainer/trainer_individual_profile.dart';
import 'package:sponge_app/util/convert.dart';

class AnswerDetails extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: answer.checkAdopt ? lightYellow : lightGrey,
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
                            id: answer.trainerShortResponse.id,
                            loginAuth: loginAuth,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 44, // 이미지의 너비
                          height: 44, // 이미지의 높이
                          child: ClipOval(
                            child: answer.trainerShortResponse.profileImgUrl ==
                                    ''
                                ? Container(
                                    width: 70, // 동그라미의 너비
                                    height: 70, // 동그라미의 높이
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300], // 회색 배경색
                                      shape: BoxShape.circle, // 동그라미 형태
                                    ),
                                    child: Icon(
                                      Icons.person, // 사람 모양 아이콘
                                      color: Colors.white, // 아이콘 색상
                                      size: 30, // 아이콘 크기
                                    ),
                                  )
                                : Image.network(
                                    answer.trainerShortResponse.profileImgUrl,
                                    fit: BoxFit.cover, // 이미지 크기 조정
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${answer.trainerShortResponse.name} 훈련사님',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Row(
                              children: [
                                Text(
                                  '채택된 답변 ${answer.trainerShortResponse.adoptCount}건',
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
                                  '1:1상담 ${answer.trainerShortResponse.chatCount}회',
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
                  if (loginAuth.loginType == LoginType.USER.value &&
                      loginAuth.id == post.userId)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!answer.checkAdopt)
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
                                                    AdoptAnswerCreate
                                                        adoptAnswerCreate =
                                                        new AdoptAnswerCreate(
                                                            answerId: answer
                                                                .answerResponse
                                                                .id,
                                                            trainerId: answer
                                                                .trainerShortResponse
                                                                .id,
                                                            postId: answer
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
                                                                id: answer
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
                          width: answer.checkAdopt
                              ? MediaQuery.of(context).size.width / 1.2
                              : MediaQuery.of(context).size.width / 2.5,
                          child: ElevatedButton(
                            onPressed: () async {
                              createChatRoom(new ChatRoomCreate(
                                  trainerId: answer.trainerShortResponse.id));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: answer.checkAdopt
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
          if (answer.checkAdopt) ...[
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
            answer.answerResponse.content,
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
                answerId: answer.answerResponse.id,
                loginType: loginAuth.loginType,
                likeCount: answer.answerResponse.likeCount,
                flag: answer.answerCheckResponse.likeCheck,
              ),
              Row(
                children: [
                  Text(
                    Convert.convertTimeAgo(answer.answerResponse.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: mainGrey,
                    ),
                  ),
                  if (loginAuth.loginType == LoginType.TRAINER.value &&
                      loginAuth.id == answer.trainerShortResponse.id)
                    PopupMenuButton(
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateAnswer(
                                post: post,
                                answer: answer,
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
                                          onPressed: deleteButton,
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
