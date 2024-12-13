import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';
import 'package:sponge_app/screen/trainer/history_modal.dart';

class HistoryRegister extends StatefulWidget {
  List<HistoryCreate> historyList;
  int years;

  HistoryRegister({super.key, required this.historyList, required this.years});

  @override
  State<HistoryRegister> createState() => _HistoryRegisterState();
}

class _HistoryRegisterState extends State<HistoryRegister> {
  int _currentValue = 3;
  late List<HistoryCreate> historyCopyList;

  @override
  void initState() {
    super.initState();
    historyCopyList =
        widget.historyList.map((history) => history.copy()).toList();
    if (widget.years != 0) {
      _currentValue = widget.years;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '경력',
          style: TextStyle(
              color: mediumGrey, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close, // 'X' 아이콘
            color: Colors.black, // 아이콘 색상
          ),
          onPressed: () {
            Navigator.pop(context, widget.years); // 뒤로가기 동작
          },
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: OutlinedButton(
            onPressed: () {
              widget.historyList.clear();
              widget.historyList.addAll(
                  historyCopyList.map((history) => history.copy()).toList());
              Navigator.pop(context, _currentValue);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: mainYellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              side: BorderSide.none,
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text(
              '저장',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '연차',
                    style: TextStyle(
                        color: mediumGrey,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  _RequiredStar(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '~${_currentValue.toInt()}연차',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  Slider(
                    value: _currentValue.toDouble(),
                    // 슬라이더의 현재 값
                    min: 0,
                    // 최소값
                    max: 30,
                    // 최대값
                    label: _currentValue.toStringAsFixed(0),
                    // 현재 값을 표시
                    onChanged: (value) {
                      setState(() {
                        _currentValue = value.toInt(); // 상태 업데이트
                      });
                    },
                    activeColor: mainYellow,
                    // 활성화된 슬라이더 색상
                    inactiveColor: lightGrey, // 비활성화된 슬라이더 색상
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    '이력',
                    style: TextStyle(
                        color: mediumGrey,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  if (historyCopyList.isNotEmpty) ...[
                    Text(
                      historyCopyList.length.toString(),
                      style: TextStyle(
                          color: mainYellow,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    Text(
                      "/10",
                      style: TextStyle(
                          color: mainGrey,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ]
                ],
              ),
              Container(
                width: double.infinity,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '이력을 입력해주세요',
                        style: TextStyle(color: mainGrey, fontSize: 16),
                      ),
                      IconButton(
                        onPressed: historyCopyList.length < 10
                            ? () async {
                                final HistoryCreate history =
                                    await showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .unfocus(); // 키보드 닫기
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: HistoryModal(),
                                    );
                                  },
                                );
                                setState(() {
                                  if (history.title != '') {
                                    historyCopyList.add(history);
                                  }
                                });
                              }
                            : null,
                        icon: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: historyCopyList.length < 10
                                ? mainYellow
                                : mainGrey, // 색상 변경
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: historyCopyList.map((history) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    // 컨테이너 간격
                    padding: EdgeInsets.all(12),
                    // 내부 여백
                    decoration: BoxDecoration(
                      border: Border.all(color: mainYellow, width: 1),
                      // 노란색 실선
                      borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // 텍스트 왼쪽 정렬
                            children: [
                              Text(
                                history.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: darkGrey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    formatDateString(history.startDt),
                                    style: TextStyle(
                                        color: mainGrey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    '~',
                                    style: TextStyle(
                                        color: mainGrey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  if (history.endDt != '')
                                    Text(
                                      formatDateString(history.endDt),
                                      style: TextStyle(
                                          color: mainGrey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                ],
                              ),
                              Text(
                                history.description,
                                // history의 description
                                style: TextStyle(
                                  fontSize: 14,
                                  color: mainGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    historyCopyList.remove(history);
                                  });
                                }, icon: Icon(Icons.close,color: mainYellow,)),
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDateString(String date) {
    if (date.length != 6) return date; // 길이가 6이 아니면 그대로 반환
    String year = date.substring(0, 4); // 앞의 4자리: 연도
    String month = date.substring(4, 6); // 뒤의 2자리: 월
    return "$year.$month";
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
