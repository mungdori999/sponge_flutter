import 'package:flutter/material.dart';
import 'package:sponge_app/const/color_const.dart';

class Search extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback onSearch;
  final bool enabled;

  const Search({
    super.key,
    required this.enabled,
    required this.controller,
    required this.onSearch,
  });

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _isSearching = false; // 검색 중 상태를 추적하는 변수

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTextChange);
    super.dispose();
  }

  // 텍스트 필드의 텍스트 변경을 감지하여 상태를 업데이트
  void _handleTextChange() {
    if (widget.controller?.text.isEmpty ?? true) {
      setState(() {
        _isSearching = false; // 텍스트가 모두 삭제되면 검색 버튼으로 돌아가기
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearching) {
        widget.controller?.clear(); // 검색 종료 시 텍스트 필드 비우기
        _isSearching = false; // X 버튼을 눌러도 검색 버튼으로 돌아가기
      } else {
        widget.onSearch(); // 검색 실행
        _isSearching = true; // 검색 아이콘과 X 아이콘 전환
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        autofocus: widget.enabled,
        onSubmitted: (_) => _toggleSearch(), // 완료 버튼 클릭 시 검색 실행
        decoration: InputDecoration(
          hintText: '반려견의 문제행동이 궁금해요',
          hintStyle: TextStyle(
            color: mainGrey,
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainYellow, width: 1.5),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainYellow, width: 1.5),
            borderRadius: BorderRadius.circular(30),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainYellow, width: 1.5),
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isSearching ? Icons.clear : Icons.search,
              color: mainYellow,
            ),
            onPressed: _toggleSearch,
          ),
        ),
      ),
    );
  }
}
