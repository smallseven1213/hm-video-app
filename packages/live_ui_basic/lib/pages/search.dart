import 'package:flutter/material.dart';
import 'package:live_core/widgets/live_scaffold.dart';
import '../screens/search/input.dart';
import '../screens/search/popular_streamers.dart';
import '../screens/search/fan_recommendation.dart';
import '../screens/search/recent_searches.dart';

class SearchPage extends StatefulWidget {
  final String? query;

  SearchPage({Key? key, this.query}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    // TODO: Call your search API here and update the searchResults list.
  }

  @override
  Widget build(BuildContext context) {
    return LiveScaffold(
      backgroundColor: const Color(0xFF242a3d),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 50),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                      child: SearchInputWidget(
                          query: widget.query,
                          onSearch: (value) {
                            print('onSearch: 關鍵字搜尋 $value');
                          })),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '搜尋',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SectionTitle(title: '最近搜尋')),
            SliverToBoxAdapter(
              child: RecentSearches(),
            ),
            const SliverToBoxAdapter(child: SectionTitle(title: '粉絲推薦')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              sliver: FanRecommendationWidget(),
            ),
            const SliverToBoxAdapter(child: SectionTitle(title: '熱門推薦')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              sliver: PopularStreamersWidget(),
            ),
          ],
        ),
      ),
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
        style: TextStyle(
          color: Color(0xff6f6f79),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
