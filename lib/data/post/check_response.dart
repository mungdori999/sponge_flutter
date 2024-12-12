class CheckResponse {

  final bool likeCheck;
  final bool bookmarkCheck;

  CheckResponse({required this.likeCheck, required this.bookmarkCheck});



  factory CheckResponse.from(Map<String, dynamic> json) {
    return CheckResponse(
      likeCheck: json['likeCheck'] as bool,
      bookmarkCheck: json['bookmarkCheck'] as bool,
    );
  }
}