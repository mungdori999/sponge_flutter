import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sponge_app/component/home/home_post_card.dart';
import 'package:sponge_app/component/user/add_pet.dart';
import 'package:sponge_app/component/user/pet_card_list.dart';
import 'package:sponge_app/component/user/user_profile.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/pet/pet.dart';
import 'package:sponge_app/data/post/post_list_response.dart';
import 'package:sponge_app/data/user/user.dart';
import 'package:sponge_app/data/user/user_auth.dart';
import 'package:sponge_app/request/pet_image_request.dart';
import 'package:sponge_app/request/pet_request.dart';
import 'package:sponge_app/request/post_request.dart';
import 'package:sponge_app/request/user_request.dart';
import 'package:sponge_app/screen/post_screen.dart';
import 'package:sponge_app/token/jwtUtil.dart';

class MyPageUserScreen extends StatefulWidget {
  final LoginAuth loginAuth;

  MyPageUserScreen({super.key, required this.loginAuth});

  @override
  State<MyPageUserScreen> createState() => _MyPageUserScreenState();
}

class _MyPageUserScreenState extends State<MyPageUserScreen> {
  JwtUtil jwtUtil = JwtUtil();

  UserResponse? user;

  List<Pet> petList = [];
  List<Post> postList = [];

  int currentPage = 0;
  bool isLoading = false;
  bool hasMorePosts = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    final myInfo = await getMyUserInfo();
    final myPet = await getMyPet();
    final myPost = await getMyPost(currentPage);
    for (var pet in myPet) {
      if (pet.petImgUrl != "") await getPetImg(pet.petImgUrl, pet.id);
    }
    setState(() {
      user = myInfo;
      petList = myPet;
      postList.addAll(myPost);
      currentPage++;
    });
  }

  Future<void> _fetchMorePosts() async {
    if (isLoading || !hasMorePosts) return;
    setState(() {
      isLoading = true;
    });

    try {
      final newPosts = await getMyPost(currentPage);
      setState(() {
        if (newPosts.isEmpty) {
          hasMorePosts = false;
        } else {
          postList.addAll(newPosts);
          currentPage++;
        }
      });
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _fetchMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (user != null) UserProfile(user: user!),
                  if (petList.isNotEmpty)
                    PetCardList(
                      petList: petList,
                      myPage: true,
                    )
                  else
                    AddPet(),
                  SizedBox(height: 4),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 8,
              color: lightGrey,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '활동 내역',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  ...postList
                      .map(
                        (post) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostScreen(id: post.id),
                            ),
                          ),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: HomePostCard(post: post),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  if (isLoading)
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (!hasMorePosts)
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('더 이상 게시글이 없습니다.'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
