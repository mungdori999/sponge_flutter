class PostCreate {
  final int petId;
  final String title;
  final String content;
  final String duration;
  List<String> fileUrlList = [];
  List<String> hashTagList = [];
  List<int> categoryCodeList = [];

  PostCreate(
      {required this.petId,
      required this.title,
      required this.content,
      required this.duration,
      required this.fileUrlList,
      required this.hashTagList,
      required this.categoryCodeList});

  Map<String, dynamic> toJson() {
    return {
      'petId': petId,
      'title': title,
      'content': content,
      'duration': duration,
      'fileUrlList': fileUrlList.isEmpty ? [] : fileUrlList,
      'hashTagList': hashTagList.isEmpty ? [] : hashTagList,
      'categoryCodeList': categoryCodeList.isEmpty ? [] : categoryCodeList,
    };
  }
}
