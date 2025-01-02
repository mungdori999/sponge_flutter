class AnswerCheckResponse {
  final bool likeCheck;

  AnswerCheckResponse({required this.likeCheck});



  factory AnswerCheckResponse.from(Map<String, dynamic> json) {
    return AnswerCheckResponse(
      likeCheck: json['likeCheck'] as bool,
    );
  }
}