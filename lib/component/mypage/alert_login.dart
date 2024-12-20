import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class AlertLogin extends StatelessWidget {
  const AlertLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('주의'),
      content: Text('로그인이 필요합니다.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Provider.of<PageIndexProvider>(context, listen: false)
                .updateIndex(0);
          },
          child: Text('닫기'),
        ),
      ],
    );
  }
}
