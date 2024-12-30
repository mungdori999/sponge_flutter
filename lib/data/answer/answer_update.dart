class AnswerUpdate {
  final String content;

  AnswerUpdate({required this.content});

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }

}