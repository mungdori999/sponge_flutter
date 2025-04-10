import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/const/page_index.dart';
import 'package:sponge_app/request/logout_request.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            await logout();
            Provider.of<PageIndexProvider>(context, listen: false)
                .updateIndex(PageIndex.HOME.value);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
                  (Route<dynamic> route) => false,
            );
          },
          child: const Text("로그아웃"),
        ),
      ),
    );
  }
}
