import 'package:sponge_app/data/pet/pet.dart';

class PostResponse {
  final int id;
  final String title;
  final String content;
  final String duration;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int likeCount;
  final int answerCount;
  final int userId;
  final Pet pet;
  final List<PostFile> postFileList;
  final List<Tag> tagList;
  final List<PostCategory> postCategoryList;

  PostResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.duration,
    required this.createdAt,
    required this.modifiedAt,
    required this.likeCount,
    required this.answerCount,
    required this.userId,
    required this.pet,
    required this.postFileList,
    required this.tagList,
    required this.postCategoryList,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      likeCount: json['likeCount'],
      answerCount: json['answerCount'],
      userId: json['userId'],
      pet: Pet.fromJson(json['pet']),
      postFileList: (json['postFileList'] as List)
          .map((file) => PostFile.fromJson(file))
          .toList(),
      tagList: (json['tagList'] as List)
          .map((tag) => Tag.fromJson(tag))
          .toList(),
      postCategoryList: (json['postCategoryList'] as List)
          .map((category) => PostCategory.fromJson(category))
          .toList(),
    );
  }
}

class PostFile {
  final int id;
  final String fileUrl;

  PostFile({
    required this.id,
    required this.fileUrl,
  });

  factory PostFile.fromJson(Map<String, dynamic> json) {
    return PostFile(
      id: json['id'],
      fileUrl: json['fileUrl'],
    );
  }
}

class Tag {
  final int id;
  final String hashtag;

  Tag({
    required this.id,
    required this.hashtag,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      hashtag: json['hashtag'],
    );
  }
}

class PostCategory {
  final int id;
  final int categoryCode;

  PostCategory({
    required this.id,
    required this.categoryCode,
  });

  factory PostCategory.fromJson(Map<String, dynamic> json) {
    return PostCategory(
      id: json['id'],
      categoryCode: json['categoryCode'],
    );
  }
}
