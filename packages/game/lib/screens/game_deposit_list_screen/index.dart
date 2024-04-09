// paymentPage:2 列表
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';

import 'package:game/screens/game_deposit_list_screen/channel_empty.dart';
import 'package:game/screens/game_deposit_list_screen/payment_items.dart';
import 'package:game/screens/game_deposit_list_screen/tips.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_deposit.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:game/screens/user_info/game_user_info_withdraw.dart';
import 'package:game/screens/user_info/game_user_info_deposit_history.dart';

import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/pay_switch_button.dart';

import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class GameDepositList extends StatefulWidget {
  const GameDepositList({Key? key}) : super(key: key);

  @override
  GameDepositListState createState() => GameDepositListState();
}

class GameDepositListState extends State<GameDepositList> {
  Map<String, dynamic> depositData = {};
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();

  @override
  void initState() {
    super.initState();
    _getDepositChannel('alipay');
  }

  void showConfirmDialogWrapper() {
    showConfirmDialog(
      context: context,
      title: '',
      content: GameLocalizations.of(context)!
          .translate('you_have_been_logged_out_please_log_in_again'),
      onConfirm: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  void _getDepositChannel(String paymentTypeCode) async {
    try {
      var res = await GameLobbyApi().getDepositChannel('alipay');
      if (res['code'] != '00') {
        showConfirmDialogWrapper();
        return;
      } else {
        logger.i('_getDepositChannel = 00 ${res['data']}');
        setState(() {
          depositData = res['data'];
        });
      }
    } catch (error) {
      logger.i('_getDepositChannel error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: gameLobbyBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            localizations.translate('deposit'),
            style: TextStyle(
              color: gameLobbyAppBarTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: gameLobbyBgColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: gameLobbyAppBarIconColor),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: gameLobbyBgColor,
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Column(
                    children: [
                      PaySwitchButton(
                        // 存款
                        leftChild: UserInfoDeposit(
                          onTap: () {
                            MyRouteDelegate.of(context).push(
                                gameConfigController.switchPaymentPage.value ==
                                        switchPaymentPageType['list']
                                    ? GameAppRoutes.depositList
                                    : GameAppRoutes.depositPolling,
                                removeSamePath: true);
                          },
                        ),
                        // 提現
                        rightChild: UserInfoWithdraw(
                          onTap: () {
                            MyRouteDelegate.of(context).push(
                                GameAppRoutes.withdraw,
                                removeSamePath: true);
                          },
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: GameUserInfo(
                          child: Wrap(
                            spacing: 20,
                            children: [
                              UserInfoDepositHistory(),
                              UserInfoService(),
                            ],
                          ),
                        ),
                      ),
                      // const DepositChannelEmpty(),
                      (depositData.isNotEmpty)
                          ? DepositPaymentItems(
                              depositData: depositData,
                              initialIndex: depositData.keys.first.toString(),
                            )
                          : const DepositChannelEmpty(),
                      const SizedBox(height: 36),
                      const Tips(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
