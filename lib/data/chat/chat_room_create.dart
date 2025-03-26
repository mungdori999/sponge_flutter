
class ChatRoomCreate {
  final int trainerId;

  ChatRoomCreate({required this.trainerId});



  Map<String, dynamic> toJson() {
    return {
      'trainerId': trainerId,
    };
  }
}