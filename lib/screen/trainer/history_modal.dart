import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';

class HistoryModal extends StatefulWidget {
  HistoryCreate historyCreate;

  HistoryModal({HistoryCreate? historyCreate})
      : this.historyCreate = historyCreate ?? HistoryCreate();

  @override
  State<HistoryModal> createState() => _HistoryModalState();
}

class _HistoryModalState extends State<HistoryModal> {
  late TextEditingController _titleController = new TextEditingController();
  late TextEditingController _descriptionController =
      new TextEditingController();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  bool _currentProgress = false;
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7 + bottomInset,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '이력 타이틀',
                      style: TextStyle(
                          color: mediumGrey,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    _RequiredStar(),
                  ],
                ),
                TextField(
                  controller: _titleController,
                  cursorColor: mainYellow,
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: "예) 반려견 컴퍼니 훈련사 근무",
                    hintStyle: TextStyle(
                      color: mainGrey,
                    ),
                    focusColor: mainGrey,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: lightGrey, width: 1),
                      borderRadius: BorderRadius.zero,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainGrey, width: 1),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      '기간',
                      style: TextStyle(
                          color: mediumGrey,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    _RequiredStar(),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentProgress = !_currentProgress;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _currentProgress ? mainYellow : checkGrey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '현재 진행중',
                        style: TextStyle(
                            color: _currentProgress ? mainYellow : mainGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showDatePicker();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: lightGrey, // 선의 색상
                              width: 1.0, // 선의 두께
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            selectedYear != 0
                                ? "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}"
                                : "시작일",
                            style: TextStyle(color: mainGrey, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lightGrey, // 선의 색상
                            width: 1.0, // 선의 두께
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          '종료일',
                          style: TextStyle(color: mainGrey, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      '상세설명',
                      style: TextStyle(
                          color: mediumGrey,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: lightGrey, // 배경색 설정
                    borderRadius: BorderRadius.circular(10), // 둥근 테두리
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8), // 내부 여백
                  child: TextField(
                    maxLength: 50,
                    maxLines: 2,
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    cursorColor: mainYellow,
                    decoration: InputDecoration(
                      hintText: '해당경력에대한 상세한 설명을 작성해주세요',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: mainGrey,
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    '저장',
                    style: TextStyle(
                      color: enabled ? Colors.white : mainGrey,
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: enabled ? mainYellow : lightGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    side: BorderSide.none,
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            // Done 버튼
            Container(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: Text("Done"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Year Picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: selectedYear - 2000),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          selectedYear = 2000 + index;
                        });
                      },
                      children: List<Widget>.generate(
                        100,
                        (int index) => Center(
                          child: Text('${2000 + index}'),
                        ),
                      ),
                    ),
                  ),
                  // Month Picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: selectedMonth - 1),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          selectedMonth = index + 1;
                        });
                      },
                      children: List<Widget>.generate(
                        12,
                        (int index) => Center(
                          child: Text('${index + 1}월'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequiredStar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '*',
      style: TextStyle(
        color: Colors.red,
        fontSize: 16, // 원하는 크기로 설정
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
