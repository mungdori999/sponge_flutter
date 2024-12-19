import 'package:sponge_app/data/pet/pet.dart';
import 'package:sponge_app/data/pet/pet_create.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';

Future<List<Pet>> getPetByUserId(int userId) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/pet',
    queryParameters: {
      'userId': userId.toString(),
    },
  ).toString();

  try {
    // GET 요청 보내기
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final List<dynamic> data = response.data;
      return data.map((item) => Pet.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<List<Pet>> getMyPet() async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/pet/my_info',
  ).toString();

  try {
    // GET 요청 보내기
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final List<dynamic> data = response.data;
      return data.map((item) => Pet.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<Pet> createPet(PetCreate petCreate) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/pet',
  ).toString();

  try {
    final response = await _dio.post(url, data: petCreate.toJson());

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final dynamic data = response.data;
      return Pet.fromJson(data);
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<Pet> updatePet(int id, PetCreate petCreate) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/pet/${id}',
  ).toString();

  try {
    final response = await _dio.patch(url, data: petCreate.toJson());

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final dynamic data = response.data;
      return Pet.fromJson(data);
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<void> deletePet(int id) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/pet/${id}',
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
