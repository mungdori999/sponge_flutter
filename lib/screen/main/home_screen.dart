import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sponge_app/component/home/banner_button.dart';
import 'package:sponge_app/component/home/home_post_list.dart';
import 'package:sponge_app/component/search.dart';
import 'package:sponge_app/screen/search_screen.dart';
import 'package:sponge_app/util/page_index_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              ),
              child: Search(
                enabled: false,
                controller: _controller,
                onSearch: () {},
              ),
            ),
          ),
          BannerButton(),
          HomePostList(
            latestPostListPressed: latestPostListPressed,
          ),
        ],
      ),
    );
  }

  void latestPostListPressed() {
    context.read<PageIndexProvider>().updateIndex(1);
  }
}
