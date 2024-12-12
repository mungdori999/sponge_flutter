import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';

class NextButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback nextPressed;

  const NextButton({super.key, required this.enabled, required this.nextPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: OutlinedButton(
          onPressed: enabled ? nextPressed : null,
          style: OutlinedButton.styleFrom(
            backgroundColor: enabled ? mainYellow : lightGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            side: BorderSide.none,
            minimumSize: Size(double.infinity, 48),
          ),
          child: Text(
            '다음',
            style: TextStyle(
              color: enabled ? Colors.white : mainGrey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
