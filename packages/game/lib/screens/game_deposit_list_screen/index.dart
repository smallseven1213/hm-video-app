// paymentPage:2 列表

import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_deposit_list_screen/channel_empty.dart';
import 'package:game/screens/game_deposit_list_screen/payment_items.dart';
import 'package:game/screens/game_deposit_list_screen/tips.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class GameDepositList extends StatefulWidget {
  const GameDepositList({Key? key}) : super(key: key);

  @override
  GameDepositListState createState() => GameDepositListState();
}

class GameDepositListState extends State<GameDepositList> {
  dynamic depositData;

  @override
  void initState() {
    super.initState();
    _getDepositChannel();
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

  void _getDepositChannel() async {
    try {
      var res = await GameLobbyApi().getDepositChannel();
      if (res['code'] != '00') {
        showConfirmDialogWrapper();
        return;
      } else {
        setState(() {
          depositData = res['data'];
        });
      }
    } catch (error) {
      logger.i('_getDepositChannel $error');
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
          actions: [
            TextButton(
              onPressed: () {
                MyRouteDelegate.of(context).push(GameAppRoutes.depositRecord);
              },
              child: Text(
                localizations.translate('deposit_history'),
                style: TextStyle(
                  color: gameLobbyAppBarTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
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
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: GameUserInfo(
                          child: UserInfoService(),
                        ),
                      ),
                      (depositData != null && depositData.isNotEmpty)
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
