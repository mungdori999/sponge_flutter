import 'package:sponge_app/data/review/review_check_response.dart';
import 'package:sponge_app/data/review/review_create.dart';
import 'package:sponge_app/data/review/review_response.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';

Future<ReviewCheckResponse> getMyReviewCheck(int trainerId) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/review/check',
    queryParameters: {
      'trainerId': trainerId.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final dynamic data = response.data;
      return ReviewCheckResponse.from(data);
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<List<ReviewResponse>> getReviewListByTrainerId(
    int trainerId, int page) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/review',
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
      return data.map((item) => ReviewResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<void> createReview(ReviewCreate reviewCreate) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/review',
  ).toString();

  try {
    final response = await _dio.post(url, data: reviewCreate.toJson());

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
