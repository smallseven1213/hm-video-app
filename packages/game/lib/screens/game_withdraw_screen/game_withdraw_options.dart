import 'package:flutter/material.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/models/game_withdraw_stack_limit.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/game_withdraw_screen/game_withdraw_options_bankcard.dart';
import 'package:game/screens/game_withdraw_screen/game_withdraw_options_button.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/button.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';

import '../../enums/game_app_routes.dart';
import '../../models/user_withdrawal_data.dart';

final logger = Logger();

class GameWithDrawOptions extends StatefulWidget {
  const GameWithDrawOptions(
      {Key? key,
      required this.onConfirm,
      required this.onBackFromBindingPage,
      required this.enableSubmit,
      required this.hasPaymentData,
      required this.bankData,
      required this.reachable,
      required this.withdrawalMode,
      required this.withdrawalFee,
      required this.applyAmount,
      this.controller})
      : super(key: key);

  final void Function(Type) onConfirm;
  final Function() onBackFromBindingPage;
  final bool enableSubmit;
  final TextEditingController? controller;
  final bool hasPaymentData;
  final UserPaymentSecurity bankData;
  final bool reachable;
  final String withdrawalMode;
  final String withdrawalFee;
  final String applyAmount;

  @override
  GameWithDrawOptionsState createState() => GameWithDrawOptionsState();
}

enum Type { bankcard, crypto }

class GameWithDrawOptionsState extends State<GameWithDrawOptions> {
  Type type = Type.bankcard;
  double exchangeRate = 0.00;
  double amount = 0.00;
  final gameWithdrawalController = Get.put(GameWithdrawController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 100,
              child: Text("提現方式",
                  style: TextStyle(color: Color(0xff979797), fontSize: 14)),
            ),
            Expanded(
                child: Row(
              children: [
                GameWithdrawalOptionsButton(
                  text: '銀行卡',
                  onPressed: () {
                    setState(() {
                      type = Type.bankcard;
                    });
                  },
                  isActive: type == Type.bankcard,
                ),
              ],
            )),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 1,
          color: gameLobbyDividerColor,
        ),
        const SizedBox(height: 10),
        // ============^^^銀行卡資訊^^^============
        if (type == Type.bankcard && widget.bankData.account != null)
          GameWithDrawOptionsBankCard(
            data: widget.bankData,
            onClick: () {
              widget.onConfirm(Type.bankcard);
            },
          )
        else if (type == Type.bankcard && widget.bankData.account == null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "*請完成銀行卡綁定，方可進行提款",
              style: TextStyle(color: gameLobbyHintColor, fontSize: 12),
            ),
          ),

        const SizedBox(height: 20),
        // ======已達流水條件 widget.reachable:true 的按鈕======
        if (type == Type.bankcard &&
            widget.bankData.account != null &&
            widget.reachable)
          GameButton(
            text: "確認",
            onPressed: () {
              widget.onConfirm(Type.bankcard);
            },
            disabled: !widget.enableSubmit,
          )
        else if (type == Type.bankcard && widget.bankData.account == null)
          GameButton(
            text: "前往綁定",
            onPressed: () {
              widget.onBackFromBindingPage();
              MyRouteDelegate.of(context).push(GameAppRoutes.setBankcard.value);
            },
            disabled: gameWithdrawalController.hasPaymentData.value,
          )
        // ======未達流水條件 widget.reachable:false 的兩顆按鈕======
        else if (type == Type.bankcard &&
            widget.bankData.account != null &&
            widget.reachable == false &&
            withdrawalModeMapper[widget.withdrawalMode] == 'disable')
          GameButton(
            text: "流水不足，請繼續遊戲",
            onPressed: () async {},
            disabled: true,
          )
        else if (type == Type.bankcard &&
            widget.bankData.account != null &&
            widget.reachable == false &&
            withdrawalModeMapper[widget.withdrawalMode] == 'enable')
          GameButton(
            text: "確認送出",
            onPressed: () {
              logger.i('widget.applyAmount: ${widget.applyAmount}');
              logger.i('widget.withdrawalFee: ${widget.withdrawalFee}');
              // showDialog，並計算手續費
              // 點擊Dialog的確認按鈕後，呼叫widget.onConfirm
              showConfirmDialog(
                context: context,
                barrierDismissible: true,
                title: "提現確認",
                content:
                    "未達成流水限額\n需自行負擔提現手續費 ${(int.parse(widget.applyAmount) * double.parse(widget.withdrawalFee)).toString().replaceAll(RegExp(r'(?:(?:\.0+)|(?:\.0+$))'), '')} 元(預估)\n點擊確認送出提現訂單",
                confirmText: "確認",
                onConfirm: () {
                  widget.onConfirm(Type.bankcard);
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
              );
            },
            disabled: !widget.enableSubmit || widget.applyAmount.isEmpty,
          )
      ],
    );
  }
}
