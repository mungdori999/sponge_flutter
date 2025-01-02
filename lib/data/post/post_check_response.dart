class PostCheckResponse {

  final bool likeCheck;
  final bool bookmarkCheck;

  PostCheckResponse({required this.likeCheck, required this.bookmarkCheck});



  factory PostCheckResponse.from(Map<String, dynamic> json) {
    return PostCheckResponse(
      likeCheck: json['likeCheck'] as bool,
      bookmarkCheck: json['bookmarkCheck'] as bool,
    );
  }
}