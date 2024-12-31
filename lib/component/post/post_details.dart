import 'package:flutter/material.dart';
import 'package:sponge_app/component/post/bookmark_button.dart';
import 'package:sponge_app/component/post/post_like_button.dart';
import 'package:sponge_app/const/category_code.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/gender.dart';
import 'package:sponge_app/data/post/check_response.dart';
import 'package:sponge_app/data/post/post.dart';
import 'package:sponge_app/request/post_request.dart';
import 'package:sponge_app/screen/write/select_category.dart';
import 'package:sponge_app/util/convert.dart';

class PostDetails extends StatelessWidget {
  final PostResponse post;
  final bool myPost;
  final CheckResponse check;
  final String loginType;

  const PostDetails({super.key, required this.post, required this.myPost, required this.check, required this.loginType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              ...post.postCategoryList.map((postCategory) {
                final description = CategoryCode.getDescriptionByCode(
                    postCategory.categoryCode);
                return Row(
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
                          fontSize: 13,
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
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                width: 44, // 이미지의 너비
                height: 44, // 이미지의 높이
                child: ClipOval(
                  child: Image.network(
                    'https://media.istockphoto.com/id/1482199015/ko/%EC%82%AC%EC%A7%84/%ED%96%89%EB%B3%B5%ED%95%9C-%EA%B0%95%EC%95%84%EC%A7%80-%EC%9B%A8%EC%9D%BC%EC%8A%A4-%EC%96%B4-%EC%BD%94%EA%B8%B0-14-%EC%A3%BC%EB%A0%B9-%EA%B0%9C%EA%B0%80-%EC%9C%99%ED%81%AC%ED%95%98%EA%B3%A0-%ED%97%90%EB%96%A1%EC%9D%B4%EA%B3%A0-%ED%9D%B0%EC%83%89%EC%97%90-%EA%B3%A0%EB%A6%BD%EB%90%98%EC%96%B4-%EC%95%89%EC%95%84-%EC%9E%88%EC%8A%B5%EB%8B%88%EB%8B%A4.jpg?s=612x612&w=0&k=20&c=vW29tbABUS2fEJvPi8gopZupfTKErCDMfeq5rrOaAME=',
                    fit: BoxFit.cover, // 이미지 크기 조정
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.pet.name,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    child: Row(
                      children: [
                        Text(
                          post.pet.breed,
                          style: TextStyle(fontSize: 12, color: mainGrey),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '·', // 가운데 점
                          style: TextStyle(
                            fontSize: 16, // 점 크기
                            color: mainGrey, // 점 색상
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          Gender.getDescriptionByCode(post.pet.gender),
                          style: TextStyle(
                            fontSize: 12,
                            color: mainGrey,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '·', // 가운데 점
                          style: TextStyle(
                            fontSize: 16, // 점 크기
                            color: mainGrey, // 점 색상
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${post.pet.age}살',
                          style: TextStyle(
                            fontSize: 12,
                            color: mainGrey,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '·', // 가운데 점
                          style: TextStyle(
                            fontSize: 16, // 점 크기
                            color: mainGrey, // 점 색상
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${post.pet.weight}kg',
                          style: TextStyle(
                            fontSize: 12,
                            color: mainGrey,
                          ),
                        ),
                        Spacer(),
                        Text(
                          Convert.convertTimeAgo(post.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: mainGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 1,
            color: lightGrey,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            post.content,
            style: TextStyle(
              color: darkGrey,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              ...post.tagList.map((tag) {
                return Row(
                  children: [
                    Text(
                      '#${tag.hashtag}',
                      style: TextStyle(
                        color: mainYellow,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                );
              }).toList()
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  PostLikeButton(
                    postId: post.id,
                    likeCount: post.likeCount,
                    flag: check.likeCheck,
                    loginType: loginType,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  BookmarkButton(
                    postId: post.id,
                    flag: check.bookmarkCheck,
                    loginType: loginType,
                  ),
                ],
              ),
              if (myPost)
                PopupMenuButton(
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectCategory(
                            pet: post.pet,
                            selectedCategoryIndexList: post.postCategoryList
                                .map((category) => category.categoryCode)
                                .toSet(),
                            post: post,
                          ),
                        ),
                      );
                    } else if (value == 2) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '정말 삭제하시겠습니까?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: BorderSide.none,
                                        ),
                                        onPressed: () async {
                                          await deletePost(post.id);
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/', // 홈 화면의 route 이름
                                            (Route<dynamic> route) =>
                                                false, // 모든 기존 화면을 제거하고 홈 화면만 남기기
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('삭제되었습니다.'),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          '삭제',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: BorderSide.none,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // 다이얼로그 닫기
                                        },
                                        child: const Text(
                                          '취소',
                                          style: TextStyle(color: mainGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                          Text('게시물 수정'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Text('게시물 삭제'),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
