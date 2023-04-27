import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/header.dart';
import 'banner.dart';
import 'hot.dart';
import 'popular.dart';

final logger = Logger();

class AppsScreen extends StatelessWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: '應用中心',
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: BannerWidget(),
            ),
          ),
          SliverToBoxAdapter(
            child: Header(text: '熱門推薦'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          HotWidget(),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Header(text: '大家都在玩'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          PopularWidget(),
          SliverToBoxAdapter(
            child: SizedBox(height: 90),
          )
        ],
      ),
    );
  }
}
