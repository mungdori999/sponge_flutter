import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer.dart';

class TrainerProfileHistory extends StatelessWidget {
  final List<History> historyList;
  const TrainerProfileHistory({super.key, required this.historyList});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '경력',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 8,),
              Text(
                historyList.length.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,color: mainGrey),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Column(
            children: historyList.map((history) {
              return Row(
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
                        Row(
                          children: [
                            Text(
                              _formatDateString(history.startDt),
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
                                _formatDateString(history.endDt),
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
                        SizedBox(height: 8,),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _formatDateString(String date) {
    if (date.length != 6) return date; // 길이가 6이 아니면 그대로 반환
    String year = date.substring(0, 4); // 앞의 4자리: 연도
    String month = date.substring(4, 6); // 뒤의 2자리: 월
    return "$year.$month";
  }

}
