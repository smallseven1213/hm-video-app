import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../../config/colors.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/header.dart';
import 'banner.dart';
import 'hot.dart';
import 'popular.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '應用中心',
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: BannerWidget(),
          ),
          const SliverToBoxAdapter(
            child: Header(text: '熱門推薦'),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          const HotWidget(),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          const SliverToBoxAdapter(
            child: Header(text: '大家都在玩'),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          const PopularWidget(),
          const SliverToBoxAdapter(
            child: SizedBox(height: 90),
          )
        ],
      ),
    );
  }
}
