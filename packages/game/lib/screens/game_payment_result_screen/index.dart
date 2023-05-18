import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:get/get.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class GamePaymentResult extends StatefulWidget {
  const GamePaymentResult({Key? key}) : super(key: key);

  @override
  _GamePaymentResultState createState() => _GamePaymentResultState();
}

class _GamePaymentResultState extends State<GamePaymentResult> {
  Future<void> alertModal(
      {String title = '', String content = '', VoidCallback? onTap}) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          title: null,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 150,
            padding:
                const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: gameLobbyBgColor,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    if (onTap != null) {
                      onTap();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: gameLobbyPrimaryTextColor,
                    ),
                    child: const Text('確認'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gameLobbyBgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: gameLobbyAppBarIconColor),
        centerTitle: true,
        title: Text(
          '支付確認',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 78,
                ),
                Image.asset(
                  'packages/game/assets/images/game_lobby/pay-success.webp',
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    MyRouteDelegate.of(context).push(AppRoutes.gameLobby.value);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: gamePrimaryButtonColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text('遊戲大廳',
                        style: TextStyle(color: gamePrimaryButtonTextColor)),
                  ),
                ),
                const SizedBox(
                  height: 72,
                ),
                Container(
                  width: Get.width - 32,
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    left: 16,
                    right: 16,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '溫馨提醒',
                        // color is 979797
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff979797),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '1：支付不成功，請多次嘗試支付。',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff979797),
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        '2：無法拉起支付訂單，是由於拉起訂單人數較多，請多次嘗試拉起支付。',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff979797),
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        '3：充值成功VIP未到賬，請聯繫在線客服。',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff979797),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
