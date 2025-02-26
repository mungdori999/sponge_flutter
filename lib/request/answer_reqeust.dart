import 'package:sponge_app/data/answer/adopt_answer_create.dart';
import 'package:sponge_app/data/answer/answer_check_response.dart';
import 'package:sponge_app/data/answer/answer_create.dart';
import 'package:sponge_app/data/answer/answer_response.dart';
import 'package:sponge_app/data/answer/answer_update.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';

Future<List<AnswerDetailsListResponse>> getAnswerList(int postId) async {
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
      return data
          .map((item) => AnswerDetailsListResponse.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
Future<List<AnswerBasicListResponse>> getAnswerListByTrainerId(int trainerId,int page) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/answer/trainer',
    queryParameters: {
      'trainerId': trainerId.toString(),
      'page': page.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final List<dynamic> data = response.data;
      return data
          .map((item) => AnswerBasicListResponse.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<List<AnswerBasicListResponse>> getMyAnswer(int page) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/answer/my_info',
    queryParameters: {
      'page': page.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final List<dynamic> data = response.data;
      return data
          .map((item) => AnswerBasicListResponse.fromJson(item))
          .toList();
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

Future<void> updateAnswer(int id, AnswerUpdate answerUpdate) async {
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

Future<void> createAdoptAnswer(AdoptAnswerCreate adoptAnswerCreate) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/answer/adopt',
  ).toString();

  try {
    final response = await _dio.post(url, data: adoptAnswerCreate.toJson());

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
    } else {

      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<AnswerCheckResponse> getMyAnswerCheck(int answerId) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/answer/check',
    queryParameters: {
      'answerId': answerId.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final dynamic data = response.data;
      return AnswerCheckResponse.from(data);
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
