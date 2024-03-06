import 'package:flutter/material.dart';
import 'package:shared/models/ad.dart';
import 'package:shared/modules/apps/apps_provider.dart';

import '../screens/apps_screen/banner.dart';
import '../screens/apps_screen/hot.dart';
import '../screens/apps_screen/popular.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/title_header.dart';
import '../widgets/wave_loading.dart';

class AppsPage extends StatelessWidget {
  const AppsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: const MyAppBar(
            title: '應用中心',
          ),
          body: AppsProvider(
            child: ((
                    {required List<Ads> popularAds,
                    required List<Ads> hotAds,
                    required bool isLoading}) =>
                CustomScrollView(
                  slivers: <Widget>[
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: BannerWidget(),
                      ),
                    ),
                    if (isLoading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: WaveLoading(),
                        ),
                      )
                    else ...[
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TitleHeader(text: '熱門推薦'),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                      HotWidget(items: hotAds),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TitleHeader(text: '大家都在玩'),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                      PopularWidget(items: popularAds),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 90),
                      )
                    ],
                  ],
                )),
          )),
    );
  }
}
