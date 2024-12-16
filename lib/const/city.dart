enum City {
  SEOUL(code: 11, address: '서울'),
  BUSAN(code: 26, address: '부산'),
  DAEGU(code: 27, address: '대구'),
  INCHEON(code: 28, address: '인천'),
  GWANGJU(code: 29, address: '광주'),
  DAEJEON(code: 30, address: '대전'),
  ULSAN(code: 31, address: '울산'),
  SEJONG(code: 36, address: '세종'),
  GYEONGGI(code: 41, address: '경기도'),
  CHUNGBUK(code: 43, address: '충북'),
  CHUNGNAM(code: 44, address: '충남'),
  JEONNAM(code: 46, address: '전남'),
  GYEONGBUK(code: 47, address: '경북'),
  GYEONGNAM(code: 48, address: '경남'),
  JEJU(code: 50, address: '제주'),
  JEONBUK(code: 52, address: '전북');

  // Properties
  final int code;
  final String address;

  // Constructor
  const City({required this.code, required this.address});
  static int getCodeByAddress(String address) {
    try {
      return City.values.firstWhere((city) => city.address == address).code;
    } catch (e) {
      throw ArgumentError('Invalid address: $address');
    }
  }
}