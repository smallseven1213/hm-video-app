import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:game/models/third_login_api_response_with_data.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class GameUserInfo extends StatefulWidget {
  final String? type;
  final Widget child;

  const GameUserInfo({Key? key, this.type, required this.child})
      : super(key: key);

  @override
  State<GameUserInfo> createState() => _GameUserInfo();
}

class _GameUserInfo extends State<GameUserInfo> with TickerProviderStateMixin {
  late AnimationController animationController;
  UserController userController = Get.find<UserController>();
  GameWalletController gameWalletController = Get.find<GameWalletController>();

  final theme = themeMode[GetStorage().hasData('pageColor')
          ? GetStorage().read('pageColor')
          : 1]
      .toString();

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: gameLobbyUserInfoColor1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localizations.translate('balance'),
                            style: TextStyle(
                                fontSize: 12,
                                color: gameLobbyPrimaryTextColor)),
                        Row(children: [
                          Obx(() => Text(
                                '${gameWalletController.wallet > 0 ? NumberFormat.currency(
                                    locale: currencyMapper[gameWalletController
                                            .currency.value] ??
                                        'zh-TW',
                                    symbol: '',
                                  ).format(
                                    DecimalIntl(
                                      Decimal.parse(gameWalletController
                                          .wallet.value
                                          .toString()),
                                    ),
                                  ) : '0.00'} ${currencyMapper[gameWalletController.currency.value] == 'id-ID' ? 'K' : ''}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: gameLobbyPrimaryTextColor),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          const SizedBox(
                            width: 6,
                          ),
                          InkWell(
                            onTap: () async {
                              animationController.forward();
                              setState(() {});
                              Future.delayed(const Duration(milliseconds: 1000))
                                  .then((value) {
                                animationController.reset();
                              });
                              gameWalletController.mutate();
                            },
                            child: RotationTransition(
                              turns: Tween(begin: 0.0, end: -1.0)
                                  .animate(animationController),
                              child: Icon(
                                Icons.cached,
                                color: gameLobbyAppBarIconColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
                Obx(() => userController.info.value.uid != 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'ID: ${userController.info.value.uid}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff979797)),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Container(
              color: gameLobbyDividerColor,
              child: const SizedBox(
                width: 1,
                height: 54,
              ),
            ),
          ),
          Expanded(
            flex: widget.type == 'lobby' ? 1 : 0,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
