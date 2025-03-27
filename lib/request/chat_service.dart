import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sponge_app/data/chat/chat_message_response.dart';
import 'package:sponge_app/token/jwt_token.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatService {
  StompClient? stompClient;
  final int chatRoomId;
  final Function(ChatMessageResponse) onMessageReceived;


  ChatService({required this.chatRoomId, required this.onMessageReceived});

  void connect() async{
    final storage = new FlutterSecureStorage();
    final accessToken = await storage.read(key: JwtToken.accessToken.key);

    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/chat/inbox/websocket',
        webSocketConnectHeaders: {
          "Authorization": "$accessToken", // Authorization 헤더 추가
        },
        stompConnectHeaders: {
          "Authorization": "$accessToken" // ✅ STOMP CONNECT 요청에 헤더 추가
        },
        onConnect: (StompFrame frame) {
          print("✅ WebSocket 연결됨!");

          // 채팅방 구독
          stompClient?.subscribe(
            destination: '/sub/channel/$chatRoomId',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                try {
                  // JSON 문자열을 Map으로 변환
                  Map<String, dynamic> jsonData = jsonDecode(frame.body!);

                  // ChatMessageResponse 객체로 변환
                  ChatMessageResponse message = ChatMessageResponse.fromJson(jsonData);

                  // 콜백 실행
                  onMessageReceived(message);
                } catch (e) {
                  print("❌ 메시지 변환 오류: $e");
                }
              }
            },
          );
        },
        onWebSocketError: (error) {
          print("❌ WebSocket 에러: $error");
          // _reconnect();
        },
      ),
    );

    stompClient?.activate();
  }

  // 메시지 전송
  void sendMessage(String sender, String message) async{
    final storage = new FlutterSecureStorage();
    final accessToken = await storage.read(key: JwtToken.accessToken.key);

    if (stompClient == null || !stompClient!.isActive) {
      print("❌ WebSocket 연결이 활성화되지 않았습니다.");
      _reconnect();
      return;
    }

    stompClient?.send(
      destination: '/pub/message',
      body: '''{
        "chatRoomId": "$chatRoomId",
        "message": "$message"
      }''',
        headers: {
          "Authorization": "$accessToken" // ✅ SEND 프레임에도 Authorization 추가!
        }
    );
  }

  // WebSocket 연결 재시도
  void _reconnect() {
    print("🔄 WebSocket 재연결 시도...");
    connect();
  }

  void disconnect() {
    stompClient?.deactivate();
    print("채팅방 연결 종료");
  }
}