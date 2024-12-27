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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'likeCount': likeCount,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'postId': postId,
      'trainerId': trainerId,
    };
  }
}

class TrainerShortResponse {
  final int id;
  final String name;
  final int adoptCount;
  final int chatCount;

  TrainerShortResponse({
    required this.id,
    required this.name,
    required this.adoptCount,
    required this.chatCount,
  });

  factory TrainerShortResponse.fromJson(Map<String, dynamic> json) {
    return TrainerShortResponse(
      id: json['id'],
      name: json['name'],
      adoptCount: json['adoptCount'],
      chatCount: json['chatCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'adoptCount': adoptCount,
      'chatCount': chatCount,
    };
  }
}

class AnswerListResponse {
  final AnswerResponse answerResponse;
  final TrainerShortResponse trainerShortResponse;
  final bool checkAdopt;

  AnswerListResponse({
    required this.answerResponse,
    required this.trainerShortResponse,
    required this.checkAdopt,
  });

  factory AnswerListResponse.fromJson(Map<String, dynamic> json) {
    return AnswerListResponse(
      answerResponse: AnswerResponse.fromJson(json['answerResponse']),
      trainerShortResponse:
      TrainerShortResponse.fromJson(json['trainerShortResponse']),
      checkAdopt: json['checkAdopt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answerResponse': answerResponse.toJson(),
      'trainerShortResponse': trainerShortResponse.toJson(),
      'checkAdopt': checkAdopt,
    };
  }
}
