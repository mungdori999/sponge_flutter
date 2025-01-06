import 'package:sponge_app/data/answer/answer_check_response.dart';

class AnswerResponse {
  final int id;
  final String content;
  final int likeCount;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int postId;
  final int trainerId;

  AnswerResponse({
    required this.id,
    required this.content,
    required this.likeCount,
    required this.createdAt,
    required this.modifiedAt,
    required this.postId,
    required this.trainerId,
  });

  factory AnswerResponse.fromJson(Map<String, dynamic> json) {
    return AnswerResponse(
      id: json['id'],
      content: json['content'],
      likeCount: json['likeCount'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      postId: json['postId'],
      trainerId: json['trainerId'],
    );
  }
}

class TrainerShortResponse {
  final int id;
  final String name;
  final String profileImgUrl;
  final int adoptCount;
  final int chatCount;

  TrainerShortResponse({
    required this.id,
    required this.name,
    required this.profileImgUrl,
    required this.adoptCount,
    required this.chatCount,
  });

  factory TrainerShortResponse.fromJson(Map<String, dynamic> json) {
    return TrainerShortResponse(
      id: json['id'],
      name: json['name'],
      profileImgUrl: json['profileImgUrl'],
      adoptCount: json['adoptCount'],
      chatCount: json['chatCount'],
    );
  }
}

class AnswerDetailsListResponse {
  final AnswerResponse answerResponse;
  final TrainerShortResponse trainerShortResponse;
  final bool checkAdopt;
  AnswerCheckResponse answerCheckResponse;

  AnswerDetailsListResponse({
    required this.answerResponse,
    required this.trainerShortResponse,
    required this.checkAdopt,
    required this.answerCheckResponse,
  });

  factory AnswerDetailsListResponse.fromJson(Map<String, dynamic> json) {
    return AnswerDetailsListResponse(
      answerResponse: AnswerResponse.fromJson(json['answerResponse']),
      trainerShortResponse:
          TrainerShortResponse.fromJson(json['trainerShortResponse']),
      checkAdopt: json['checkAdopt'],
      answerCheckResponse: json['answerCheckResponse'] != null
          ? AnswerCheckResponse(likeCheck: false)
          : AnswerCheckResponse(likeCheck: false),
    );
  }
}

class AnswerBasicListResponse {
  final AnswerResponse answerResponse;
  final bool checkAdopt;

  AnswerBasicListResponse({
    required this.answerResponse,
    required this.checkAdopt,
  });

  factory AnswerBasicListResponse.fromJson(Map<String, dynamic> json) {
    return AnswerBasicListResponse(
      answerResponse: AnswerResponse.fromJson(json['answerResponse']),
      checkAdopt: json['checkAdopt'],
    );
  }
}
