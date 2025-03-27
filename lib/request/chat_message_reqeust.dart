import 'package:sponge_app/data/chat/chat_message_response.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';

Future<List<ChatMessageResponse>> getChatRoomMessage(
    int chatRoomId, int page) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/message',
    queryParameters: {
      'chatRoomId': chatRoomId.toString(),
      'page': page.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final List<dynamic> data = response.data;
      return data.map((item) => ChatMessageResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
