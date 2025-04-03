import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';
import 'package:sponge_app/request/image_request.dart';

Future<void> getPetImg(String imgUrl, int sequence) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/pet/image',
    queryParameters: {
      'imgUrl': imgUrl,
    },
  ).toString();

  try {
    final response = await _dio.get(url);
    await downloadPetImage(response.data.toString(), sequence);
    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<String> uploadPetImg(File imageFile) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/pet/image',
  ).toString();

  try {
    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "multipartFile":
          await MultipartFile.fromFile(imageFile.path, filename: fileName),
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

Future<void> deletePetImg(int petId, String imgUrl) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/pet/image',
    queryParameters: {
      'petId': petId.toString(),
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
