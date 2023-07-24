import 'package:app_gs/widgets/wave_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/apps_controller.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/header.dart';
import 'banner.dart';
import 'hot.dart';
import 'popular.dart';

final logger = Logger();

class AppsScreen extends StatefulWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  AppsScreenState createState() => AppsScreenState();
}

class AppsScreenState extends State<AppsScreen> {
  final appsController = Get.find<AppsController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: '應用中心',
        ),
        body: CustomScrollView(
          physics: kIsWeb ? null : const BouncingScrollPhysics(),
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: BannerWidget(),
              ),
            ),
            if (appsController.isLoading.value)
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
              Obx(() => HotWidget(items: appsController.hot.value)),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              const SliverToBoxAdapter(
                child: Header(text: '大家都在玩'),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              Obx(() => PopularWidget(items: appsController.popular.value)),
              const SliverToBoxAdapter(
                child: SizedBox(height: 90),
              )
            ],
          ],
        ),
      ),
    );
  }
}
