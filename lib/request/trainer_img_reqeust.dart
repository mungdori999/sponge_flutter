import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';
import 'package:sponge_app/request/image_request.dart';
import 'package:sponge_app/util/file_storage.dart';

Future<void> getTrainerImg(String imgUrl) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/trainer/image',
    queryParameters: {
      'imgUrl': imgUrl,
    },
  ).toString();

  try {
    final response = await _dio.get(url);
    await deleteSavedProfileImage();
    await downloadProfileImage(response.data.toString());
    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<String> uploadTrainerImg(File imageFile) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/trainer/image',
  ).toString();

  try {
    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "multipartFile": await MultipartFile.fromFile(imageFile.path,
          filename: fileName), // 'file' 파라미터명을 정확히 맞추기
    });

    final response = await _dio.post(url, data: formData);
    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      return response.data.toString();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<void> deleteTrainerImg(int trainerId, String imgUrl) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/trainer/image',
    queryParameters: {
      'trainerId': trainerId.toString(),
      'imgUrl': imgUrl,
    },
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
