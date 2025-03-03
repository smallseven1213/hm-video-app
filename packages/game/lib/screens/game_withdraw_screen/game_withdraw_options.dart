import 'package:flutter/material.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/models/game_withdraw_stack_limit.dart';
import 'package:game/models/user_withdrawal_data.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/game_withdraw_screen/game_withdraw_options_bankcard.dart';
import 'package:game/screens/game_withdraw_screen/game_withdraw_options_button.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/button.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';

import '../../enums/game_app_routes.dart';
import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class GameWithDrawOptions extends StatefulWidget {
  const GameWithDrawOptions(
      {Key? key,
      required this.onConfirm,
      required this.enableSubmit,
      required this.hasPaymentData,
      required this.bankData,
      required this.paymentPin,
      required this.reachable,
      required this.withdrawalMode,
      required this.withdrawalFee,
      required this.applyAmount,
      this.controller})
      : super(key: key);

  final void Function(int type) onConfirm;
  final bool enableSubmit;
  final TextEditingController? controller;
  final bool hasPaymentData;
  final UserPaymentSecurity bankData;
  final bool paymentPin;
  final bool reachable;
  final String withdrawalMode;
  final String withdrawalFee;
  final String applyAmount;

  @override
  GameWithDrawOptionsState createState() => GameWithDrawOptionsState();
}

class GameWithDrawOptionsState extends State<GameWithDrawOptions> {
  Type optionType = Type.usdt; // usdt or bankcard
  double exchangeRate = 0.00;
  double amount = 0.00;
  int currentRemittanceType = 1; // remittanceTypeEnum
  GameWithdrawController gameWithdrawalController =
      Get.find<GameWithdrawController>();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      setState(() {
        optionType = remittanceTypeMapper[
            gameWithdrawalController.initRemittanceType.value] as Type;
        currentRemittanceType =
            gameWithdrawalController.initRemittanceType.value;
      });
    });
  }

  showFundPassword() {
    showConfirmDialog(
      context: context,
      title: "",
      content: GameLocalizations.of(context)!
          .translate('please_set_the_password_first'),
      barrierDismissible: false,
      confirmText: GameLocalizations.of(context)!.translate('go_to_settings'),
      onConfirm: () {
        gameWithdrawalController.setLoadingStatus(false);
        Navigator.of(context).pop();
        MyRouteDelegate.of(context).push(GameAppRoutes.setFundPassword);
      },
      onCancel: () => Navigator.of(context).pop(),
    );
  }

  String generateContentWithFee(String content, String fee) {
    return content.replaceAll('{fee}', fee);
  }

  @override
  Widget build(BuildContext context) {
    logger.i('option type: $optionType');
    logger.i('currentRemittanceType: $currentRemittanceType');
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    Map<int, String> remittanceTypeLocale = {
      1: localizations.translate('bank_card'),
      2: 'USDT',
      3: localizations.translate('bank_card_idr'),
      4: localizations.translate('bank_card_twd'),
      5: localizations.translate('bank_card_php'),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(localizations.translate('withdrawal_method'),
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: Color(0xff979797), fontSize: 14)),
            ),
            Expanded(
                child: Row(
                    children: gameWithdrawalController.userPaymentSecurity.value
                        .map((item) => (GameWithdrawalOptionsButton(
                              text: remittanceTypeLocale[item.remittanceType]
                                  as String,
                              onPressed: () {
                                setState(() {
                                  optionType = item.remittanceType ==
                                          remittanceTypeEnum['USDT']
                                      ? Type.usdt
                                      : Type.bankcard;
                                  currentRemittanceType = item.remittanceType;
                                });
                              },
                              isActive: item.remittanceType ==
                                      remittanceTypeEnum['USDT']
                                  ? optionType == Type.usdt
                                  : optionType == Type.bankcard,
                            )))
                        .toList())),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 1,
          color: gameLobbyDividerColor,
        ),
        const SizedBox(height: 10),
        // ============^^^銀行卡資訊^^^============
        if (optionType == Type.bankcard && widget.bankData.isBound)
          GameWithDrawOptionsBankCard(
            data: widget.bankData,
            onClick: () {
              widget.onConfirm(currentRemittanceType);
            },
          )
        else if (optionType == Type.bankcard &&
            widget.bankData.isBound == false)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              localizations.translate(
                  'please_complete_the_card_binding_before_withdrawing_money'),
              style: TextStyle(color: gameLobbyHintColor, fontSize: 12),
            ),
          ),

        const SizedBox(height: 20),
        // ======前往設定資金密碼======
        if (optionType == Type.bankcard && widget.paymentPin == false)
          GameButton(
            text: localizations.translate('go_to_binding'),
            onPressed: () => showFundPassword(),
          )
        // ======前往設置銀行卡======
        else if (optionType == Type.bankcard &&
            widget.paymentPin &&
            widget.bankData.isBound == false)
          GameButton(
            text: localizations.translate('go_to_binding'),
            onPressed: () {
              MyRouteDelegate.of(context).push(
                GameAppRoutes.setBankcard,
                args: {
                  'remittanceType': currentRemittanceType,
                },
              );
            },
          )
        // ======已達流水條件 widget.reachable:true 的按鈕======
        else if (optionType == Type.bankcard &&
            widget.bankData.isBound &&
            widget.reachable)
          GameButton(
            text: localizations.translate('confirm'),
            onPressed: () {
              widget.onConfirm(currentRemittanceType);
            },
            disabled: !widget.enableSubmit,
          )

        // ======未達流水條件 widget.reachable:false 的兩顆按鈕======
        else if (optionType == Type.bankcard &&
            widget.bankData.isBound &&
            widget.reachable == false &&
            withdrawalModeMapper[widget.withdrawalMode] == 'disable')
          GameButton(
            text: localizations
                .translate('insufficient_liquidity_please_continue_to_play'),
            onPressed: () async {},
            disabled: true,
          )
        else if (optionType == Type.bankcard &&
            widget.bankData.isBound &&
            widget.reachable == false &&
            withdrawalModeMapper[widget.withdrawalMode] == 'enable')
          GameButton(
            text: localizations.translate('confirm'),
            onPressed: () {
              logger.i('widget.withdrawalFee: ${widget.withdrawalFee}');
              // showDialog，並計算手續費
              // 點擊Dialog的確認按鈕後，呼叫widget.onConfirm
              showConfirmDialog(
                context: context,
                barrierDismissible: true,
                title: "提現確認",
                content: generateContentWithFee(
                    localizations.translate(
                        'if_you_have_not_reached_the_limit_need_to_pay_the_withdrawal_fee_of_estimated_click_to_confirm_to_send_out_the_withdrawal_order'),
                    (int.parse(widget.applyAmount) *
                            double.parse(widget.withdrawalFee))
                        .toStringAsFixed(2)
                        .replaceAll(RegExp(r'\.?0*$'), '')),
                confirmText: localizations.translate('confirm'),
                onConfirm: () {
                  Navigator.of(context).pop();
                  widget.onConfirm(currentRemittanceType);
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
