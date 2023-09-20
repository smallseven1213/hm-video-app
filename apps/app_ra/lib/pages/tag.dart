import 'package:flutter/material.dart';

import '../screens/tag/tag_for_shorts.dart';
import '../screens/tag/tag_for_videos.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/ra_tab_bar.dart';

class TagPage extends StatefulWidget {
  final int id;
  final String title;
  final int film;
  final int? defaultTabIndex;

  const TagPage({
    Key? key,
    required this.id,
    required this.title,
    this.film = 1,
    this.defaultTabIndex,
  }) : super(key: key);

  @override
  TagPageState createState() => TagPageState();
}

class TagPageState extends State<TagPage> with SingleTickerProviderStateMixin {
  // DISPOSED SCROLL CONTROLLER

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this, length: 2, initialIndex: widget.defaultTabIndex ?? 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: Text(
          '#${widget.title}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFFFDDCEF),
          ),
        ),
        bottom:
            RATabBar(tabs: const ['長視頻', '短視頻'], controller: _tabController),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TagForVideos(
            tagId: widget.id,
          ),
          TagForShorts(
            tagId: widget.id,
          ),
        ],
      ),
    );
  }
}
