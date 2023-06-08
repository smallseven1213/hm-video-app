// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/models/bank.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/on_loading.dart';
import 'package:game/utils/show_funding_password_bottom_sheet.dart';
import 'package:game/widgets/autocomplete.dart';
import 'package:game/widgets/button.dart';
import 'package:game/widgets/input.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';

final logger = Logger();

class GameSetBankCard extends StatefulWidget {
  const GameSetBankCard({Key? key}) : super(key: key);

  @override
  GameSetBankCardState createState() => GameSetBankCardState();
}

class GameSetBankCardState extends State<GameSetBankCard> {
  List<BankItem> bankList = [];
  final accountController = TextEditingController();
  final bankNameController = TextEditingController();
  final legalNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final gameWithdrawController = Get.put(GameWithdrawController());

  bool _legalNameEnable = false;
  bool _accountEnable = false;
  final RxBool _bankNameEnable = false.obs;
  String? _legalNameError;
  String? _accountError;
  String? _bankNameError;

  // on init時呼叫 showFundingPasswordBottomSheet(context, onSuccess: () {});
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showFundingPasswordBottomSheet(context,
          onSuccess: (pin) {},
          onClose: () => MyRouteDelegate.of(context).popRoute());
    });
    _getBanks();
  }

  @override
  void dispose() {
    super.dispose();
    accountController.dispose();
    bankNameController.dispose();
    legalNameController.dispose();
    branchNameController.dispose();
  }

  Map<String, dynamic> getFormData() {
    return {
      'account': accountController.text,
      'remittanceType': 1,
      'bankName': bankNameController.text,
      'legalName': legalNameController.text,
      'branchName': branchNameController.text,
    };
  }

  void _onSubmit() async {
    gameWithdrawController.setWithDrawalDataNotEmpty();
    onLoading(context, status: true);
    try {
      var formData = getFormData();
      var res = await Get.put(GameLobbyApi()).updatePaymentSecurity(
          formData['account'],
          formData['remittanceType'],
          formData['bankName'],
          formData['legalName'],
          formData['branchName']);
      if (res.code == '00') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '設置成功',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
        gameWithdrawController.setLoadingStatus(false);
        gameWithdrawController.mutate();
        Navigator.of(context).pop();
        MyRouteDelegate.of(context).popRoute();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res.message.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
      onLoading(context, status: false);
    } catch (e) {
      logger.i(e);
      onLoading(context, status: false);
    }
  }

// 寫一個打getBanks的api, 並且把api的結果塞到下拉選單的選項裡
// 先取得銀行列表
  Future<void> _getBanks() async {
    var res = await Get.put(GameLobbyApi()).getBanks();
    // ignore: unnecessary_null_comparison
    if (res != null) {
      setState(() {
        bankList = res;
      });
    }
  }

  void _checkFormValidity() {
    setState(() {
      _accountEnable = _accountError == null;
      _bankNameEnable.value = _bankNameError == null;
      _legalNameEnable = _legalNameError == null;
    });
  }

  void _validateAccount(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _accountError = '請輸入您的銀行卡號';
      });
    } else if (value.isNotEmpty) {
      if (value.length >= 16 && value.length <= 19) {
        logger.i('account length: ${value.length}');
        setState(() {
          _accountError = null;
        });
      } else if (value.length < 16 || value.length > 19) {
        setState(() {
          _accountError = '帳戶長度為16~19';
        });
      }
    }
    _checkFormValidity();
  }

  void _validateBankName(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _bankNameError = '請輸入銀行名稱';
      });
    } else if (value.isNotEmpty) {
      setState(() {
        _bankNameError = null;
      });
    }
    _checkFormValidity();
  }

  void _validateLegalName(String? value) {
    if (value!.isEmpty) {
      _legalNameError = '請輸入您的真實姓名';
    } else if (value.isNotEmpty) {
      logger.i('value.isNotEmpty');
      _legalNameError = null;
    }
    _checkFormValidity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gameLobbyBgColor,
        centerTitle: true,
        title: Text(
          '銀行卡設置',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: gameLobbyAppBarTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: gameLobbyAppBarIconColor),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height - 40,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          color: gameLobbyBgColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.info_rounded,
                          color: gameLobbyHintColor,
                          size: 14,
                        ),
                      ),
                      TextSpan(
                        text: ' 綁定後不可更改，請確認資料填寫正確，避免影響到帳。',
                        style: TextStyle(
                          color: gameLobbyHintColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 28,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: gameItemMainColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        FormBuilderField<String?>(
                          name: 'bankName',
                          onChanged: (val) => logger.i(val.toString()),
                          builder: (FormFieldState field) {
                            return AutoComplete(
                              label: '銀行名稱',
                              hint: '請輸入銀行名稱',
                              controller: bankNameController,
                              listContent: bankList,
                              onChanged: (value) => {
                                _validateBankName(value),
                              },
                              errorMessage: _bankNameError,
                              onClear: () => {
                                setState(() {
                                  _bankNameEnable.value = false;
                                })
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        FormBuilderField<String?>(
                          name: 'branchName',
                          onChanged: (val) => logger.i(val.toString()),
                          builder: (FormFieldState field) {
                            return GameInput(
                              label: '支行名稱',
                              hint: '請輸入支行名稱(選填)',
                              controller: branchNameController,
                              onChanged: (val) => logger.i(val.toString()),
                              onClear: () => branchNameController.clear(),
                              errorMessage: _formKey.currentState!
                                  .fields['branchName']!.errorText,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        FormBuilderField<String?>(
                          name: 'account',
                          builder: (FormFieldState field) {
                            return GameInput(
                              label: '銀行卡號',
                              hint: '請輸入您的銀行卡號',
                              controller: accountController,
                              onChanged: (value) => {
                                _validateAccount(value),
                              },
                              onClear: () {
                                accountController.clear();
                                setState(() {
                                  _accountEnable = false;
                                });
                              },
                              errorMessage: _accountError,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        FormBuilderField<String?>(
                          name: 'legalName',
                          builder: (FormFieldState field) {
                            return GameInput(
                              label: '真實姓名',
                              hint: '請輸入您的真實姓名',
                              controller: legalNameController,
                              onChanged: (value) => {
                                _validateLegalName(value),
                              },
                              onClear: () {
                                legalNameController.clear();
                                setState(() {
                                  _legalNameEnable = false;
                                });
                              },
                              errorMessage: _legalNameError,
                            );
                          },
                        ),
                        const SizedBox(height: 44),
                        GameButton(
                          text: '確認',
                          onPressed: () => _onSubmit(),
                          disabled: _legalNameEnable == false ||
                              _bankNameEnable.value == false ||
                              _accountEnable == false ||
                              _accountError != null ||
                              _bankNameError != null ||
                              _legalNameError != null ||
                              accountController.text.isEmpty ||
                              bankNameController.text.isEmpty ||
                              legalNameController.text.isEmpty,
                        ),
                      ],
                    ),
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
