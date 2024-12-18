import 'package:flutter/material.dart';
import 'package:sponge_app/component/trainer/trainer_profile.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/trainer/trainer.dart';
import 'package:sponge_app/request/trainer_reqeust.dart';

class MyPageTrainerScreen extends StatefulWidget {
  const MyPageTrainerScreen({super.key});

  @override
  State<MyPageTrainerScreen> createState() => _MyPageTrainerScreenState();
}

class _MyPageTrainerScreenState extends State<MyPageTrainerScreen> {
  Trainer? trainer;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final myInfo = await getMyInfo();

    setState(() {
      trainer = myInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (trainer == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TrainerProfile(
              trainer: trainer!,
            ),
          ),
          Container(
            width: double.infinity,
            height: 8,
            color: lightGrey,
          ),
        ],
      ),
    );
  }
}
