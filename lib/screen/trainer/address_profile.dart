import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sponge_app/const/city.dart';
import 'package:sponge_app/const/color_const.dart';

class AddressProfile extends StatelessWidget {
  AddressProfile({super.key});

  List<String> cityList = City.values.map((city) => city.address).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '지역',
          style: TextStyle(
              color: mediumGrey, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close, // 'X' 아이콘
            color: Colors.black, // 아이콘 색상
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '주요 활동지역 선택',
                  style: TextStyle(
                      color: mediumGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                _RequiredStar(),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '(중복선택 가능)',
                  style: TextStyle(
                      color: mainGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 45,
              child: ListView(
                physics: PageScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children:[
                  ...cityList.map((city) {
                    return GestureDetector(
                      onTap: () async {
                          await _getTown(admCode: City.getCodeByAddress(city));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4), // 아이템 간격
                        padding: EdgeInsets.symmetric(horizontal: 20), // 내용 여백
                        decoration: BoxDecoration(
                          color: lightGrey, // 배경색 (회색)
                          borderRadius: BorderRadius.circular(8), // 둥근 모서리
                        ),
                        child: Center(
                          child: Text(
                            city, // 텍스트 (도시 이름)
                            style: TextStyle(
                              color: mainGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _getTown({required int admCode}) async {
    final String apiUrl = 'https://api.vworld.kr/ned/data/admSiList';  // 기본 URL
    await dotenv.load(fileName: 'asset/config/.env');
    String? digitalApiKey = dotenv.env['DIGITAL_API_KEY'];
    print(digitalApiKey);
    Dio dio = Dio();
    try {
      // 쿼리 파라미터 동적 처리
      Response response = await dio.get(
        apiUrl,
        queryParameters: {
          'admCode': admCode, // admCode 파라미터
          'format': 'json',   // format 파라미터
          'key': digitalApiKey,      // API 키
        },
      );

      if (response.statusCode == 200) {
        // 요청이 성공적으로 처리되었을 때
        print('Response data: ${response.data}');

        // JSON 파싱은 자동으로 처리되므로 response.data를 사용하면 됩니다.
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // 에러 처리
      print('Error: $e');
    }
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
