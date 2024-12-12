import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/request/post_request.dart';

class LikeButton extends StatefulWidget {
  final int postId;
  int likeCount;
  bool flag;

  LikeButton({super.key, required this.postId, required this.likeCount,required this.flag});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await updateLike(widget.postId);
        setState(() {
          widget.flag ? widget.likeCount-- : widget.likeCount++;
          widget.flag = !widget.flag;
        });
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
