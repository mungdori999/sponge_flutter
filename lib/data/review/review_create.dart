class ReviewCreate{

  final int trainerId;
  final int score;
  final String content;

  ReviewCreate({required this.trainerId, required this.score, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'trainerId': trainerId,
      'score': score,
      'content': content,
    };
  }

}