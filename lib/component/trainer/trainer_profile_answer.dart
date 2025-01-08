import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/answer/answer_response.dart';
import 'package:sponge_app/screen/post_screen.dart';
import 'package:sponge_app/util/convert.dart';

class TrainerProfileAnswer extends StatelessWidget {
  final List<AnswerBasicListResponse> answerList;

  const TrainerProfileAnswer({super.key, required this.answerList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...answerList
            .map(
              (answer) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PostScreen(id: answer.answerResponse.postId),
                  ),
                ),
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    answer.checkAdopt ? lightYellow : lightGrey,
                              ),
                              child: Text(
                                answer.checkAdopt ? '채택됌' : '채택 안됌',
                                style: TextStyle(
                                  color:
                                      answer.checkAdopt ? mainYellow : mainGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              answer.answerResponse.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.thumb_up_outlined,
                                        color: mainGrey,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '추천 ${answer.answerResponse.likeCount}',
                                        style: TextStyle(
                                          color: mainGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  Convert.convertTimeAgo(
                                      answer.answerResponse.createdAt),
                                  style: TextStyle(
                                      color: mediumGrey, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
