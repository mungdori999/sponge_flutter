import 'package:intl/intl.dart';

class Convert {
  static String convertTimeAgo(int timestamp) {
    // timestamp (밀리초) -> DateTime으로 변환
    final createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return '${difference.inSeconds}초 전'; // 1분 미만은 초 단위로 표시
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전'; // 1시간 미만은 분 단위로 표시
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전'; // 1일 미만은 시간 단위로 표시
    } else if (difference.inDays < 30) {
      return '${difference.inDays}일 전'; // 1개월 미만은 일 단위로 표시
    } else if (difference.inDays < 365) {
      int months = difference.inDays ~/ 30;
      return '${months}개월 전'; // 1년 미만은 개월 단위로 표시
    } else {
      int years = difference.inDays ~/ 365;
      return '${years}년 전'; // 1년 이상은 년 단위로 표시
    }
  }

  static String formatTime(int timestamp) {
    // 1️⃣ 밀리초를 DateTime으로 변환
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal();
    DateTime now = DateTime.now();

    // 2️⃣ 날짜 차이 계산
    Duration difference = now.difference(dateTime);
    String formattedTime;

    if (difference.inDays == 0 && now.day == dateTime.day) {
      // 👉 오늘이면 "오전/오후 h:mm" 형식
      formattedTime = DateFormat('a h:mm', 'ko_KR').format(dateTime);
    } else if (difference.inDays == 1 || (now.day - dateTime.day == 1 && difference.inDays == 0)) {
      // 👉 어제이면 "어제" 표시
      formattedTime = "어제";
    } else {
      // 👉 그 외에는 "yyyy.MM.dd" 형식 (예: 2024.03.24)
      formattedTime = DateFormat('yyyy.MM.dd', 'ko_KR').format(dateTime);
    }

    return formattedTime;
  }
}
