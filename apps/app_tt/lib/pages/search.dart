import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'dart:async';
import 'package:shared/controllers/search_page_data_controller.dart';
import 'package:shared/controllers/user_search_history_controller.dart';

import '../screens/search/recommand.dart';
import '../screens/search/search_result.dart';

final vodApi = VodApi();

class SearchPage extends StatefulWidget {
  final String? inputDefaultValue;
  final bool? autoSearch;
  const SearchPage({Key? key, this.inputDefaultValue, this.autoSearch = false})
      : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool displaySearchResult = false;
  final searchPageDataController = Get.put(SearchPageDataController());

  @override
  void initState() {
    super.initState();
    if (widget.autoSearch == true) {
      // Set keyword value in SearchPageDataController.
      searchPageDataController.setKeyword(widget.inputDefaultValue ?? '');
    } else {
      _searchController.text = searchPageDataController.keyword.value;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer != null) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      _search();
    });

    if (_searchController.text.isEmpty) {
      setState(() {
        displaySearchResult = false;
      });
      searchPageDataController.setKeyword('');
    } else {
      setState(() {
        displaySearchResult = true;
      });
    }
  }

  Future<void> _search() async {
    // Get keyword from SearchPageDataController.
    String keyword = _searchController.text;

    if (keyword.isNotEmpty) {
      var results = await vodApi.getSearchKeyword(keyword);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var searchKeyword = searchPageDataController.keyword.value;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            color: const Color(0xFF2e3039),
            icon: const Icon(Icons.arrow_back_ios_new, size: 16),
            onPressed: () {
              if (searchKeyword != '') {
                setState(() {
                  displaySearchResult = false;
                });
                searchPageDataController.setKeyword('');
                _searchController.value = TextEditingValue.empty;
                FocusScope.of(context).requestFocus(FocusNode());
              } else {
                Navigator.pop(context);
              }
            },
          ),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F4),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(
                      'assets/svgs/ic-search.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                          Color(0xff50525a), BlendMode.srcIn),
                    ),
                    onPressed: () {
                      // 你的放大鏡按鈕邏輯
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        _onSearchChanged(value);
                      },
                      onSubmitted: (value) {
                        setState(() {
                          displaySearchResult = false;
                        });
                        searchPageDataController
                            .setKeyword(_searchController.text);
                        Get.find<UserSearchHistoryController>()
                            .add(_searchController.text);
                      },
                      onTap: () {
                        // 處理點擊事件的邏輯，如果需要
                      },
                      style: const TextStyle(color: Color(0xff50525a)),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                var getSearchKeyword = _searchController.text.isEmpty
                    ? widget.inputDefaultValue
                    : _searchController.text;
                searchPageDataController.setKeyword(getSearchKeyword!);

                if (searchKeyword != '') {
                  displaySearchResult = false;
                  _searchController.text = getSearchKeyword;
                  Get.find<UserSearchHistoryController>().add(getSearchKeyword);
                }
                setState(() {});
              },
              child: Text(
                I18n.searchFor,
                style: const TextStyle(
                  color: Color(0xFFfe2c55),
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            searchKeyword == ''
                // 預設的搜尋頁面
                ? RecommandScreen(
                    onClickTag: (tag) {
                      setState(() {
                        displaySearchResult = false;
                      });
                      searchPageDataController.setKeyword(tag);
                      Get.find<UserSearchHistoryController>().add(tag);
                      _searchController.text = tag;
                    },
                  )
                // 點擊"文字搜尋結果"後呈現的影片列表
                : SearchResultPage(
                    keyword: searchKeyword,
                    key: ValueKey(searchKeyword),
                  ),
            if (displaySearchResult)
              // 文字搜尋結果
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            displaySearchResult = false;
                          });
                          searchPageDataController
                              .setKeyword(_searchResults[index]);
                          _searchController.text = _searchResults[index];

                          Get.find<UserSearchHistoryController>()
                              .add(_searchResults[index]);

                          FocusScope.of(context).requestFocus(FocusNode());
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
    });
  }
}
