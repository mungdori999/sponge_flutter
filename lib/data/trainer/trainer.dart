class Trainer {
  final int id;
  final String email;
  final String name;
  final String phone;
  final int gender;
  final int years;
  final String profileImgUrl;
  final String content;
  final int adoptCount; // 채택 답변 수
  final double score; // 채택 답변 수
  final int chatCount; // 1대1 채팅 수
  final List<History> historyList;
  final List<TrainerAddress> trainerAddressList;

  Trainer({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.gender,
    required this.years,
    required this.profileImgUrl,
    required this.content,
    required this.adoptCount,
    required this.score,
    required this.chatCount,
    required this.historyList,
    required this.trainerAddressList,
  });

  static Future<Trainer> fromJson(Map<String, dynamic> data) async {
    return Trainer(
      id: data['id'] ?? 0,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? 0,
      years: data['years'] ?? 0,
      profileImgUrl: data['profileImgUrl'] ?? '',
      content: data['content'] ?? '',
      adoptCount: data['adoptCount'] ?? 0,
      score: data['score'] ?? 0,
      chatCount: data['chatCount'] ?? 0,
      historyList: (data['historyList'] as List<dynamic>? ?? [])
          .map((item) => History.fromJson(item))
          .toList(),
      trainerAddressList: (data['trainerAddressList'] as List<dynamic>? ?? [])
          .map((item) => TrainerAddress.fromJson(item))
          .toList(),
    );
  }
}

class TrainerAddress {
  final int id;
  final String city;
  final String town;

  TrainerAddress({required this.id, required this.city, required this.town});

  factory TrainerAddress.fromJson(Map<String, dynamic> json) {
    return TrainerAddress(
      id: json['id'] ?? 0,
      city: json['city'] ?? '',
      town: json['town'] ?? '',
    );
  }
}

class History {
  final int id;
  final String title;
  final String startDt;
  final String endDt;
  final String description;

  History({required this.id, required this.title, required this.startDt, required this.endDt, required this.description});
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      startDt: json['startDt'] ?? '',
      endDt: json['endDt'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
