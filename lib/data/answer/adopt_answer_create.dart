class AdoptAnswerCreate {

  final int answerId;
  final int trainerId;
  final int postId;

  AdoptAnswerCreate({required this.answerId, required this.trainerId, required this.postId});

  Map<String, dynamic> toJson() {
    return {
      'answerId': answerId,
      'trainerId': trainerId,
      'postId': postId,
    };
  }


}