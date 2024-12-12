import 'package:flutter/material.dart';
import 'package:sponge_app/const/category_code.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/post/post_list_response.dart';
import 'package:sponge_app/util/convert.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ...post.postCategoryList.map((postCategory){
              final description = CategoryCode.getDescriptionByCode(postCategory.categoryCode);
              return
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: lightYellow,
                      ),
                      child: Text(
                        '# $description',
                        style: TextStyle(
                          color: mainYellow,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                );
            }).toList(),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          post.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4,),
        Text(
          post.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: mainGrey,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Row(
              children: [
                Icon(
                  Icons.comment,
                  color: mainYellow,
                  size: 16,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '훈련사 답변 ${post.answerCount}',
                  style: TextStyle(
                    color: mainYellow,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 0.5,
                  height: 12,
                  color: mainGrey,
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
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
                    '추천 ${post.likeCount}',
                    style: TextStyle(
                      color: mainGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              Convert.convertTimeAgo(post.createdAt),
              style: TextStyle(color: mediumGrey, fontSize: 12),
            ),
          ],
        ),
        SizedBox(height: 16,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
