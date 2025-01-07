import 'package:flutter/material.dart';
import 'package:sponge_app/component/top/register_top.dart';
import 'package:sponge_app/const/color_const.dart';
import 'package:sponge_app/data/user/user_update.dart';
import 'package:sponge_app/data/user/user.dart';
import 'package:sponge_app/request/user_request.dart';

class UpdateUser extends StatefulWidget {
  final UserResponse user;

  const UpdateUser({super.key, required this.user});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late TextEditingController _nameController;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _nameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _nameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      // 모든 TextField가 입력되었는지 확인
      _isButtonEnabled = _nameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: RegisterTop(),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: OutlinedButton(
              onPressed: _isButtonEnabled
                  ? () async {
                      UserUpdate userUpdate =
                          new UserUpdate(name: _nameController.text);
                      await updateUser(widget.user.id, userUpdate);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                            (Route<dynamic> route) => false,
                      );
                    }
                  : null,
              style: OutlinedButton.styleFrom(
                backgroundColor: _isButtonEnabled ? mainYellow : lightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                side: BorderSide.none,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                '완료',
                style: TextStyle(
                  color: _isButtonEnabled ? Colors.white : mainGrey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '기본 정보를 입력해주세요',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    '견주 닉네임',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  _RequiredStar(),
                ],
              ),
              TextField(
                controller: _nameController,
                cursorColor: mainYellow,
                decoration: InputDecoration(
                  hintText: '예) 홀길동',
                  hintStyle: TextStyle(
                    color: mainGrey,
                  ),
                  focusColor: mainGrey,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightGrey, width: 1),
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainGrey, width: 1),
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequiredStar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '*',
      style: TextStyle(
        color: Colors.red,
        fontSize: 16, // 원하는 크기로 설정
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
