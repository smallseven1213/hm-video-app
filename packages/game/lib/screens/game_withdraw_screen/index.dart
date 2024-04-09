import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:game/screens/game_withdraw_screen/game_withdraw_options.dart';
import 'package:game/screens/game_withdraw_screen/label_with_status.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:game/screens/user_info/game_user_info_deposit.dart';
import 'package:game/screens/user_info/game_user_info_withdraw.dart';
import 'package:game/screens/user_info/game_user_info_withdraw_history.dart';

import 'package:game/widgets/input.dart';
import 'package:game/widgets/pay_switch_button.dart';

import 'package:game/utils/loading.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/utils/show_funding_password_bottom_sheet.dart';

import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/controllers/game_response_controller.dart';

import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/navigator/delegate.dart';

import 'package:game/models/user_withdrawal_data.dart';
import 'package:game/apis/game_api.dart';

import '../../enums/game_app_routes.dart';
import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class GameWithdraw extends StatefulWidget {
  const GameWithdraw({Key? key}) : super(key: key);

  @override
  State<GameWithdraw> createState() => _GameWithdrawState();
}

enum Type { bankcard, crypto }

class _GameWithdrawState extends State<GameWithdraw> {
  final gameWithdrawController = Get.put(GameWithdrawController());
  GameWithdrawController? userWithdrawalData;
  String callbackPin = '';
  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _enableSubmit = false;
  final userController = Get.put(UserController());
  final gameWalletController = Get.put(GameWalletController());
  final responseController = Get.find<GameApiResponseErrorCatchController>();
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();

  bool reachable = false;
  String stakeLimit = '0.00';
  String validStake = '0.00';
  String withdrawalFee = '0.000';
  String withdrawalMode = '0';
  String withdrawalLowerLimit = '0.00';
  FocusNode focusNode = FocusNode(); // 初始化 FocusNode 对象

  @override
  void initState() {
    super.initState();
    _fetchDataInit();

    Get.find<AuthController>().token.listen((event) {
      _fetchDataInit();
    });
  }

  _fetchDataInit() {
    _getUserWithdrawalData();
    _getStackLimit();
    _getParamConfig();
  }

  @override
  void dispose() {
    focusNode.dispose(); // 释放 FocusNode 对象
    super.dispose();
  }

  void _getUserWithdrawalData() async {
    try {
      var res = await Get.put(GameWithdrawController()).getWithDrawalData();
      logger.i('res: $res');

      // if (res['code'] == '00' && res['data'].paymentPin == false) {
      //   showFundPassword();
      // } else
      if (res['code'] == '00' &&
          res['data'].paymentPin &&
          res['data'].userPaymentSecurity != null) {
        // ignore: use_build_context_synchronously
        _transferInit(context);
      }
    } catch (error) {
      logger.i('_getUserWithdrawalData error $error');

      if (mounted) {
        showConfirmDialog(
          context: context,
          title: '',
          content: error.toString(),
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      }
    }
    gameWithdrawController.setLoadingStatus(false);
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
        gameWithdrawController.setLoadingStatus(false);
        Navigator.of(context).pop();
        MyRouteDelegate.of(context).push(GameAppRoutes.setFundPassword);
      },
    );
  }

  void _transferInit(context) async {
    try {
      var res = await GameLobbyApi().transfer();
      if (res['code'] == '00') {
        // var points = res['data']['points'];
        // var balance = res['data']['balance'].toString();

        // if (double.parse(balance) > 0) {
        //   showConfirmDialog(
        //     context: context,
        //     title: "仍有遊戲進行中",
        //     content: "仍有遊戲進行中，可提現額度為$points",
        //     confirmText: "確認",
        //     onConfirm: () {
        //       Navigator.pop(context);
        //     },
        //   );
        // }
      } else {
        showConfirmDialog(
          context: context,
          title: "",
          content: "餘額自動轉出遊戲失敗",
          confirmText: GameLocalizations.of(context)!.translate('confirm'),
          onConfirm: () {
            Navigator.pop(context);
          },
        );
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
          withdrawalLowerLimit = res.data!.withdrawalLowerLimit;
        });
        logger.i('最低可提現金額: $withdrawalLowerLimit');
      }
    } catch (error) {
      logger.i('_getParamConfig $error');
    }
  }

  // onConfirm function
  void _onConfirm(Type type, context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    int intType = type == Type.bankcard ? 1 : 2;
    showFundingPasswordBottomSheet(context, onSuccess: (pin) async {
      try {
        var res = await GameLobbyApi().applyWithdrawalV2(
            intType,
            amountController.text,
            pin.toString(),
            stakeLimit.toString(),
            validStake.toString());
        if (res.code == '00') {
          showConfirmDialog(
              context: context,
              title: localizations.translate('application_completed'),
              content: localizations.translate(
                  'withdrawal_application_has_been_completed_you_can_check_the_current_application_status_in_the_withdrawal_log'),
              confirmText: GameLocalizations.of(context)!.translate('confirm'),
              onConfirm: () {
                setState(() {
                  _enableSubmit = false;
                });
                userController.fetchUserInfo();
                gameWalletController.mutate();
                amountController.clear();
                Navigator.of(context).pop();
              });
        } else {
          Fluttertoast.showToast(
            msg: res.message.toString(),
            gravity: ToastGravity.CENTER,
          );
        }
      } catch (error) {
        logger.i('_onConfirm applyWithdrawalV2 error: $error');
        Fluttertoast.showToast(
          msg: responseController.responseMessage.value.toString(),
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }

  String? _validate(String? value) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    if (focusNode.hasFocus) {
      if (value == null || value.isEmpty) {
        return localizations.translate('please_enter_the_withdrawal_amount');
      } else if (double.parse(value) < double.parse(withdrawalLowerLimit)) {
        return '${localizations.translate('input_amount_must_not_be_less_than')}$withdrawalLowerLimit${localizations.translate('dollar')}';
      } else if (int.parse(value) > gameWalletController.wallet.value) {
        return localizations.translate(
            'input_amount_must_not_be_greater_than_the_remaining_balance');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.translate('game_withdrawal'),
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
        color: gameLobbyBgColor,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              PaySwitchButton(
                // 存款
                leftChild: UserInfoDeposit(
                  onTap: () {
                    MyRouteDelegate.of(context).push(
                        gameConfigController.switchPaymentPage.value ==
                                switchPaymentPageType['list']
                            ? GameAppRoutes.depositList
                            : GameAppRoutes.depositPolling,
                        removeSamePath: true);
                  },
                ),
                // 提現
                rightChild: UserInfoWithdraw(
                  onTap: () {
                    MyRouteDelegate.of(context)
                        .push(GameAppRoutes.withdraw, removeSamePath: true);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: GameUserInfo(
                  child: Wrap(
                    spacing: 20,
                    children: [
                      UserInfoWithdrawHistory(),
                      UserInfoService(),
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
                          child: Column(
                            children: [
                              // ignore: unrelated_type_equality_checks
                              if (gameWithdrawController.paymentPin == true &&
                                  // ignore: unrelated_type_equality_checks
                                  gameWithdrawController.hasPaymentData == true)
                                LabelWithStatus(
                                  label: localizations.translate('limit'),
                                  reachable: reachable,
                                  statusText: reachable
                                      ? localizations.translate('achieved')
                                      : localizations.translate('not_reached'),
                                  stakeLimit: stakeLimit,
                                  validStake: validStake,
                                  withdrawalFee: double.parse(withdrawalFee),
                                  rightIcon: Icons.info,
                                ),
                              // 提現金額TextField
                              Obx(() => FormBuilderField<String?>(
                                    name: 'amount',
                                    onChanged: (val) =>
                                        logger.i(val.toString()),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText: localizations.translate(
                                            'please_enter_the_withdrawal_amount'),
                                      ),
                                      FormBuilderValidators.min(
                                        double.parse(withdrawalLowerLimit),
                                        errorText:
                                            '${localizations.translate('input_amount_must_not_be_less_than')}$withdrawalLowerLimit${localizations.translate('dollar')}',
                                      ),
                                      // 不得大於餘額
                                      FormBuilderValidators.max(
                                        gameWalletController.wallet.value,
                                        errorText: '輸入金額不得大於餘額',
                                      ),
                                      FormBuilderValidators.match(
                                        r"^(?![-\.])\d*$",
                                        errorText: localizations.translate(
                                            'input_amount_is_in_wrong_format'),
                                      )
                                    ]),
                                    builder: (FormFieldState field) {
                                      return GameInput(
                                        label: localizations
                                            .translate('withdrawal_amount'),
                                        hint: localizations.translate(
                                            'please_enter_the_withdrawal_amount'),
                                        controller: amountController,
                                        onChanged: (value) => {
                                          value = amountController.text,
                                          _validate(amountController.text),
                                          setState(() {
                                            _enableSubmit = _validate(
                                                    amountController.text) ==
                                                null;
                                          })
                                        },
                                        warningMessage:
                                            "${localizations.translate('minimum_withdrawal_amount_is')} $withdrawalLowerLimit",
                                        errorMessage:
                                            _validate(amountController.text),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        focusNode: focusNode,
                                        onClear: () {
                                          amountController.clear();
                                          setState(() {
                                            _enableSubmit = false;
                                          });
                                        },
                                      );
                                    },
                                  )),
                              const SizedBox(height: 10),
                              GameWithDrawOptions(
                                controller: amountController,
                                onConfirm: (type) =>
                                    _onConfirm(Type.bankcard, context),
                                enableSubmit: _enableSubmit,
                                hasPaymentData:
                                    gameWithdrawController.hasPaymentData.value,
                                reachable: reachable,
                                withdrawalMode: withdrawalMode,
                                withdrawalFee: withdrawalFee,
                                applyAmount: amountController.text,
                                bankData: gameWithdrawController
                                        .userPaymentSecurity
                                        .firstWhere(
                                            (element) =>
                                                element.remittanceType == 1,
                                            orElse: () =>
                                                UserPaymentSecurity()) ??
                                    [],
                              )
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
