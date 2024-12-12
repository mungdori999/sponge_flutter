import 'package:sponge_app/data/user/user.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';



  // Dio를 사용하여 사용자 정보를 가져오는 함수
  Future<UserResponse> getMyInfo() async {
    var _dio = await authDio();
    final url = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: '${path}/user/my_info',
    ).toString();
    try {
      // GET 요청 보내기
      final response = await _dio.get(url);

      // 응답 코드가 200번대일 때 처리
      if (response.statusCode == ok) {
        final dynamic data = response.data; // Dio에서 응답 데이터는 바로 data로 접근 가능
        return UserResponse.fromJson(data); // 받은 데이터를 User 객체로 변환
      } else {
        throw Exception('Failed to fetch user info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
