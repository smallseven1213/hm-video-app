// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/models/bank.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/onLoading.dart';
import 'package:game/utils/showFundingPasswordBottomSheet.dart';
import 'package:game/widgets/autocomplete.dart';
import 'package:game/widgets/button.dart';
import 'package:game/widgets/input.dart';
import 'package:get/get.dart';
import 'package:shared/navigator/delegate.dart';

class GameSetBankCard extends StatefulWidget {
  const GameSetBankCard({Key? key}) : super(key: key);

  @override
  _GameSetBankCardState createState() => _GameSetBankCardState();
}

class _GameSetBankCardState extends State<GameSetBankCard> {
  // set表單
  final accountController = TextEditingController();
  final bankNameController = TextEditingController();
  final legalNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _enableSubmit = false;
  List<BankItem> BankList = [];
  final gameWithdrawController = Get.put(GameWithdrawController());

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
      if (_formKey.currentState!.saveAndValidate()) {
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
      }
    } catch (e) {
      print(e);
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
        BankList = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gameLobbyBgColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: gameLobbyBgColor,
        ),
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
                    onChanged: () {
                      _formKey.currentState!.save();
                      setState(() {
                        _enableSubmit =
                            _formKey.currentState?.validate() ?? false;
                      });
                    },
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        FormBuilderField<String?>(
                          name: 'bankName',
                          onChanged: (val) => debugPrint(val.toString()),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: '請輸入銀行名稱',
                            ),
                          ]),
                          builder: (FormFieldState field) {
                            return AutoComplete(
                              label: '銀行名稱',
                              hint: '請輸入銀行名稱',
                              controller: bankNameController,
                              listContent: BankList,
                              onChanged: (value) => field.didChange(value),
                              errorMessage: _formKey
                                  .currentState!.fields['bankName']!.errorText,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        FormBuilderField<String?>(
                          name: 'branchName',
                          onChanged: (val) => debugPrint(val.toString()),
                          builder: (FormFieldState field) {
                            return GameInput(
                              label: '支行名稱',
                              hint: '請輸入支行名稱(選填)',
                              controller: branchNameController,
                              onChanged: (value) => field.didChange(value),
                              errorMessage: _formKey.currentState!
                                  .fields['branchName']!.errorText,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        FormBuilderField<String?>(
                          name: 'account',
                          onChanged: (val) => debugPrint(val.toString()),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: '請輸入您的銀行卡號',
                            ),
                            FormBuilderValidators.minLength(16,
                                errorText: '帳戶長度為16~19'),
                            FormBuilderValidators.maxLength(19,
                                errorText: '帳戶長度為16~19')
                          ]),
                          builder: (FormFieldState field) {
                            return GameInput(
                              label: '銀行卡號',
                              hint: '請輸入您的銀行卡號',
                              controller: accountController,
                              onChanged: (value) => field.didChange(value),
                              errorMessage: _formKey
                                  .currentState!.fields['account']!.errorText,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        FormBuilderField<String?>(
                          name: 'legalName',
                          onChanged: (val) => debugPrint(val.toString()),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: '請輸入您的真實姓名',
                            ),
                          ]),
                          builder: (FormFieldState field) {
                            return GameInput(
                              label: '真實姓名',
                              hint: '請輸入您的真實姓名',
                              controller: legalNameController,
                              onChanged: (value) => field.didChange(value),
                              errorMessage: _formKey
                                  .currentState!.fields['legalName']!.errorText,
                            );
                          },
                        ),
                        const SizedBox(height: 44),
                        GameButton(
                          text: '確認',
                          onPressed: () => _onSubmit(),
                          disabled: !_enableSubmit,
                        )
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
