import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/const/category_code.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/gender.dart';
import 'package:sponge_app/data/answer/answer_create.dart';
import 'package:sponge_app/data/post/post.dart';
import 'package:sponge_app/request/answer_reqeust.dart';
import 'package:sponge_app/screen/post_screen.dart';
import 'package:sponge_app/util/convert.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class WriteAnswer extends StatefulWidget {
  final PostResponse post;

  const WriteAnswer({super.key, required this.post});

  @override
  State<WriteAnswer> createState() => _WriteAnswerState();
}

class _WriteAnswerState extends State<WriteAnswer> {
  late TextEditingController _contentController = TextEditingController();
  bool showMore = false;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      // 모든 TextField가 입력되었는지 확인
      enabled = _contentController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: enabled
                    ? () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text(
                                '답변을 등록하시겠습니까?',
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
                                        onPressed: () async {
                                          AnswerCreate answerCreate =
                                              new AnswerCreate(
                                                  postId: widget.post.id,
                                                  content:
                                                      _contentController.text);
                                          await createAnswer(answerCreate);
                                          // 첫 번째: 모든 페이지를 제거하고 초기 화면으로 이동
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/', // 초기 화면으로 이동 (모든 스택 제거)
                                                (Route<dynamic> route) => false,
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PostScreen(id: widget.post.id),
                                            ),
                                          );

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainYellow, // 배경색 설정
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                16), // 모서리 둥글게 설정
                                          ),
                                          elevation: 0, // 그림자 제거
                                        ),
                                        child: Text(
                                          '등록',
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
                                            borderRadius: BorderRadius.circular(
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
                    : null,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: enabled ? mainYellow : lightGrey,
                    border: Border.all(
                      color: enabled ? mainYellow : lightGrey,
                      width: 1,
                    ), // 배경색 변경
                    borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                  ),
                  child: Text(
                    "답변 등록",
                    style: TextStyle(
                      color: enabled ? Colors.white : mainGrey,
                      // 텍스트 색상 변경
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close, // 'X' 아이콘
              color: Colors.black, // 아이콘 색상
            ),
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 동작
            },
          ),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...widget.post.postCategoryList.map((postCategory) {
                      final description = CategoryCode.getDescriptionByCode(
                          postCategory.categoryCode);
                      return Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
                if (!showMore)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showMore = !showMore;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 패딩 제거
                      minimumSize: Size.zero, // 최소 크기 제거
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
                    ),
                    child: Text(
                      '자세히 보기..',
                      style: TextStyle(color: mainGrey, fontSize: 14),
                    ),
                  ),
                if (showMore) ...[
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
                            widget.post.pet.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Row(
                              children: [
                                Text(
                                  widget.post.pet.breed,
                                  style:
                                      TextStyle(fontSize: 12, color: mainGrey),
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
                                  Gender.getDescriptionByCode(
                                      widget.post.pet.gender),
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
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showMore = !showMore;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 패딩 제거
                      minimumSize: Size.zero, // 최소 크기 제거
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
                    ),
                    child: Text(
                      '접기..',
                      style: TextStyle(color: mainGrey, fontSize: 14),
                    ),
                  ),
                ],
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: lightGrey,
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: lightGrey, // 배경색 설정
                    borderRadius: BorderRadius.circular(10), // 둥근 테두리
                  ),
                  padding: const EdgeInsets.all(16.0), // 내부 여백
                  child: TextField(
                    maxLines: null,
                    // 무제한 줄 입력 가능
                    controller: _contentController,
                    keyboardType: TextInputType.multiline,
                    cursorColor: mainYellow,
                    decoration: InputDecoration(
                      hintText: 'ex) 소중하고 정확한 답변을 부탁드립니다',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: mainGrey,
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
