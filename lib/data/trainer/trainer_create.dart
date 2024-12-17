class TrainerCreate {
  String email;
  String name;
  String phone;
  int gender;
  int years;
  String profileImgUrl;
  String content;
  List<HistoryCreate> historyList = [];
  List<AddressCreate> addressList = [];

  TrainerCreate({
    this.email = '',
    this.name = '',
    this.phone = '',
    this.gender = 1,
    this.profileImgUrl = '',
    this.content = '',
    this.years = 0,
  });

  // toJson 메소드 추가
  Map<String, dynamic> toJson() {
    return {
      'email':email,
      'name': name,
      'phone': phone,
      'gender': gender,
      'years': years,
      'profileImgUrl': profileImgUrl,
      'content': content,
      'historyList': historyList.map((history) => history.toJson()).toList(),
      'trainerAddressList': addressList.map((address) => address.toJson()).toList(),
    };
  }
}

class AddressCreate {
  String city;
  String town;

  AddressCreate({required this.city, required this.town});

  AddressCreate copy() {
    return AddressCreate(city: this.city, town: this.town);
  }

  // toJson 메소드 추가
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'town': town,
    };
  }
}

class HistoryCreate {
  String title;
  String startDt;
  String endDt;
  String description;

  HistoryCreate({
    this.title = '',
    this.startDt = '',
    this.endDt = '',
    this.description = '',
  });

  HistoryCreate copy() {
    return HistoryCreate(
      title: this.title,
      startDt: this.startDt,
      endDt: this.endDt,
      description: this.description,
    );
  }

  // toJson 메소드 추가
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startDt': startDt,
      'endDt': endDt,
      'description': description,
    };
  }
}
