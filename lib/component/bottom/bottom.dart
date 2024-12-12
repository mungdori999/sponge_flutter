import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';

class Bottom extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  const Bottom({super.key, required this.selectedIndex, required this.onTap});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      backgroundColor: Colors.white,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: mainYellow,
      unselectedItemColor: mainGrey,
      selectedLabelStyle: TextStyle(color: mainYellow),
      unselectedLabelStyle: TextStyle(color: mainGrey),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '진단사례',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: '내진단',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'MY',
        ),
      ],
    );
  }
}
