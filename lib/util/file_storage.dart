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

Future<void> deleteSavedProfileImage() async {
  final dir = await getTemporaryDirectory(); // 임시 저장소 경로 가져오기
  final filePath = '${dir.path}/profile.jpg'; // 저장된 파일 경로

  final file = File(filePath);

  if (await file.exists()) {
    await file.delete(); // 파일 삭제
    print('프로필 이미지 삭제 완료');
  } else {
    print('삭제할 이미지가 없습니다.');
  }
}


Future<File?> getSavedPetImage(int petId) async {
  final dir = await getTemporaryDirectory(); // 임시 저장소 경로 가져오기
  final filePath = '${dir.path}/${petId}.jpg'; // 저장된 파일 경로

  final file = File(filePath);
  if (await file.exists()) {
    return file; // 파일이 존재하면 반환
  } else {
    return null; // 파일이 없으면 null 반환
  }
}
