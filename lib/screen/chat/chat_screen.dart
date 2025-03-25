import 'package:flutter/material.dart';
import 'package:sponge_app/request/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String name;


  const ChatScreen(
      {super.key, required this.chatRoomId, required this.name});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatService chatService;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> messages = []; // 채팅 메시지 저장

  @override
  void initState() {
    super.initState();
    chatService = ChatService(
      chatRoomId: widget.chatRoomId,
      onMessageReceived: (String message) {
        setState(() {
          messages.add({"sender": "상대방", "message": message});
        });
      },
    );
    chatService.connect();
  }

  @override
  void dispose() {
    chatService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      chatService.sendMessage(widget.name, _messageController.text);
      setState(() {
        messages.add(
            {"sender": widget.name, "message": _messageController.text});
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("채팅방 ${widget.chatRoomId}")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message["sender"] == widget.name;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message["message"]!,
                      style:
                          TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "메시지를 입력하세요"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
