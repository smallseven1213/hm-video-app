import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'dart:async';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/navigator/delegate.dart';

import '../screens/search/recommand.dart';
import '../screens/search/search_result.dart';
import '../widgets/search_input.dart';

final vodApi = VodApi();
final logger = Logger();

class SearchPage extends StatefulWidget {
  final String? inputDefaultValue;
  const SearchPage({Key? key, this.inputDefaultValue}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  BannerController bannerController = Get.find<BannerController>();
  Timer? _debounceTimer;
  String? searchKeyword;
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool displaySearchResult = false;

  @override
  void initState() {
    super.initState();
    searchKeyword = widget.inputDefaultValue;
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

    if (_searchController.text.isEmpty) {
      setState(() {
        displaySearchResult = false;
        searchKeyword = null;
      });
    } else {
      setState(() {
        displaySearchResult = true;
      });
    }
  }

  Future<void> _search() async {
    String keyword = _searchController.text;

    var results = await vodApi.getSearchKeyword(keyword);
    setState(() {
      _searchResults = results;
    });
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
          defaultValue: widget.inputDefaultValue, // 如果需要，可以提供一個預設值
          // autoFocus: true, // 根據需要自動聚焦
        ),
      ),
      body: Stack(
        children: [
          searchKeyword == null
              ? RecommandScreen()
              : SearchResultPage(
                  keyword: searchKeyword!,
                  key: ValueKey(searchKeyword),
                ),
          if (displaySearchResult)
            // 文字搜尋結果
            Container(
              color: const Color(0xFF001A40),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          searchKeyword = _searchResults[index];
                          displaySearchResult = false;
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
              ),
            )
        ],
      ),
    );
  }
}

// TODO, 如果點擊了input，然後input又有值，然後displaySearchResult為false; displaySearchResult就設定true
