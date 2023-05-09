// paymentPage:2 列表
import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:get/get.dart';

class GameDepositList extends StatefulWidget {
  const GameDepositList({Key? key}) : super(key: key);

  @override
  _GameDepositListState createState() => _GameDepositListState();
}

class _GameDepositListState extends State<GameDepositList> {
  bool pointLoading = true;
  bool isLoading = false;
  var depositData;

  @override
  void initState() {
    super.initState();
    _getDepositChannel();
  }

  void _getDepositChannel() async {
    var res = await GameLobbyApi().getDepositChannel();
    setState(() {
      depositData = res;
    });
    try {} catch (error) {
      print('_getDepositChannel $error');
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
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: GameUserInfo(
                          child: UserInfoService(),
                        ),
                      ),
                      // (depositData != null)
                      //     ? DepositPaymentItems(
                      //         depositData: depositData,
                      //         initialIndex: depositData.keys.first.toString(),
                      //       )
                      //     : const CircularProgressIndicator(),
                      SizedBox(height: 36),
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
        ),
      ),
    );
  }
}
