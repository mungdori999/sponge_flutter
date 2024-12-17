import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class TrainerSuccess extends StatelessWidget {
  const TrainerSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: OutlinedButton(
            onPressed: () {
              Provider.of<PageIndexProvider>(context, listen: false)
                  .updateIndex(1);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (Route<dynamic> route) => false,
              );
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
              '문제활동 사례 보러가기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Text(
                '회원가입을 마쳤어요',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Text(
                '진단활동을 시작해보세요!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Image.asset('asset/img/success_img.png',width: 300,),
            ],
          ),
        ),
      ),
    );
  }
}
