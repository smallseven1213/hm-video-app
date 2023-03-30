// FavoritesPage have 2 tabs, first tab is "Video", and second is "Actor"
// tab button is from widgets/button.dart
// and position of tab that is under the AppBar, and fixed on top
// Video and Actor are from screens/favorites/video.dart and screens/favorites/actor.dart
// default tab is Video

import 'package:app_gp/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/button.dart';
import '../screens/favorites/video.dart';
import '../screens/favorites/actor.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '我的喜歡',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Button(
                    text: 'Video',
                    size: 'small',
                    onPressed: () => _tabController.animateTo(0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Button(
                    text: 'Actor',
                    size: 'small',
                    onPressed: () => _tabController.animateTo(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FavoritesVideoScreen(),
          FavoritesActorScreen(),
        ],
      ),
    );
  }
}
