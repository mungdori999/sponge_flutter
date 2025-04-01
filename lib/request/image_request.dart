import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<File?> downloadImage(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(
        "https://mungdori-bucket-domain.s3.ap-northeast-2.amazonaws.com/" +
            imageUrl));
    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory(); // 임시 저장소 경로 가져오기
      final file = File('${dir.path}/profile.jpg'); // 파일 저장 경로 설정
      await file.writeAsBytes(response.bodyBytes); // 파일 저장

      return file;
    } else {
      print("이미지 다운로드 실패: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("에러 발생: $e");
    return null;
  }
}
