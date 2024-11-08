import 'package:flutter/material.dart';

import '../../localization/i18n.dart';
import '../../widgets/tab_bar.dart';
import 'coin_product_list.dart';

class CoinTabSection extends StatefulWidget {
  const CoinTabSection({super.key});

  @override
  CoinTabSectionState createState() => CoinTabSectionState();
}

class CoinTabSectionState extends State<CoinTabSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);

    // 監聽tab滑動
    _tabController.animation!.addListener(() {
      if (_tabController.animation!.value % 1 != 0) {
        // 如果動畫值不是整數，表示滑動正在進行中
      }
    });
  }

  @override
  void dispose() {
    _tabController.animation!.removeListener(() {}); // 別忘了在 dispose 中移除監聽器
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xff1c202f),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(8),
          child: TabBarWidget(
            bgColor: const Color(0xff1c202f),
            tabs: [I18n.coin, I18n.purchaseRecord, I18n.depositRecord],
            controller: _tabController,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [CoinProductList(), SizedBox(), SizedBox()],
          ),
        ),
      ],
    );
  }
}
