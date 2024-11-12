import 'package:app_wl_tw1/widgets/custom_app_bar.dart';
import 'package:app_wl_tw1/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import '../localization/i18n.dart';
import '../screens/purchase_record/short.dart';
import '../screens/purchase_record/video.dart';

final tabs = [I18n.longVideo, I18n.shortVideo];

class PurchaseRecordPage extends StatefulWidget {
  const PurchaseRecordPage({Key? key}) : super(key: key);

  @override
  PurchaseRecordPageState createState() => PurchaseRecordPageState();
}

class PurchaseRecordPageState extends State<PurchaseRecordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
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
          title: I18n.purchasePlaylist,
          bottom: TabBarWidget(tabs: tabs, controller: _tabController),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            PurchaseRecordVideoScreen(),
            PurchaseRecordShortScreen(),
          ],
        ));
  }
}
