import 'package:flutter/material.dart';


class ChatMessageTop extends StatelessWidget {
  final String dearName;
  const ChatMessageTop({super.key, required this.dearName});

  @override
  Widget build(BuildContext context) {
    return Text(dearName, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),);
  }
}
