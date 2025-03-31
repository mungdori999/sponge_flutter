import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/component/bottom/bottom.dart';
import 'package:sponge_app/component/top/chat_room_top.dart';
import 'package:sponge_app/component/top/common_top.dart';
import 'package:sponge_app/component/top/home_top.dart';
import 'package:sponge_app/component/top/my_page_top.dart';
import 'package:sponge_app/component/top/post_list_top.dart';
import 'package:sponge_app/component/top/profile_top.dart';
import 'package:sponge_app/screen/chat/chat_room_screen.dart';
import 'package:sponge_app/screen/chat/chat_screen.dart';
import 'package:sponge_app/screen/main/home_screen.dart';
import 'package:sponge_app/screen/main/select_my_activity.dart';
import 'package:sponge_app/screen/main/post_list_screen.dart';
import 'package:sponge_app/screen/main/select_my_page.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class MainScreen extends StatelessWidget {
  final List<Widget> _pages = [
    HomeScreen(),
    PostListScreen(),
    SelectMyActivity(),
    ChatRoomScreen(),
    SelectMyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<PageIndexProvider>(
      builder: (context, pageIndexProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: _getAppBarTitle(pageIndexProvider.selectedIndex),
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
          ),
          body: _pages[pageIndexProvider.selectedIndex],
          bottomNavigationBar: Bottom(
            selectedIndex: pageIndexProvider.selectedIndex,
            onTap: (index) => pageIndexProvider.updateIndex(index),
          ),
        );
      },
    );
  }

  Widget _getAppBarTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return HomeTop();
      case 1:
        return PostListTop();
      case 2:
        return CommonTop();
      case 3:
        return ChatRoomTop();
      case 4:
        return MyPageTop();
      default:
        return Container();
    }
  }
}
