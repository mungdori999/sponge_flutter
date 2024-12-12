import 'package:flutter/material.dart';

class PageIndexProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners(); // 모든 리스너에게 상태가 변경되었음을 알림
  }
}
