import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';

class GameDeposit extends StatefulWidget {
  const GameDeposit({Key? key}) : super(key: key);

  @override
  _GameDepositState createState() => _GameDepositState();
}

class _GameDepositState extends State<GameDeposit> {
  bool pointLoading = true;
  bool isLoading = false;

  _updateLoading(bool status) {
    print('status>>>>: $status ');
    setState(() {
      isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('status>>>> isLoading: $isLoading');
    return Scaffold(
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: gameLobbyBgColor,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: gameLobbyAppBarIconColor),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // gto("/deposit/record");
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
      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          height: Get.height - 50,
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GameUserInfo(
                      child: TextButton(
                        onPressed: () {
                          MyRouteDelegate.of(context).push(
                            AppRoutes.gameWithdraw.value,
                          );
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          backgroundColor: gamePrimaryButtonColor,
                          minimumSize: const Size(70, 32),
                        ),
                        child: Text(
                          '提現',
                          style: TextStyle(
                            color: gamePrimaryButtonTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 12),
                  // AmountItems(
                  //   updateLoading: (status) => _updateLoading(status),
                  // ),
                  // const SizedBox(height: 36),
                  // Tips(),
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
    );
  }
}
