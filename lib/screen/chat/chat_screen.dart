import 'package:flutter/material.dart';
import 'package:sponge_app/component/chat/chat_bubble.dart';
import 'package:sponge_app/component/mypage/alert_login.dart';
import 'package:sponge_app/component/top/chat_message_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/chat/chat_message_response.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/request/chat_message_reqeust.dart';
import 'package:sponge_app/request/chat_service.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class ChatScreen extends StatefulWidget {
  final int chatRoomId;
  final String dearName;

  const ChatScreen(
      {super.key, required this.chatRoomId, required this.dearName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatService chatService;
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessageResponse> messages = []; // 채팅 메시지 저장
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int page = 0; // 페이지 번호

  JwtUtil jwtUtil = JwtUtil();
  LoginAuth? loginAuth;

  @override
  void initState() {
    super.initState();
    chatService = ChatService(
      chatRoomId: widget.chatRoomId,
      onMessageReceived: (ChatMessageResponse message) {
        setState(() {
          messages.insert(0, message);
        });
      },
    );
    chatService.connect();

    _loadMessages(); // 초기 메시지 로드

    // 스크롤 감지 리스너 추가
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("스르륵");
        _loadOlderMessages(); // 스크롤이 맨 위에 닿으면 이전 메시지 로드
      }
    });
  }

  // 초기 메시지 로드
  void _loadMessages() async {
    loginAuth = await jwtUtil.getJwtToken();
    if (loginAuth!.id == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertLogin();
          },
        );
      });
    } else {
      setState(() {});
    }
    final newMessages = await getChatRoomMessage(widget.chatRoomId, page);
    setState(() {
      messages.addAll(newMessages);
      page++;
    });
  }

  // 이전 메시지 불러오기 (위로 스크롤 시 호출)
  Future<void> _loadOlderMessages() async {
    if (isLoading) return; // 로딩 중이면 중복 요청 방지
    setState(() => isLoading = true);

    try {
      final olderMessages = await getChatRoomMessage(widget.chatRoomId, page);
      setState(() {
        page++;
        messages.addAll(olderMessages); // 기존 메시지 위에 추가
      });
    } catch (e) {
      // 에러 처리
      print("Error occurred: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    chatService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      chatService.sendMessage(widget.dearName, _messageController.text);
      setState(() {
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loginAuth == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: ChatMessageTop(
            dearName: widget.dearName,
          ),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        backgroundColor: lightGrey,
        body: Column(
          children: [
            // 로딩 인디케이터를 상단에 표시
            if (isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true, // 최신 메시지가 아래로 가도록 설정
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  // ChatMessageResponse 타입이 맞는지 확인
                  return ChatBubble(
                    message: message,
                    isMe: message.pubId == loginAuth!.id &&
                        message.loginType ==
                            loginAuth!.loginType, // pubId가 내 ID랑 같으면 내가 보낸 메시지
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: buttonGrey, width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: buttonGrey, width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: buttonGrey, width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: Container(
                              width: 10, // 원 크기
                              height: 10, // 원 크기
                              decoration: BoxDecoration(
                                color: mainYellow, // 배경 색상
                                shape: BoxShape.circle, // 원 모양
                              ),
                              child: IconButton(
                                icon: Icon(Icons.send, color: Colors.white),
                                // 아이콘 색상
                                onPressed: _sendMessage,
                                // 전송 버튼 클릭
                                iconSize: 15,
                                // 아이콘 크기
                                padding: EdgeInsets.zero, // 여백 없애기
                              ),
                            )),

                        onSubmitted: (_) => _sendMessage(), // Enter 키로 전송 가능
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
