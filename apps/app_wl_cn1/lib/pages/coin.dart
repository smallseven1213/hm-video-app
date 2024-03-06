import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';

import '../../utils/show_confirm_dialog.dart';
import '../../widgets/id_card.dart';
import '../screens/coin/order_record.dart';
import '../screens/coin/products.dart';
import '../screens/coin/purchase_record.dart';
import '../screens/user_screen/info.dart';
import '../widgets/coin_tab_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/tab_bar.dart';
import '../widgets/user/balance.dart';

final logger = Logger();

class CoinPage extends StatefulWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  CoinPageState createState() => CoinPageState();
}

class CoinPageState extends State<CoinPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserSettingScaffold(
      preventBackNavigation: false,
      onAccountProtectionShownH5: () {
        showConfirmDialog(
          context: context,
          title: '提示',
          message: '為保持您的帳號，請先註冊防止丟失',
          showCancelButton: false,
          onConfirm: () => {},
        );
      },
      onAccountProtectionShown: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: IDCard(),
            );
          },
        );
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: '金幣錢包',
        ),
        body: Column(
          children: [
            const UserInfo(),
            const UserBalance(),
            const SizedBox(height: 25),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  CoinTabBarWidget(
                    controller: _tabController,
                    backgroundColor: Colors.transparent,
                    tabs: const ['金幣', '購買記錄', '存款記錄'],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          CoinProducts(),
                          PurchaseRecord(),
                          OrderRecord(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
