import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sponge_app/const/city.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer_create.dart';

class AddressProfile extends StatefulWidget {
  final List<AddressCreate> addressList;

  AddressProfile({super.key, required this.addressList});

  @override
  State<AddressProfile> createState() => _AddressProfileState();
}

class _AddressProfileState extends State<AddressProfile> {
  String selectedCity = '';
  List<String> townList = [];
  List<String> cityList = City.values.map((city) => city.address).toList();
  List<AddressCreate> addressList = [];

  @override
  void initState() {
    super.initState();
    this.addressList =
        widget.addressList.map((address) => address.copy()).toList();
  }

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
            Navigator.pop(context);
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
              widget.addressList.clear();
              widget.addressList.addAll(addressList.map((address)=>address.copy()).toList());
              Navigator.pop(context);
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
                              this.selectedCity = city;
                              this.townList = lowestAdmCodeNmList;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: this.selectedCity == city
                                  ? mainYellow
                                  : lightGrey,
                              borderRadius: BorderRadius.circular(8), // 둥근 모서리
                            ),
                            child: Center(
                              child: Text(
                                city, // 텍스트 (도시 이름)
                                style: TextStyle(
                                  color: this.selectedCity == city
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
              Container(
                height: 30,
                child: ListView(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...addressList.map((address) {
                      return Container(
                        margin: EdgeInsets.only(right: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: mainYellow, // 텍스트 색상
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  addressList.remove(address);
                                });
                              },
                              child: Icon(
                                Icons.close,
                                color: mainYellow,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              Column(
                children: [
                  ...townList.map((town) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          addressList.add(new AddressCreate(
                              city: selectedCity, town: town));
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
                                color: addressList.any(
                                          (address) =>
                                              address.city == this.selectedCity,
                                        ) &&
                                        addressList.any(
                                          (address) => address.town == town,
                                        )
                                    ? mainYellow
                                    : mainGrey,
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
