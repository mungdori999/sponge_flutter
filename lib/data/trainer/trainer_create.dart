class TrainerCreate {
  String name;
  String phone;
  int gender;
  int years;
  String profileImgUrl;
  List<HistoryCreate> historyList = [];

  TrainerCreate(
      {this.name = '',
      this.phone = '',
      this.gender = 1,
      this.profileImgUrl = '',
      this.years = 0});
}

class HistoryCreate {
  String title;
  String startDt;
  String endDt;
  String description;

  HistoryCreate(
      {this.title = '',
      this.startDt = '',
      this.endDt = '',
      this.description = ''});

  HistoryCreate copy() {
    return HistoryCreate(
      title: this.title,
      startDt: this.startDt,
      endDt: this.endDt,
      description: this.description,
    );
  }
}
