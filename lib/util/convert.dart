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
}
