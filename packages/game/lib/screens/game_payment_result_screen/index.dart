import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../localization/game_localization_delegate.dart';
import '../../widgets/game_startup.dart';

final logger = Logger();

class GamePaymentResult extends StatefulWidget {
  const GamePaymentResult({Key? key}) : super(key: key);

  @override
  GamePaymentResultState createState() => GamePaymentResultState();
}

class GamePaymentResultState extends State<GamePaymentResult> {
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
                    child: Text(
                      GameLocalizations.of(context)!.translate('confirm'),
                    ),
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
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: gameLobbyBgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: gameLobbyAppBarIconColor),
        centerTitle: true,
        title: Text(
          localizations.translate('payment_confirmation'),
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
                    Get.find<GameStartupController>().goBackToAppHome(context);
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
                    child: Text(localizations.translate('game_lobby'),
                        style: TextStyle(color: gamePrimaryButtonTextColor)),
                  ),
                ),
                const SizedBox(
                  height: 72,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 32,
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.translate('tips'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff979797),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        localizations.translate(
                            'payment_was_not_successful_please_try_to_pay_several_times'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff979797),
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        localizations.translate(
                            'can_not_pull_up_the_payment_order_is_due_to_pull_up_the_order_more_people_please_try_to_pull_up_the_payment_several_times'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff979797),
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        localizations.translate(
                            'please_contact_our_online_customer_service_if_the_recharge_is_successful_but_not_arrived'),
                        style: const TextStyle(
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
