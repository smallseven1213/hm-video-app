import 'package:app_wl_tw2/widgets/custom_app_bar.dart';
import 'package:app_wl_tw2/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';
import 'package:app_wl_tw2/localization/i18n.dart';

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
          title: I18n.hintMessage,
          message: I18n.maintainAccountPleaseRegisterToPreventLoss,
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
        appBar: CustomAppBar(
          title: I18n.coinWallet,
        ),
        body: Column(
          children: [
            // const UserInfo(),
            // const UserBalance(),
            TabBarWidget(
              controller: _tabController,
              tabs: [
                I18n.coins,
                I18n.purchaseRecord,
                I18n.privilegeRecord,
                I18n.depositRecord
              ],
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
