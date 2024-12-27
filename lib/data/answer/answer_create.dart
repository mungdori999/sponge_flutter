
class AnswerCreate {
  final int postId;
  final String content;

  AnswerCreate({required this.postId, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'content': content,
    };
  }
}