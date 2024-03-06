import 'package:app_gs/localization/i18n.dart';
import 'package:app_gs/widgets/wave_loading.dart';
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

class AppsScreen extends StatefulWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
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
                  padding: EdgeInsets.symmetric(horizontal: 8),
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
                SliverToBoxAdapter(
                  child: Header(text: I18n.recommended),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                HotWidget(items: hotAds),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                SliverToBoxAdapter(
                  child: Header(text: I18n.everbodyPlaying),
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
