import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/ad.dart';
import 'package:shared/modules/apps/apps_provider.dart';

import '../screens/apps_screen/banner.dart';
import '../screens/apps_screen/hot.dart';
import '../screens/apps_screen/popular.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/title_header.dart';
import '../widgets/loading_animation.dart';

class AppsPage extends StatelessWidget {
  const AppsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: MyAppBar(
            title: I18n.appCenter,
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
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 150),
                          child: LoadingAnimation(),
                        ),
                      )
                    else ...[
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TitleHeader(text: I18n.popularRecommendation),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                      HotWidget(items: hotAds),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TitleHeader(text: I18n.everbodyPlaying),
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
