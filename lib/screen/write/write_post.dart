import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/component/top/write_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/gender.dart';
import 'package:sponge_app/data/pet/pet.dart';
import 'package:sponge_app/data/post/post.dart';
import 'package:sponge_app/data/post/post_create.dart';
import 'package:sponge_app/data/post/post_update.dart';
import 'package:sponge_app/request/post_request.dart';
import 'package:sponge_app/screen/post_screen.dart';
import 'package:sponge_app/screen/write/select_pet.dart';
import 'package:sponge_app/screen/write/write_modal.dart';
import 'package:sponge_app/util/file_storage.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class WritePost extends StatefulWidget {
  final Pet pet;
  final List<int> categoryCodeList;
  final PostResponse? post;

  WritePost(
      {super.key,
      required this.pet,
      required this.categoryCodeList,
      required this.post});

  @override
  State<WritePost> createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  late TextEditingController _titleController;
  late TextEditingController _contentController = TextEditingController();
  late TextEditingController _durationController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  bool enabled = false;
  List<String> _hashTagList = []; // 완성된 태그 목록
  List<String> _fileList = [];
  bool _hasHashtag = false;
  bool isLoading = true;
  File? petImage = null;

  @override
  void initState() {
    super.initState();
    _hashTagList = widget.post?.tagList != null
        ? widget.post!.tagList.map((tag) => tag.hashtag).toList()
        : [];
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _contentController =
        TextEditingController(text: widget.post?.content ?? '');
    _durationController =
        TextEditingController(text: widget.post?.duration ?? '');
    // 입력값 변경 모니터링
    _titleController.addListener(_updateButtonState);
    _contentController.addListener(_updateButtonState);
    _durationController.addListener(_updateButtonState);
    _getImageFile();
  }

  void _getImageFile() async {
    if (widget.pet.petImgUrl != "")
      petImage = await getSavedPetImage(widget.pet.id);
    setState(() {
      // 이미지캐시 삭제
      imageCache.clear();
      imageCache.clearLiveImages();
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _titleController.dispose();
    _contentController.dispose();
    _durationController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      // 모든 TextField가 입력되었는지 확인
      enabled = _titleController.text.isNotEmpty &&
          _contentController.text.isNotEmpty &&
          _durationController.text.isNotEmpty;
    });
  }

  void _onTagChanged(String value) {
    if (!_hasHashtag) {
      // 태그 시작: '#' 입력 시
      if (value == "#") {
        _hasHashtag = true;
      } else {
        _tagController.clear(); // '#' 없이 입력된 텍스트는 지우기
      }
    } else {
      // '#' 이후에는 공백을 허용하지 않음
      if (value.contains(" ")) {
        // 띄어쓰기 입력 방지 (공백 뒤에 태그를 완료 처리)
        final trimmedValue = value.trim(); // 공백 제거
        if (trimmedValue.isNotEmpty && trimmedValue != '#') {
          _completeTag(trimmedValue);
        } else {
          _tagController.clear(); // 공백 입력 방지
        }
      } else if (value.isEmpty || value[0] != "#") {
        // '#'이 없는 경우 초기화
        _hasHashtag = false;
        _tagController.clear();
      }
    }

    setState(() {});
  }

  // Done 버튼을 눌렀을 때 태그로 추가하기
  void _onDone() {
    final tag = _tagController.text.trim();

    if (tag.isNotEmpty && tag[0] == "#") {
      _completeTag(tag); // 태그 완료
    }
  }

  void _completeTag(String tag) {
    // 태그를 추가하고 입력 필드를 초기화
    _hasHashtag = false;
    _tagController.clear();

    // 태그를 화면에 표시하는 로직 추가
    setState(() {
      _hashTagList.add(tag); // 태그 리스트에 추가
    });
  }

  void _deleteTag(String tag) {
    setState(() {
      _hashTagList.remove(tag); // 태그 삭제
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w700);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: WriteTop(),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: OutlinedButton(
              onPressed: enabled
                  ? () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          if (widget.post == null) {
                            return WriteModal(
                              titleText: '작성한 글을 등록 하시겠어요?',
                              completeText: '등록',
                              completePost: () async {
                                PostCreate postCreate = new PostCreate(
                                    petId: widget.pet.id,
                                    title: _titleController.text,
                                    content: _contentController.text,
                                    duration: _durationController.text,
                                    fileUrlList: _fileList,
                                    hashTagList: _hashTagList
                                        .map((tag) => tag.substring(1))
                                        .toList(),
                                    categoryCodeList: widget.categoryCodeList);
                                await createPost(postCreate);
                                Provider.of<PageIndexProvider>(context,
                                        listen: false)
                                    .updateIndex(1);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  (Route<dynamic> route) => false,
                                );
                              },
                            );
                          } else {
                            return WriteModal(
                              titleText: '작성한 글을 수정 하시겠어요?',
                              completeText: '수정',
                              completePost: () async {
                                PostUpdate postUpdate = new PostUpdate(
                                    title: _titleController.text,
                                    content: _contentController.text,
                                    duration: _durationController.text,
                                    fileUrlList: _fileList,
                                    hashTagList: _hashTagList
                                        .map((tag) => tag.substring(1))
                                        .toList(),
                                    categoryCodeList: widget.categoryCodeList);
                                await updatePost(widget.post!.id, postUpdate);
                                Provider.of<PageIndexProvider>(context,
                                        listen: false)
                                    .updateIndex(1);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  (Route<dynamic> route) => false,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PostScreen(id: widget.post!.id),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  : null,
              style: OutlinedButton.styleFrom(
                backgroundColor: enabled ? mainYellow : lightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                side: BorderSide.none,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                '완료',
                style: TextStyle(
                  color: enabled ? Colors.white : mainGrey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WriteProgress(progressIndex: 3),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '문제행동에 해당되는',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Text(
                  '내용을 작성해주세요',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.pet.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                widget.pet.breed,
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
                                Gender.getDescriptionByCode(widget.pet.gender),
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
                                '${widget.pet.age}살',
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
                                '${widget.pet.weight}kg',
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
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      '제목',
                      style: textStyle,
                    ),
                    _RequiredStar(),
                  ],
                ),
                _CustomTextFiled(
                    text: 'ex) 외출 시 강아지 짖음이 너무 심해요',
                    controller: _titleController),
                SizedBox(
                  height: 16,
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
                      hintText: '강아지가 주로 행동하는 시간,장소,공간등의 내용을 구체적으로 작성해보세요.',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: mainGrey,
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      '문제 행동 지속기간',
                      style: textStyle,
                    ),
                    _RequiredStar(),
                  ],
                ),
                _CustomTextFiled(
                    text: 'ex) 1년 미만, 모름', controller: _durationController),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      '파일 업로드',
                      style: textStyle,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '(선택 사항)',
                      style: TextStyle(color: checkGrey, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                DottedBorder(
                  color: mainGrey,
                  strokeWidth: 1,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: checkGrey,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 25 * 0.6, // 아이콘 크기 비율
                              ),
                            ),
                          ),
                          Text(
                            '사진이나 동영상을 첨부해주세요',
                            style: TextStyle(
                              color: mainGrey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  '태그',
                  style: textStyle,
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _hashTagList
                      .map(
                        (tag) => GestureDetector(
                          onTap: () => _deleteTag(tag), // 태그 클릭 시 삭제
                          child: _buildTagChip(tag),
                        ),
                      )
                      .toList(),
                ),
                TextField(
                  controller: _tagController,
                  onChanged: _onTagChanged,
                  onEditingComplete: _onDone,
                  cursorColor: mainYellow,
                  decoration: InputDecoration(
                    hintText: 'ex) #성격 #상황',
                    hintStyle: TextStyle(color: mainGrey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: lightGrey, width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainGrey, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: mainYellow, // 배경색
        borderRadius: BorderRadius.circular(16), // 둥근 테두리
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.close, // 닫기 아이콘
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _RequiredStar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '*',
      style: TextStyle(
        color: Colors.red,
        fontSize: 16, // 원하는 크기로 설정
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _CustomTextFiled extends StatelessWidget {
  final text;
  final TextEditingController controller;

  const _CustomTextFiled(
      {super.key, required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: mainYellow,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: TextStyle(
          color: mainGrey,
        ),
        focusColor: mainGrey,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: lightGrey, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainGrey, width: 1),
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
