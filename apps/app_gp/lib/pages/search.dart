import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/navigator/delegate.dart';

import '../screens/search/recommand.dart';
import '../widgets/search_input.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  BannerController bannerController = Get.find<BannerController>();
  Timer? _debounceTimer;
  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer != null) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      _search();
    });
  }

  Future<void> _search() async {
    String keyword = _searchController.text;
    List<String> results = List<String>.generate(500, (index) {
      return _generateRandomString(5);
    });

    setState(() {
      _searchResults = results;
    });
  }

  String _generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left,
              color: Colors.white), // 或其他顏色
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SearchInput(
          controller: _searchController,
          onChanged: (value) {
            // 處理文本更改的邏輯
          },
          onSubmitted: (value) {
            // 處理文本提交的邏輯
          },
          onTap: () {
            // 處理點擊事件的邏輯，如果需要
          },
          defaultValue: '神级美乳AV女优', // 如果需要，可以提供一個預設值
          // autoFocus: true, // 根據需要自動聚焦
        ),
      ),
      body: _searchController.value.text.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      MyRouteDelegate.of(context).push('/search_result', args: {
                        'keyword': _searchResults[index],
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xff7AA2C8).withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          _searchResults[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : RecommandScreen(),
    );
  }
}
