import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<File?> getSavedProfileImage() async {
  final dir = await getTemporaryDirectory(); // 임시 저장소 경로 가져오기
  final filePath = '${dir.path}/profile.jpg'; // 저장된 파일 경로

  final file = File(filePath);

  if (await file.exists()) {
    return file; // 파일이 존재하면 반환
  } else {
    return null; // 파일이 없으면 null 반환
  }
}

Future<File?> getSavedPetImage(int sequence) async {
  final dir = await getTemporaryDirectory(); // 임시 저장소 경로 가져오기
  final filePath = '${dir.path}/${sequence}.jpg'; // 저장된 파일 경로

  final file = File(filePath);
  if (await file.exists()) {
    return file; // 파일이 존재하면 반환
  } else {
    return null; // 파일이 없으면 null 반환
  }
}
