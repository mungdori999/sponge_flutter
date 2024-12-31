import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/request/post_request.dart';

class PostLikeButton extends StatefulWidget {
  final int postId;
  final String loginType;
  int likeCount;
  bool flag;

  PostLikeButton({super.key, required this.postId, required this.likeCount,required this.flag, required this.loginType});

  @override
  State<PostLikeButton> createState() => _PostLikeButtonState();
}

class _PostLikeButtonState extends State<PostLikeButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        if(widget.loginType == LoginType.USER.value) {
          await updatePostLike(widget.postId);
          setState(() {
            widget.flag ? widget.likeCount-- : widget.likeCount++;
            widget.flag = !widget.flag;
          });
        }
        else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('주의'),
                  content: Text('견주 로그인이 필요합니다.'),
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
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: widget.flag ? mainYellow : lightGrey, // 테두리 색상
          width: 1, // 테두리 두께
        ),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.flag ? Icons.thumb_up : Icons.thumb_up_outlined,
            size: 16,
            color: widget.flag ? mainYellow : mainGrey,
          ),
          SizedBox(width: 4),
          Text(
            widget.likeCount.toString(),
            style: TextStyle(
              fontSize: 14,
              color: widget.flag ? mainYellow : mainGrey,
            ),
          ),
        ],
      ),
    );
  }
}
