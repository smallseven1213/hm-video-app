import 'package:flutter/material.dart';
import 'package:shared/models/ad.dart';
import 'package:shared/widgets/apps_builder.dart';

import '../widgets/my_app_bar.dart';
import '../widgets/wave_loading.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: '應用中心',
        ),
        body: AppsBuilder(
          child: ((
                  {required List<Ads> popularAds,
                  required List<Ads> hotAds,
                  required bool isLoading}) =>
              CustomScrollView(
                slivers: <Widget>[
                  // const SliverToBoxAdapter(
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 8),
                  //     child: BannerWidget(),
                  //   ),
                  // ),
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
                    // const SliverToBoxAdapter(
                    //   child: Header(text: '熱門推薦'),
                    // ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                    // HotWidget(items: hotAds),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                    // const SliverToBoxAdapter(
                    //   child: Header(text: '大家都在玩'),
                    // ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                    // PopularWidget(items: popularAds),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 90),
                    )
                  ],
                ],
              )),
        ));
  }
}
