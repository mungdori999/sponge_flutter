import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sponge_app/const/city.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';

class AddressProfile extends StatefulWidget {
  AddressProfile({super.key});

  @override
  State<AddressProfile> createState() => _AddressProfileState();
}

class _AddressProfileState extends State<AddressProfile> {
  String city = '';
  String town = '';
  List<String> townList = [];
  List<String> cityList = City.values.map((city) => city.address).toList();
  List<AddressCreate> addressList = [];

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
      body: SingleChildScrollView(
        child: Padding(
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
                    children: [
                      ...cityList.map((city) {
                        return GestureDetector(
                          onTap: () async {
                            List<String> lowestAdmCodeNmList = await _getTown(
                                admCode: City.getCodeByAddress(city));
                            setState(() {
                              this.city = city;
                              this.townList = lowestAdmCodeNmList;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            // 아이템 간격
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            // 내용 여백
                            decoration: BoxDecoration(
                              color: this.city == city ? mainYellow : lightGrey,
                              // 배경색 (회색)
                              borderRadius: BorderRadius.circular(8), // 둥근 모서리
                            ),
                            child: Center(
                              child: Text(
                                city, // 텍스트 (도시 이름)
                                style: TextStyle(
                                  color: this.city == city
                                      ? Colors.white
                                      : mainGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  ...addressList.map((address) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 4), // 수평 패딩만 설정하여 위아래 패딩 없앰
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: mainYellow, // 테두리 색상
                          width: 1, // 테두리 두께
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${address.city} > ${address.town}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: mainYellow, // 텍스트 색상
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            icon: Icon(Icons.cancel), // X 아이콘
                            padding: EdgeInsets.zero,  // 기본 패딩 제거
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
              Column(
                children: [
                  ...townList.map((town) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          this.town = town;
                          addressList.add(
                              new AddressCreate(city: city, town: this.town));
                        });
                      },
                      child: Container(
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
                          child: Text(
                            town,
                            style: TextStyle(
                                color:
                                    this.town == town ? mainYellow : mainGrey,
                                fontSize: 16),
                          ),
                        ), // town 값을 Text로 표시
                      ),
                    );
                  }).toList(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> _getTown({required int admCode}) async {
    final String apiUrl = 'https://api.vworld.kr/ned/data/admSiList'; // 기본 URL
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
          'format': 'json', // format 파라미터
          'numOfRows': 100,
          'key': digitalApiKey, // API 키
        },
      );

      if (response.statusCode == 200) {
        // JSON 파싱 후 admCodeNm 리스트 추출
        List<dynamic> admVOList = response.data['admVOList']['admVOList'];
        List<String> lowestAdmCodeNmList =
            admVOList.map((item) => item['lowestAdmCodeNm'] as String).toList();
        // admCodeNm 리스트 출력
        return lowestAdmCodeNmList;
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // 에러 처리
      print('Error: $e');
    }
    return [];
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
