// paymentPage:1 輪詢
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game/utils/loading.dart';
import 'package:get/get.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/user_controller.dart';

final logger = Logger();

class GameDepositPolling extends StatefulWidget {
  const GameDepositPolling({Key? key}) : super(key: key);

  @override
  State<GameDepositPolling> createState() => _GameDepositPollingState();
}

enum Type { backcard, crypto }

class _GameDepositPollingState extends State<GameDepositPolling> {
  final gameWithdrawController = Get.put(GameWithdrawController());
  GameWithdrawController? userWithdrawalData;
  String callbackPin = '';
  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  // bool _enableSubmit = false;
  final userController = Get.put(UserController());
  final gameWalletController = Get.put(GameWalletController());
  bool reachable = false;
  String stakeLimit = '0.00';
  String validStake = '0.00';
  String withdrawalFee = '0.000';
  String withdrawalMode = '0';

  @override
  void initState() {
    super.initState();
    _getUserWithdrawalData();
    _getStackLimit();
    _getParamConfig();
  }

  Future<void> _getUserWithdrawalData() async {
    try {
      var res = await Get.put(GameWithdrawController()).getWithDrawalData();

      if (res['code'] == '04' || res['code'] == '57630') {
        // showConfirm(
        //   context,
        //   title: '',
        //   content: '你已被登出，請重新登入',
        //   onConfirm: () async {
        //     _logout();
        //     Navigator.pop(context);
        //     Get.toNamed('/default', arguments: 2);
        //     Get.find<AppController>().updateNavigationIndex('/game', 2);
        //   },
        // );
      } else if (res['code'] == '00' && res['data'].paymentPin == false) {
        showFundPassword();
      } else if (res['code'] == '00' &&
          res['data'].paymentPin &&
          res['data'].userPaymentSecurity != null) {
        _transferInit();
      } else {
        gameWithdrawController.setLoadingStatus(false);
        // showConfirm(
        //   context,
        //   title: 'error',
        //   content: res['data'].toString(),
        //   onConfirm: () async {
        //     Navigator.pop(context);
        //   },
        // );
      }
    } catch (error) {
      logger.i('_getUserWithdrawalData $error');

      // showConfirm(
      //   context,
      //   title: '',
      //   content: error.toString(),
      //   onConfirm: () async {
      //     Navigator.pop(context);
      //     Navigator.pop(context);
      //   },
      // );
    }
    gameWithdrawController.setLoadingStatus(false);
  }

  showFundPassword() {
    // showConfirm(
    //   context,
    //   title: "",
    //   content: "請先設置資金密碼",
    //   barrierDismissible: false,
    //   confirmText: "前往設定!!",
    //   onConfirm: () async {
    //     gameWithdrawController.setLoadingStatus(false);
    //     Navigator.pop(context);
    //     var result = await gto('/set/fundPassword');
    //   },
    // );
  }

  void _transferInit() async {
    try {
      var res = await GameLobbyApi().transfer();
      if (res['code'] == '00') {
        var balance = res['data']['balance'].toString();

        if (double.parse(balance) > 0) {
          // logger.i('double.parse(balance) : ${double.parse(balance)}');
          // showConfirm(
          //   context,
          //   title: "仍有遊戲進行中",
          //   content: "仍有遊戲進行中，可提現額度為$points",
          //   confirmText: "確認",
          //   onConfirm: () {
          //     Navigator.pop(context);
          //   },
          // );
        }
      } else {
        // Fluttertoast.showToast(
        //   msg: '餘額自動轉出遊戲失敗',
        //   gravity: ToastGravity.CENTER,
        // );
      }
    } catch (error) {
      logger.i(error);
    }
  }

  void _getStackLimit() async {
    try {
      final res = await GameLobbyApi().getStackLimit();
      if (res.data != null) {
        setState(() {
          reachable = res.data!.reachable;
          stakeLimit = res.data!.stakeLimit;
          validStake = res.data!.validStake;
        });
        logger.i('reachable: $reachable, $stakeLimit, $validStake');
      }
    } catch (e) {
      logger.i('_getStackLimit error : $e');
    }
  }

  void _getParamConfig() async {
    try {
      var res = await GameLobbyApi().getGameParamConfig();
      if (res.data != null) {
        setState(() {
          withdrawalFee = res.data!.withdrawalFee;
          withdrawalMode = res.data!.withdrawalMode;
        });
        logger.i(
            'withdrawalFee: $withdrawalFee, withdrawalMode: $withdrawalMode');
      }
    } catch (error) {
      logger.i('_getParamConfig $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
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
              // gto("/deposit/record");
            },
            child: Text(
              '存款記錄',
              style: TextStyle(
                color: gameLobbyPrimaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: gameLobbyBgColor,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: GameUserInfo(
                  child: Wrap(
                    spacing: 20,
                    children: [
                      // 提現紀錄
                      SizedBox(
                        width: 50,
                        height: 60,
                        child: InkWell(
                          onTap: () {
                            // gto('/withdrawal/record');
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "packages/game/assets/images/game_lobby/withdraw-record.webp",
                                width: 28,
                                height: 28,
                              ),
                              Text(
                                '提現紀錄',
                                style: TextStyle(
                                  color: gameLobbyPrimaryTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const UserInfoService(),
                    ],
                  ),
                ),
              ),
              Obx(
                () => gameWithdrawController.loadingStatus.value
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                          child: GameLoading(),
                        ),
                      )
                    : Container(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: FormBuilder(
                          key: _formKey,
                          onChanged: () {
                            _formKey.currentState!.save();
                            // setState(() {
                            //   _enableSubmit =
                            //       _formKey.currentState?.validate() ?? false;
                            // });
                            logger.i(
                                '驗證表單: ${_formKey.currentState?.validate()}');
                          },
                          child: Column(
                            children: [
                              // ignore: unrelated_type_equality_checks
                              if (gameWithdrawController.paymentPin == true &&
                                  // ignore: unrelated_type_equality_checks
                                  gameWithdrawController.hasPaymentData == true)
                                // LabelWithStatus(
                                //   label: "流水限額",
                                //   reachable: reachable,
                                //   statusText: reachable ? "已達標" : "未達標",
                                //   stakeLimit: stakeLimit,
                                //   validStake: validStake,
                                //   withdrawalFee: double.parse(withdrawalFee),
                                //   rightIcon: Icons.info,
                                // ),
                                // 提現金額TextField
                                Obx(() => FormBuilderField<String?>(
                                      name: 'amount',
                                      onChanged: (val) =>
                                          logger.i(val.toString()),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                          errorText: '請輸提現金額',
                                        ),
                                        // 不得小於100
                                        FormBuilderValidators.min(
                                          100,
                                          errorText: '輸入金額不得小於 100元',
                                        ),
                                        // 不得大於餘額
                                        FormBuilderValidators.max(
                                          gameWalletController.wallet.value,
                                          errorText: '輸入金額不得大於餘額',
                                        ),
                                        FormBuilderValidators.match(
                                          r"^(?![-\.])\d*$",
                                          errorText: '輸入金額格式錯誤',
                                        )
                                      ]),
                                      builder: (FormFieldState field) {
                                        return const Text('提現金額');
                                        // GameInput(
                                        //   label: "提現金額",
                                        //   hint: "請輸入提現金額",
                                        //   controller: amountController,
                                        //   onChanged: (value) =>
                                        //       field.didChange(value),
                                        //   warningMessage: "*最低可提金額為 100 CNY",
                                        //   errorMessage: field.errorText,
                                        //   inputFormatters: <TextInputFormatter>[
                                        //     FilteringTextInputFormatter
                                        //         .digitsOnly
                                        //   ],
                                        // );
                                      },
                                    )),
                              const SizedBox(height: 10),
                              // GameWithDrawOptions(
                              //   controller: amountController,
                              //   onConfirm: _onConfirm,
                              //   onBackFromBindingPage: () =>
                              //       _getUserWithdrawalData(),
                              //   enableSubmit: _enableSubmit,
                              //   hasPaymentData:
                              //       gameWithdrawController.hasPaymentData.value,
                              //   reachable: reachable,
                              //   withdrawalMode: withdrawalMode,
                              //   withdrawalFee: withdrawalFee,
                              //   applyAmount: amountController.text,
                              //   bankData: gameWithdrawController
                              //           .userPaymentSecurity.value
                              //           .firstWhere(
                              //               (element) =>
                              //                   element.remittanceType == 1,
                              //               orElse: () =>
                              //                   UserPaymentSecurity()) ??
                              //       [],
                              //   usdtData: gameWithdrawController
                              //           .userPaymentSecurity.value
                              //           .firstWhere(
                              //               (element) =>
                              //                   element.remittanceType == 2,
                              //               orElse: () =>
                              //                   UserPaymentSecurity()) ??
                              //       [],
                              // )
                            ],
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
