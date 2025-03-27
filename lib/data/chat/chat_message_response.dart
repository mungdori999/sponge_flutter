class ChatMessageResponse {
  final int id;
  final String message;
  final int pubId;
  final String loginType;
  final int createdAt;

  ChatMessageResponse({
    required this.id,
    required this.message,
    required this.pubId,
    required this.loginType,
    required this.createdAt,
  });

  // JSON에서 ChatMessageResponse 객체로 변환
  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      id: json['id'] as int,
      message: json['message'] as String,
      pubId: json['pubId'] as int,
      loginType: json['loginType'] as String,
      createdAt: json['createdAt'] as int,
    );
  }

  // ChatMessageResponse 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'pubId': pubId,
      'loginType': loginType,
      'createdAt': createdAt,
    };
  }
}
