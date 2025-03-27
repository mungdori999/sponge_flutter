import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/const/login_type.dart';
import 'package:sponge_app/data/chat/chat_room_response.dart';
import 'package:sponge_app/request/chat_room_request.dart';
import 'package:sponge_app/screen/chat/chat_screen.dart';
import 'package:sponge_app/util/convert.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0;
  List<ChatRoomResponse> chatRoomList = [];
  int currentPage = 0;
  bool isLoading = false;
  bool hasMoreChatRoom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeData();
  }

  Future<void> _initializeData() async {
    final List<ChatRoomResponse> chatRoom = await getMyChatRoom(currentPage);
    setState(() {
      chatRoomList.addAll(chatRoom);
      currentPage++;
    });
  }

  Future<void> _fetchMoreChatRoom() async {
    if (isLoading || !hasMoreChatRoom) return;
    setState(() {
      isLoading = true;
    });
    try {
      final List<ChatRoomResponse> newChatRoom =
          await getMyChatRoom(currentPage);
      print(currentPage);
      setState(() {
        if (newChatRoom.isEmpty) {
          hasMoreChatRoom = false;
        } else {
          chatRoomList.addAll(newChatRoom);
          currentPage++;
        }
      });
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _fetchMoreChatRoom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...chatRoomList.map(
                  (chatRoom) => Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // 채팅방 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatRoomId: chatRoom.id,
                            dearName: chatRoom.loginType ==
                                LoginType.TRAINER.loginType
                                ? chatRoom.name + " 훈련사님"
                                : chatRoom.name + " 견주님",
                          ), // 채팅방 ID 전달
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('asset/img/basic_pet.png', width: 50),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chatRoom.loginType == LoginType.TRAINER.loginType
                                    ? chatRoom.name + " 훈련사님"
                                    : chatRoom.name + " 견주님",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              // Text의 크기 조정을 위해 Expanded 또는 Flexible 사용
                              Text(
                                chatRoom.lastMsg,
                                style: TextStyle(
                                  color: mainGrey,
                                ),
                                overflow: TextOverflow.ellipsis, // 넘칠 경우 '...'으로 표시
                              ),
                            ],
                          ),
                        ),
                        Text(
                          Convert.formatTime(chatRoom.createdAt),
                          style: TextStyle(
                            color: mainGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
