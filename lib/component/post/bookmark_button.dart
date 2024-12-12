import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/request/post_request.dart';

class BookmarkButton extends StatefulWidget {
  final int postId;
  bool flag;

  BookmarkButton({super.key, required this.postId,required this.flag});

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await updateBookmark(widget.postId);
        setState(() {
          widget.flag = !widget.flag;
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 모서리 둥글기 설정
        ),
        side: BorderSide(
          color: widget.flag ? mainYellow : lightGrey, // 테두리 색상
          width: 1, // 테두리 두께
        ),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4), // 내부 여백 조정
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 내부 요소 크기만큼 버튼 크기 설정
        children: [
          Icon(
            widget.flag ? Icons.bookmark_add : Icons.bookmark_add_outlined,
            size: 16,
            color: widget.flag ? mainYellow : mainGrey,
          ), // 아이콘 크기 조정
          SizedBox(width: 4), // 아이콘과 텍스트 사이 간격
          Text(
            "저장",
            style: TextStyle(
              fontSize: 14,
              color: widget.flag ? mainYellow : mainGrey,
            ), // 텍스트 크기 조정
          ),
        ],
      ),
    );
  }
}
