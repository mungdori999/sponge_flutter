import 'package:flutter/material.dart';
import 'package:sponge_app/data/chat/chat_message_response.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageResponse message;
  final bool isMe; // 내가 보낸 메시지인지 확인

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300], // 내가 보낸 메시지는 파란색
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.message, // 메시지 내용
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
