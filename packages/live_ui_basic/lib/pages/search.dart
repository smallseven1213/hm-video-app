import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_search_controller.dart';
import 'package:live_core/controllers/live_search_history_controller.dart';
import '../localization/live_localization_delegate.dart';
import '../screens/search/input.dart';
import '../screens/search/keyword_list.dart';
import '../screens/search/popular_streamers.dart';
import '../screens/search/fan_recommendation.dart';
import '../screens/search/recent_searches.dart';
import '../screens/search/search_results.dart';

class SearchPage extends StatefulWidget {
  final String? query;

  const SearchPage({Key? key, this.query}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<String> searchResults = [];
  String keyword = '';
  bool displayKeywordResult = false;
  bool displaySearchResult = false;
  late LiveSearchController liveSearchController;
  late LiveSearchHistoryController liveSearchHistoryController;

  @override
  void initState() {
    super.initState();
    liveSearchController = Get.put(LiveSearchController());
    liveSearchHistoryController = Get.put(LiveSearchHistoryController());
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

    liveSearchHistoryController.add(keyword);
    liveSearchController.search(keyword);
  }

  onCancel() {
    setState(() {
      keyword = '';
      displaySearchResult = false;
      displayKeywordResult = false;
    });
    liveSearchController.clearSearchResult();
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF242a3d),
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Row(
            children: [
              const SizedBox(width: 40),
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
                child: Text(
                  localizations.translate('search'),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFF242a3d),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: displayKeywordResult
                        ? KeywordList(onSearch: (value) => onSearch(value))
                        : displaySearchResult
                            ? SearchResults()
                            : RecommendScreen(
                                onSearch: (value) => onSearch(value)),
                  ),
                ],
              )),
        ),
      ),
      backgroundColor: const Color(0xFF242a3d),
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
          fontSize: 16,
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
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: RecentSearches(onSearch: onSearch)),
        SliverToBoxAdapter(
            child: SectionTitle(
                title: localizations.translate('fan_recommendations'))),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          sliver: FanRecommendationWidget(),
        ),
        SliverToBoxAdapter(
            child: SectionTitle(
                title: localizations.translate('hot_recommendations'))),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          sliver: PopularStreamersWidget(),
        ),
      ],
    );
  }
}
