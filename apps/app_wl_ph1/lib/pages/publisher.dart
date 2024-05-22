import 'package:app_wl_ph1/localization/i18n.dart';
import 'package:app_wl_ph1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/publisher_controller.dart';
import '../screens/vendor_videos/list.dart';
import '../widgets/tab_bar.dart';

class PublisherPage extends StatefulWidget {
  final int id;
  const PublisherPage({Key? key, required this.id}) : super(key: key);

  @override
  VendorVideosPageState createState() => VendorVideosPageState();
}

class VendorVideosPageState extends State<PublisherPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PublisherController publisherController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    publisherController = PublisherController(
      publisherId: widget.id,
    );
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
        titleWidget: Obx(() => Text(
              publisherController.publisher.value.name,
              style: const TextStyle(
                fontSize: 15,
              ),
            )),
        bottom: GSTabBar(
            tabs: [I18n.newest, I18n.hottest], controller: _tabController),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          VendorVideoList(
            type: 'new',
            publisherId: widget.id,
            displayVideoFavoriteTimes: false,
          ),
          VendorVideoList(
            type: 'hot',
            publisherId: widget.id,
            displayVideoFavoriteTimes: false,
          ),
        ],
      ),
    );
  }
}
