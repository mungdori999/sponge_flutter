import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/answer/answer_check_response.dart';
import 'package:sponge_app/request/answer_reqeust.dart';

class AnswerLikeButton extends StatefulWidget {
  final int answerId;
  final String loginType;
  int likeCount;

  AnswerLikeButton(
      {super.key,
      required this.loginType,
      required this.likeCount,
      required this.answerId});

  @override
  State<AnswerLikeButton> createState() => _AnswerLikeButtonState();
}

class _AnswerLikeButtonState extends State<AnswerLikeButton> {
  bool flag = false;

  @override
  void initState() {
    super.initState();
    if (widget.loginType == LoginType.USER.value) {
      _initData();
    }
  }

  _initData() async {
    AnswerCheckResponse answerCheckResponse =
        await getMyAnswerCheck(widget.answerId);
    setState(() {
      flag = answerCheckResponse.likeCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (widget.loginType == LoginType.USER.value) {
          await updateAnswerLike(widget.answerId);
          setState(() {
            flag ? widget.likeCount-- : widget.likeCount++;
            flag = !flag;
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('주의'),
                  content: Text('견주 로그인이 필요합니다.'),
                  backgroundColor: Colors.white,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('닫기'),
                    ),
                  ],
                );
              },
            );
          });
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 4,
          ),
          Icon(
            Icons.thumb_up_outlined,
            color: flag ? mainYellow : mainGrey,
            size: 16,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            '추천 ${widget.likeCount}',
            style: TextStyle(color: flag ? mainYellow : mainGrey),
          )
        ],
      ),
    );
  }
}
