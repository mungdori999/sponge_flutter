import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/util/page_index_provider.dart';

import 'screen/main/main_screen.dart';

void main() async {
  await dotenv.load(fileName: 'asset/config/.env');
  String? kakaoApiKey = dotenv.env['KAKAO_API_KEY'];
  KakaoSdk.init(
    nativeAppKey: kakaoApiKey,
  );
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 환경 초기화
  await initializeDateFormatting('ko_KR', null); // 한국어 날짜 형식 초기화

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageIndexProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
        },
        theme: ThemeData(
          fontFamily: 'Pretendard',
        ),
      ),
    ),
  );
}
