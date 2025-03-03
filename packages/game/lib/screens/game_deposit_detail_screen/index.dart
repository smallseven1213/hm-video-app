import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/screens/game_deposit_list_screen/payment_detail_tips.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/utils/submit_company_deposit_order.dart';
import 'package:game/widgets/game_label.dart';
import 'package:game/widgets/game_withdraw_field.dart';
import 'package:game/widgets/input.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/controllers/user_controller.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class GameDepositDetail extends StatefulWidget {
  final String payment;
  final int paymentChannelId;

  const GameDepositDetail(
      {Key? key, required this.payment, required this.paymentChannelId})
      : super(key: key);

  @override
  GameDepositDetailState createState() => GameDepositDetailState();
}

class GameDepositDetailState extends State<GameDepositDetail> {
  UserController get userController => Get.find<UserController>();
  GameWalletController gameWalletController = Get.find<GameWalletController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final remarkController = TextEditingController();

  bool pointLoading = true;
  bool isLoading = false;
  String branchName = '';
  String receiptAccount = '';
  String receiptBank = '';
  String receiptName = '';
  double exchangeRate = 0.00;
  bool _enableSubmit = false;

  @override
  void initState() {
    super.initState();
    _getPaymentChannelDetail();
    _getCNYToUSDTRate();
    remarkController.addListener(_updateSubmitButton);

    Get.find<AuthController>().token.listen((event) {
      userController.fetchUserInfo();
      gameWalletController.mutate();
      _getPaymentChannelDetail();
    });
  }

  void _getPaymentChannelDetail() async {
    try {
      var res = await GameLobbyApi()
          .getDepositPaymentChannelDetail(widget.paymentChannelId);
      if (res.code != '00') {
        if (mounted) {
          showConfirmDialog(
            context: context,
            title: '',
            content: GameLocalizations.of(context)!
                .translate('you_have_been_logged_out_please_log_in_again'),
            onConfirm: () async {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }
        return;
      } else {
        setState(() {
          branchName = res.data!.branchName ?? '';
          receiptAccount = res.data!.receiptAccount;
          receiptBank = res.data!.receiptBank ?? '';
          receiptName = res.data!.receiptName;
        });
      }
    } catch (error) {
      logger.i('_getPaymentChannelDetail $error');
    }
  }

  void _getCNYToUSDTRate() async {
    try {
      var res = await GameLobbyApi().getCNYToUSDTRate();
      setState(() {
        exchangeRate = res['buyPrice'];
      });
    } catch (error) {
      logger.i('error: $error');
    }
  }

  void _updateSubmitButton() {
    setState(() {
      _enableSubmit = remarkController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    remarkController.removeListener(_updateSubmitButton);
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;
    final gameWithdrawController = Get.put(GameWithdrawController());

    var estimateAmount =
        double.parse(gameWithdrawController.paymentAmount.value) * exchangeRate;
    logger.i(
        'paymentChannelDetail $branchName, $receiptAccount, $receiptBank, $receiptName');
    logger.i('current payment ${widget.payment}');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: gameLobbyBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.payment == 'selfusdt'
                ? 'USDT'
                : localizations.translate('bank_transfer'),
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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: gameLobbyBgColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: gameItemMainColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .15),
                      offset: Offset(0, 0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GameLabel(
                      label: localizations.translate('transfer_amount'),
                      text: widget.payment == 'selfusdt'
                          ? '${gameWithdrawController.paymentAmount.value} USDT'
                          : '¥${gameWithdrawController.paymentAmount.value}${localizations.translate('dollar')}',
                    ),
                    if (widget.payment == 'selfusdt')
                      GameLabel(
                        label: localizations.translate('exchange_rate'),
                        text: exchangeRate.toString(),
                      ),
                    if (widget.payment == 'selfusdt')
                      GameLabel(
                        label: localizations.translate('estimated_amount'),
                        text:
                            '¥${NumberFormat("0.00").format(estimateAmount)}${localizations.translate('dollar')}',
                      ),
                    const SizedBox(height: 12),
                    Container(height: 1, color: gameLobbyDividerColor),
                    const SizedBox(height: 16),
                    // 帳戶資訊 || usdt 地址
                    Container(
                      decoration: BoxDecoration(
                        color: gameLobbyBoxBgColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.payment == 'selfusdt'
                                  ? localizations.translate('trc_address')
                                  : localizations
                                      .translate('account_information'),
                              style: TextStyle(
                                color: gameLobbyPrimaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (widget.payment == 'selfusdt')
                            GameWithDrawField(
                              value: receiptAccount,
                              showClipboard: true,
                            ),
                          // 以下是selfdebit時的資訊
                          if (widget.payment != 'selfusdt')
                            GameWithDrawField(
                              name: localizations.translate('bank_name'),
                              value: receiptBank,
                              showClipboard: true,
                            ),
                          if (widget.payment != 'selfusdt')
                            GameWithDrawField(
                              name: localizations.translate('branch_name'),
                              value: branchName,
                              showClipboard: true,
                            ),
                          if (widget.payment != 'selfusdt')
                            GameWithDrawField(
                              name: localizations.translate('bank_card_number'),
                              value: receiptAccount,
                              showClipboard: true,
                            ),
                          if (widget.payment != 'selfusdt')
                            GameWithDrawField(
                              name: localizations.translate('account_name'),
                              value: receiptName,
                              showClipboard: true,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      onChanged: () {
                        setState(() {
                          _enableSubmit =
                              remarkController.text != '' ? true : false;
                        });
                      },
                      child: Column(
                        children: [
                          GameInput(
                            label: localizations.translate('transfer_remarks'),
                            hint: widget.payment == 'selfusdt'
                                ? localizations.translate(
                                    'please_enter_the_last_digits_of_the_transfer_hash')
                                : localizations
                                    .translate('please_enter_your_real_name'),
                            controller: remarkController,
                            isFontBold: true,
                            onClear: () {
                              remarkController.clear();
                              setState(() {
                                _enableSubmit = false;
                              });
                            },
                          ),
                          const PaymentDetailTips(),
                          const SizedBox(height: 44),
                          TextButton(
                            onPressed: _enableSubmit
                                ? () {
                                    submitCompanyDepositOrder(
                                      context,
                                      amount: gameWithdrawController
                                          .paymentAmount.value,
                                      paymentChannelId: widget.paymentChannelId,
                                      remark: remarkController.text,
                                    );
                                  }
                                : null,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 30),
                              decoration: BoxDecoration(
                                // 表單驗證ok才能點擊，否則按鈕不能點擊，背景色要換成灰色
                                color: remarkController.text != ''
                                    ? gamePrimaryButtonColor
                                    : gameLobbyButtonDisableColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: Text(
                                  localizations.translate(
                                      'confirmation_of_transfer_and_delivery'),
                                  style: TextStyle(
                                      color: remarkController.text != ''
                                          ? gamePrimaryButtonTextColor
                                          : gameLobbyButtonDisableTextColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
