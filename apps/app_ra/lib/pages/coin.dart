import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';
import 'package:shared/services/system_config.dart';

import '../../utils/show_confirm_dialog.dart';
import '../../widgets/id_card.dart';
import '../screens/coin/deposit_history.dart';
import '../screens/coin/products.dart';
import '../screens/coin/purchase_history.dart';
import '../screens/coin/vip_history.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/ra_tab_bar.dart';
import '../widgets/user/balance.dart';
import '../widgets/user/info.dart';

final systemConfig = SystemConfig();
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
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserSettingScaffold(
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
        appBar: const MyAppBar(
          title: '金幣錢包',
        ),
        body: Column(
          children: [
            const UserInfo(),
            const UserBalance(),
            RATabBar(
              controller: _tabController,
              tabs: const ['金幣', '購買記錄', '特權紀錄', '存款記錄'],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    const CoinProducts(),
                    const PurchaseHistory(),
                    const VipHistory(),
                    const DepositHistory(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
