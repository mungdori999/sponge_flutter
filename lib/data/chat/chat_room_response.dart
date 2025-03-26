class ChatRoomResponse {
  final String name;
  final String imgUrl;
  final String loginType;
  final String lastMsg;
  final int createdAt;

  ChatRoomResponse({
    required this.name,
    required this.imgUrl,
    required this.loginType,
    required this.lastMsg,
    required this.createdAt,
  });

  // JSON에서 객체로 변환하는 factory constructor
  factory ChatRoomResponse.fromJson(Map<String, dynamic> json) {
    return ChatRoomResponse(
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      loginType: json['loginType'] as String,
      lastMsg: json['lastMsg'] as String,
      createdAt: json['createdAt'] as int,
    );
  }

  // 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imgUrl': imgUrl,
      'loginType': loginType,
      'lastMsg': lastMsg,
      'createdAt': createdAt,
    };
  }
}
