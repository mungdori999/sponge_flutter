import 'package:sponge_app/data/answer/answer_create.dart';
import 'package:sponge_app/data/answer/answer_response.dart';
import 'package:sponge_app/data/answer/answer_update.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';

Future<List<AnswerListResponse>> getAnswerList(int postId) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/answer',
    queryParameters: {
      'postId': postId.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final List<dynamic> data = response.data;
      return data.map((item) => AnswerListResponse.fromJson(item)).toList();
    } else {

      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {

    throw Exception('Error occurred: $e');
  }
}
Future<void> createAnswer(AnswerCreate answerCreate) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/answer',
  ).toString();

  try {
    final response = await _dio.post(url, data: answerCreate.toJson());

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
Future<void> updateAnswer(int id,AnswerUpdate answerUpdate) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/answer/${id}',
  ).toString();

  try {
    final response = await _dio.patch(url, data: answerUpdate.toJson());

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<void> deleteAnswer(int id) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/answer/${id}',
  ).toString();

  try {
    final response = await _dio.delete(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<void> updateAnswerLike(int answerId) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/answer/like',
    queryParameters: {
      'answerId': answerId.toString(),
    },
  ).toString();

  try {
    final response = await _dio.post(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}