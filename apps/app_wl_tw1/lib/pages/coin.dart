import 'package:app_wl_tw1/widgets/custom_app_bar.dart';
import 'package:app_wl_tw1/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';

import '../../utils/show_confirm_dialog.dart';
import '../../widgets/id_card.dart';

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
            // const UserInfo(),
            // const UserBalance(),
            TabBarWidget(
              controller: _tabController,
              tabs: const ['金幣', '購買記錄', '特權紀錄', '存款記錄'],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    // CoinProducts(),
                    // PurchaseRecord(),
                    // PrivilegeRecord(),
                    // OrderRecord(),
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
