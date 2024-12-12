import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';

class HistoryModal extends StatefulWidget {
  HistoryCreate historyCreate;

  HistoryModal({HistoryCreate? historyCreate})
      : this.historyCreate = historyCreate ?? new HistoryCreate();

  @override
  State<HistoryModal> createState() => _HistoryModalState();
}

class _HistoryModalState extends State<HistoryModal> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  int startYear = DateTime.now().year;
  int startMonth = DateTime.now().month;
  int endYear = DateTime.now().year;
  int endMonth = DateTime.now().month;
  bool startCheck = false;
  bool endCheck = false;
  bool _currentProgress = false;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    widget.historyCreate.startDt != "" ? startCheck = true : startCheck = false;
    widget.historyCreate.endDt != "" ? endCheck = true : endCheck = false;
    _titleController =
        TextEditingController(text: widget.historyCreate.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.historyCreate.description ?? '');
    _titleController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      // 모든 TextField가 입력되었는지 확인
      if (_currentProgress) {
        enabled = _titleController.text.isNotEmpty && startCheck;
      } else {
        enabled = _titleController.text.isNotEmpty && startCheck && endCheck;
      }
    });
  }

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
                      _updateButtonState();
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
                        _startDatePicker();
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
                            startCheck
                                ? "$startYear-${startMonth.toString().padLeft(2, '0')}"
                                : "시작일",
                            style: TextStyle(color: mainGrey, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _endDatePicker();
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
                            endCheck
                                ? "$endYear-${endMonth.toString().padLeft(2, '0')}"
                                : "종료일",
                            style: TextStyle(color: mainGrey, fontSize: 16),
                          ),
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
                  onPressed: () {
                    widget.historyCreate.title=_titleController.text;
                    widget.historyCreate.description=_descriptionController.text;
                    widget.historyCreate.startDt = "${startYear}${startMonth.toString().padLeft(2, '0')}";
                    widget.historyCreate.endDt= "${endYear}${endMonth.toString().padLeft(2, '0')}";
                    Navigator.pop(context, widget.historyCreate);
                  },
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

  void _startDatePicker() {
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
                          initialItem: startYear - 2000),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          startYear = 2000 + index;
                          startCheck = true;
                          _updateButtonState();
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
                          initialItem: startMonth - 1),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          startMonth = index + 1;
                          startCheck = true;
                          _updateButtonState();
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

  void _endDatePicker() {
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
                          initialItem: endYear - 2000),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          endYear = 2000 + index;
                          endCheck = true;
                          _updateButtonState();
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
                          initialItem: endMonth - 1),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          endMonth = index + 1;
                          endCheck = true;
                          _updateButtonState();
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
