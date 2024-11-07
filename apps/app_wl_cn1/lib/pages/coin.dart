import 'package:app_wl_cn1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';

import '../../utils/show_confirm_dialog.dart';
import '../../widgets/id_card.dart';
import '../localization/i18n.dart';
import '../widgets/avatar.dart';
import '../screens/user_screen/balance.dart';
import '../screens/coin/coin_tab_section.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  CoinPageState createState() => CoinPageState();
}

class CoinPageState extends State<CoinPage>
    with SingleTickerProviderStateMixin {
  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
      child: UserInfoV2Consumer(
        child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
          return Row(
            children: [
              Avatar(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.nickname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${info.uid}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
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
        backgroundColor: const Color(0xff0f1320),
        appBar: CustomAppBar(
          title: I18n.coinWallet,
        ),
        body: Column(
          children: [
            _buildUserInfo(),
            Container(
              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 20),
              child: const UserBalance(),
            ),
            const Expanded(child: CoinTabSection()),
          ],
        ),
      ),
    );
  }
}
