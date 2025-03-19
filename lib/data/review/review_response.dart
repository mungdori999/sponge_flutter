class ReviewResponse {

  final int id;
  final int score;
  final String content;
  final int createdAt;
  final String userName;

  ReviewResponse({required this.id, required this.score, required this.content, required this.createdAt, required this.userName});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      id: json['id'],
      score: json['score'],
      content: json['content'],
      createdAt: json['createdAt'],
      userName: json['userName'],
    );
  }



}