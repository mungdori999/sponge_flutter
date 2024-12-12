class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final int answerCount;
  final int userId;
  final List<PostCategoryResponse> postCategoryList;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.likeCount,
    required this.answerCount,
    required this.userId,
    required this.postCategoryList,
  });

  // JSON 데이터를 Post 객체로 변환하는 factory 생성자
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      likeCount: json['likeCount'],
      answerCount: json['answerCount'],
      userId: json['userId'],
      postCategoryList: (json['postCategoryList'] as List)
          .map((item) => PostCategoryResponse.fromJson(item))
          .toList(),
    );
  }
}

class PostCategoryResponse {
  final int id;
  final int categoryCode;

  PostCategoryResponse({
    required this.id,
    required this.categoryCode,
  });

  // JSON 데이터를 PostCategory 객체로 변환하는 factory 생성자
  factory PostCategoryResponse.fromJson(Map<String, dynamic> json) {
    return PostCategoryResponse(
      id: json['id'],
      categoryCode: json['categoryCode'],
    );
  }
}
