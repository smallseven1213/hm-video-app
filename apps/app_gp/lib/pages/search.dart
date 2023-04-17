import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'dart:async';
import 'package:shared/controllers/banner_controller.dart';

import '../screens/search/recommand.dart';
import '../screens/search/search_result.dart';
import '../widgets/search_input.dart';

final vodApi = VodApi();
final logger = Logger();

class SearchPage extends StatefulWidget {
  final String? inputDefaultValue;
  final bool? dontSearch;
  const SearchPage({Key? key, this.inputDefaultValue, this.dontSearch = false})
      : super(key: key);

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
    if (widget.dontSearch == false) {
      searchKeyword = widget.inputDefaultValue;
    } else {
      // _searchController.value = null;
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
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Padding(
          // padding right 10
          padding: const EdgeInsets.only(right: 8),
          child: SearchInput(
            controller: _searchController,
            onChanged: (value) {
              _onSearchChanged(value);
            },
            onSubmitted: (value) {
              setState(() {
                searchKeyword = _searchController.text;
                displaySearchResult = false;
              });
            },
            onTap: () {
              // 處理點擊事件的邏輯，如果需要
            },
            onSearchButtonClick: () {
              setState(() {
                searchKeyword = _searchController.text;
                displaySearchResult = false;
              });
            },
            defaultValue:
                widget.dontSearch == true ? null : widget.inputDefaultValue,
            placeHolder: widget.inputDefaultValue,
          ),
        ),
      ),
      body: Stack(
        children: [
          searchKeyword == null
              ? RecommandScreen(
                  onClickTag: (tag) {
                    setState(() {
                      searchKeyword = tag;
                      displaySearchResult = false;
                    });
                    _searchController.text = tag;
                  },
                )
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
