import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/widgets/live_scaffold.dart';
import 'package:live_core/controllers/live_search_controller.dart';
import 'package:live_core/controllers/live_search_history_controller.dart';
import '../screens/search/input.dart';
import '../screens/search/keyword_list.dart';
import '../screens/search/popular_streamers.dart';
import '../screens/search/fan_recommendation.dart';
import '../screens/search/recent_searches.dart';
import '../screens/search/search_results.dart';

class SearchPage extends StatefulWidget {
  final String? query;

  SearchPage({Key? key, this.query}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> searchResults = [];
  String keyword = '';
  bool displayKeywordResult = false;
  bool displaySearchResult = false;

  @override
  void initState() {
    super.initState();
  }

  onSearch(String value) {
    if (value.isEmpty) {
      onCancel();
      return;
    }
    setState(() {
      keyword = value;
      displayKeywordResult = false;
      displaySearchResult = true;
    });

    Get.find<LiveSearchHistoryController>().add(keyword);
    Get.find<LiveSearchController>().search(keyword);
  }

  onCancel() {
    setState(() {
      keyword = '';
      displaySearchResult = false;
      displayKeywordResult = false;
    });
    Get.find<LiveSearchController>().clearSearchResult();
  }

  @override
  Widget build(BuildContext context) {
    return LiveScaffold(
      backgroundColor: const Color(0xFF242a3d),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 16)),
                  Expanded(
                    child: SearchInputWidget(
                      showCancel: displayKeywordResult || displaySearchResult,
                      onChanged: (value) {
                        setState(() {
                          keyword = value;
                          displayKeywordResult = true;
                        });
                        Get.find<LiveSearchController>().getKeywords(keyword);
                      },
                      onSearch: onSearch,
                      onCancel: onCancel,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onSearch(keyword),
                    child: const Text(
                      '搜尋',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )
                ],
              ),
              Expanded(
                child: displayKeywordResult
                    ? KeywordList(onSearch: (value) => onSearch(value))
                    : displaySearchResult
                        ? SearchResults()
                        : RecommendScreen(onSearch: (value) => onSearch(value)),
              ),
            ],
          )),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff6f6f79),
          fontSize: 14,
        ),
      ),
    );
  }
}

class RecommendScreen extends StatelessWidget {
  final Function(String)? onSearch;

  const RecommendScreen({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: RecentSearches(onSearch: onSearch)),
        const SliverToBoxAdapter(child: SectionTitle(title: '粉絲推薦')),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          sliver: FanRecommendationWidget(),
        ),
        const SliverToBoxAdapter(child: SectionTitle(title: '熱門推薦')),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          sliver: PopularStreamersWidget(),
        ),
      ],
    );
  }
}
