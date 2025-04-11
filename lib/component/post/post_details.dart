import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sponge_app/component/post/bookmark_button.dart';
import 'package:sponge_app/component/post/post_like_button.dart';
import 'package:sponge_app/const/category_code.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/gender.dart';
import 'package:sponge_app/data/post/post_check_response.dart';
import 'package:sponge_app/data/post/post.dart';
import 'package:sponge_app/request/post_request.dart';
import 'package:sponge_app/screen/user/user_individual_profile.dart';
import 'package:sponge_app/screen/write/select_category.dart';
import 'package:sponge_app/util/convert.dart';
import 'package:sponge_app/util/file_storage.dart';

class PostDetails extends StatefulWidget {
  final PostResponse post;
  final bool myPost;
  final PostCheckResponse check;
  final String loginType;

  const PostDetails(
      {super.key,
      required this.post,
      required this.myPost,
      required this.check,
      required this.loginType});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  bool isLoading = true;
  File? petImage = null;

  @override
  void initState() {
    super.initState();
    _getImageFile();
  }

  void _getImageFile() async {
    if (widget.post.pet.petImgUrl != "")
      petImage = await getSavedPetImage(widget.post.pet.id);
    setState(() {
      // 이미지캐시 삭제
      imageCache.clear();
      imageCache.clearLiveImages();
      isLoading = false;
    });
  }

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
              ...widget.post.postCategoryList.map((postCategory) {
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
            widget.post.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserIndividualProfile(
                    id: widget.post.userId,
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
                        color: lightGrey, // 회색 배경색
                        shape: BoxShape.circle,
                        image: petImage != null
                            ? DecorationImage(
                                image: FileImage(petImage!),
                                fit: BoxFit.cover,
                              )
                            : null, // 동그라미 형태
                      ),
                      child: petImage == null
                          ? Icon(
                              Icons.pets,
                              color: mainGrey,
                              size: 20,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.pet.name,
                        style:
                            TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Row(
                          children: [
                            Text(
                              widget.post.pet.breed,
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
                              Gender.getDescriptionByCode(widget.post.pet.gender),
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
                              '${widget.post.pet.age}살',
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
                              '${widget.post.pet.weight}kg',
                              style: TextStyle(
                                fontSize: 12,
                                color: mainGrey,
                              ),
                            ),
                            Spacer(),
                            Text(
                              Convert.convertTimeAgo(widget.post.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: mainGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
            widget.post.content,
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
              ...widget.post.tagList.map((tag) {
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
                    postId: widget.post.id,
                    likeCount: widget.post.likeCount,
                    flag: widget.check.likeCheck,
                    loginType: widget.loginType,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  BookmarkButton(
                    postId: widget.post.id,
                    flag: widget.check.bookmarkCheck,
                    loginType: widget.loginType,
                  ),
                ],
              ),
              if (widget.myPost)
                PopupMenuButton(
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectCategory(
                            pet: widget.post.pet,
                            selectedCategoryIndexList: widget
                                .post.postCategoryList
                                .map((category) => category.categoryCode)
                                .toSet(),
                            post: widget.post,
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
                                          await deletePost(widget.post.id);
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
