import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/models/game_payment.dart';
import 'package:game/screens/game_deposit_list_screen/show_user_name.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/on_loading.dart';
import 'package:game/utils/show_form_dialog.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = Logger();

Future<void> showPaymentMethod({
  context,
  int productId = 0,
  String balanceFiatMoneyPrice = '',
  String name = '',
  Function? onClose,
}) async {
  int paymentMethod = 0;
  List<Payment> payments = await GameLobbyApi()
      .getPaymentsBy(productId, balanceFiatMoneyPrice.split('.').first);
  if (payments.isNotEmpty) {
    paymentMethod = payments.first.id;
  } else {
    showFormDialog(
      context,
      title: '交易失敗',
      content: SizedBox(
        height: 24,
        child: Center(
          child: Text(
            payments == '51728' ? '當前支付人數眾多，請稍後再試！' : '訂單建立失敗，請聯繫客服',
            style: TextStyle(color: gameLobbyPrimaryTextColor),
          ),
        ),
      ),
      confirmText: '確認',
      onConfirm: () => {
        Navigator.pop(context),
        Navigator.pop(context),
      },
    );
    return;
  }

  void submitOrder(int productId, String? userName) async {
    onLoading(context, status: true);
    // ignore: avoid_init_to_null
    if (await canLaunchUrl(Uri.parse(''))) {
      await launchUrl(Uri.parse(''), webOnlyWindowName: '_blank');
    }
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      var value = await GameLobbyApi().makeOrder(
        productId: productId,
        paymentChannelId: paymentMethod,
        name: userName,
      );
      if (value.isNotEmpty && value.startsWith('http')) {
        if (GetPlatform.isWeb) {
          await Future.delayed(const Duration(milliseconds: 500));
          onLoading(context, status: false);
          Navigator.pop(context);
          launch(value, webOnlyWindowName: '_blank');
          MyRouteDelegate.of(context).push(GameAppRoutes.paymentResult.value);
        } else {
          await launch(value, webOnlyWindowName: '_blank');
          onLoading(context, status: false);
          Navigator.pop(context);
          MyRouteDelegate.of(context).push(GameAppRoutes.paymentResult.value);
        }
      } else {
        onLoading(context, status: false);
        showFormDialog(
          context,
          title: '交易失敗',
          content: SizedBox(
            height: 24,
            child: Center(
              child: Text(
                value == '51728' ? '當前支付人數眾多，請稍後再試！' : '訂單建立失敗，請聯繫客服',
                style: TextStyle(color: gameLobbyPrimaryTextColor),
              ),
            ),
          ),
          confirmText: '確認',
          onConfirm: () => {
            Navigator.pop(context),
            Navigator.pop(context),
          },
        );
      }
    } catch (e) {
      onLoading(context, status: false);
      showFormDialog(
        context,
        title: '交易失敗',
        content: SizedBox(
          height: 60,
          child: Center(
            child: Text(
              '訂單建立失敗，請聯繫客服',
              style: TextStyle(color: gameLobbyPrimaryTextColor),
            ),
          ),
        ),
        confirmText: '確認',
        onConfirm: () => {
          Navigator.of(context).pop(),
        },
      );
      logger.i('submitDepositOrder error: $e');
    }
  }

  await showModalBottomSheet(
    isDismissible: false,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    backgroundColor: gameLobbyBgColor,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: gameItemMainColor,
            ),
            height: 190 + payments.length * 60,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Center(
                      child: Text(
                        "請選擇支付方式",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: gameLobbyAppBarTextColor),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: -10,
                      child: InkWell(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.close,
                            color: gameLobbyAppBarTextColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  // padding x 36, top 33, bottom 24
                  margin: const EdgeInsets.only(
                    left: 36,
                    right: 36,
                    top: 25,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: gamePrimaryButtonColor,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text("需支付金額",
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff979797))),
                      Text(" ¥$balanceFiatMoneyPrice",
                          style:
                              const TextStyle(fontSize: 15, color: Colors.red)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ...payments.where((product) => product.type != '').map((e) {
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 24, right: 24),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: gameLobbyDividerColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
                            setModalState(() {
                              paymentMethod = e.id;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: Row(
                              children: [
                                e.type == "支付寶"
                                    ? SvgPicture.asset(
                                        'packages/game/assets/svg/icon-payment-alipay.svg',
                                        width: 18,
                                        height: 18,
                                      )
                                    : e.type == "雲閃付"
                                        ? SvgPicture.asset(
                                            'packages/game/assets/svg/icon-payment-quickpass.svg',
                                            width: 18,
                                            height: 18,
                                          )
                                        : e.type == "銀行卡"
                                            ? SvgPicture.asset(
                                                'packages/game/assets/svg/icon-payment-paypal.svg',
                                                width: 18,
                                                height: 18,
                                              )
                                            : SvgPicture.asset(
                                                'packages/game/assets/svg/icon-payment-wechat.svg',
                                                width: 18,
                                                height: 18,
                                              ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    e.type ?? '',
                                    style: TextStyle(
                                      color: gameLobbyPrimaryTextColor,
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  activeColor: const Color(0xff0bb563),
                                  checkColor: gameLobbyBgColor,
                                  value: paymentMethod == e.id,
                                  onChanged: (val) {
                                    if (val == true) {
                                      setModalState(() {
                                        paymentMethod = e.id;
                                      });
                                    }
                                  },
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide.none,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(64.0)),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                SizedBox(
                  height: GetPlatform.isWeb ? 20 : 0,
                ),
                InkWell(
                  onTap: () async {
                    if (paymentMethod == 0) {
                      return;
                    }

                    // 如果選擇的paymentType為"銀行卡", 則要呼叫showUserNameDialog, 取得userName
                    if (payments
                            .firstWhere(
                                (element) => element.id == paymentMethod)
                            .type ==
                        "銀行卡") {
                      showUserName(
                        context,
                        onSuccess: (userName) {
                          Navigator.of(context).pop();
                          submitOrder(productId, userName);
                        },
                      );
                    } else {
                      Navigator.of(context).pop();
                      submitOrder(productId, null);
                    }
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
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Text('確認支付',
                        style: TextStyle(color: gamePrimaryButtonTextColor)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    if (onClose != null) {
      onClose();
    }
  });
}
