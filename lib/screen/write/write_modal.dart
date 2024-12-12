import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';

class WriteModal extends StatelessWidget {
  final VoidCallback completePost;
  final String titleText;
  final String completeText;

  const WriteModal({super.key, required this.completePost, required this.titleText, required this.completeText, });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              titleText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '작성한 내용을 바탕으로 진단받을 수 있으며,',
              style: TextStyle(
                  fontSize: 16, color: mainGrey, fontWeight: FontWeight.bold),
            ),
            Text(
              '게시글이 올라간 뒤에도 수정할 수 있어요.',
              style: TextStyle(
                  fontSize: 16, color: mainGrey, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed:(){
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: lightYellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  side: BorderSide.none,
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  '닫기',
                  style: TextStyle(
                    color: mainYellow,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: completePost,
                style: OutlinedButton.styleFrom(
                  backgroundColor: mainYellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  side: BorderSide.none,
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  completeText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
