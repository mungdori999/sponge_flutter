import 'package:dio/dio.dart';
import 'package:sponge_app/data/post/post_check_response.dart';
import 'package:sponge_app/data/post/post.dart';
import 'package:sponge_app/data/post/post_create.dart';
import 'package:sponge_app/data/post/post_list_response.dart';
import 'package:sponge_app/data/post/post_update.dart';
import 'package:sponge_app/http/auth_dio.dart';
import 'package:sponge_app/http/status_code.dart';
import 'package:sponge_app/http/url.dart';

Future<PostResponse> getPost(int id) async {
  var _dio = Dio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post/${id}',
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final dynamic data = response.data;
      return PostResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<List<Post>> getAllPost(int categoryCode, int page) async {
  var _dio = Dio();

  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post',
    queryParameters: {
      'categoryCode': categoryCode.toString(),
      'page': page.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);
    if (response.statusCode == ok) {
      // UTF-8로 디코딩 후 JSON 데이터 파싱
      final List<dynamic> data = response.data;
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
Future<List<Post>> getPostListByUserId(int userId,int page) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post/user',
    queryParameters: {
      'userId': userId.toString(),
      'page': page.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final List<dynamic> data = response.data;
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
Future<List<Post>> getMyPost(int page) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post/my_info',
    queryParameters: {
      'page': page.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final List<dynamic> data = response.data;
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<PostResponse> createPost(PostCreate postCreate) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post',
  ).toString();

  try {
    final response = await _dio.post(url, data: postCreate.toJson());

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final dynamic data = response.data;
      return PostResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<PostResponse> updatePost(int id,PostUpdate postUpdate) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post/${id}',
  ).toString();

  try {
    final response = await _dio.patch(url, data: postUpdate.toJson());

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final dynamic data = response.data;
      return PostResponse.fromJson(data);
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<void> deletePost(int id) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post/${id}',
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

Future<PostCheckResponse> getMyPostCheck(int postId) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post/check',
    queryParameters: {
      'postId': postId.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final dynamic data = response.data;
      return PostCheckResponse.from(data);
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}
Future<List<Post>> getMyPostByBookmark(int page) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post/bookmark',
    queryParameters: {
      'page': page.toString(),
    },
  ).toString();

  try {
    final response = await _dio.get(url);

    // 응답 코드가 200번대일 때 처리
    if (response.statusCode == ok) {
      final List<dynamic> data = response.data;
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred: $e');
  }
}

Future<void> updateBookmark(int postId) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post/bookmark',
    queryParameters: {
      'postId': postId.toString(),
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

Future<void> updatePostLike(int postId) async {
  var _dio = await authDio();
  final url = Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: '${path}/post/like',
    queryParameters: {
      'postId': postId.toString(),
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

