
class TrainerCreate {
  String name;
  String phone;
  int gender;
  String profileImgUrl;
  List<HistoryCreate> historyList = [];

  TrainerCreate(
      {this.name = '',
      this.phone = '',
      this.gender = 1,
      this.profileImgUrl = ''});
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
}
