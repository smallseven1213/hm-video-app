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
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';

final logger = Logger();

class GameDepositList extends StatefulWidget {
  const GameDepositList({Key? key}) : super(key: key);

  @override
  GameDepositListState createState() => GameDepositListState();
}

class GameDepositListState extends State<GameDepositList> {
  bool isLoading = false;
  dynamic depositData;

  @override
  void initState() {
    super.initState();
    _getDepositChannel();
  }

  void _getDepositChannel() async {
    try {
      var res = await GameLobbyApi().getDepositChannel();
      if (res['code'] != '00') {
        // ignore: use_build_context_synchronously
        showConfirmDialog(
          context: context,
          title: '',
          content: '你已被登出，請重新登入',
          onConfirm: () async {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: gameLobbyBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '存款',
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
                MyRouteDelegate.of(context)
                    .push(GameAppRoutes.depositRecord.value);
              },
              child: Text(
                '存款記錄',
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
              width: Get.width,
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
                  isLoading == true
                      ? Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: Get.width,
                            height: Get.height,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '訂單生成中...',
                                  style: TextStyle(
                                    color: gameLobbyPrimaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
