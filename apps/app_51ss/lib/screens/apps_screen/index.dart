import 'package:app_51ss/widgets/wave_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/ad.dart';
import 'package:shared/modules/apps/apps_provider.dart';

import '../../widgets/header.dart';
import 'banner.dart';
import 'hot.dart';
import 'popular.dart';

final logger = Logger();

class AppsScreen extends StatelessWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppsProvider(
      child: ((
              {required List<Ads> popularAds,
              required List<Ads> hotAds,
              required bool isLoading}) =>
          CustomScrollView(
            physics: kIsWeb ? null : const BouncingScrollPhysics(),
            slivers: <Widget>[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8),
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
                  child: Header(text: '熱門推薦'),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                HotWidget(items: hotAds),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                const SliverToBoxAdapter(
                  child: Header(text: '大家都在玩'),
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
    );
  }
}
