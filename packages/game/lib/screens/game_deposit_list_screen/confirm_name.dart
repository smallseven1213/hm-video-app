import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

import 'package:game/enums/game_app_routes.dart';
import 'package:game/utils/on_loading.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/widgets/button.dart';

import 'package:shared/navigator/delegate.dart';

import '../../localization/i18n.dart';

final logger = Logger();

class ConfirmName extends StatefulWidget {
  final String amount;
  final String paymentChannelId;
  final String activePayment;

  const ConfirmName({
    Key? key,
    required this.amount,
    required this.paymentChannelId,
    required this.activePayment,
  }) : super(key: key);

  @override
  ConfirmNameState createState() => ConfirmNameState();
}

class ConfirmNameState extends State<ConfirmName> {
  bool enableSubmit = false;
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  // bool isUnfocus = false;
  final theme = themeMode[GetStorage().hasData('pageColor')
          ? GetStorage().read('pageColor')
          : 1]
      .toString();
  String redirectUrl = '';
  bool submitDepositSuccess = false;
  String isFetching = '';

  @override
  void dispose() {
    textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void submitDepositOrderForName(
    context, {
    required String amount,
    required int paymentChannelId,
    required String? userName,
    required String activePayment,
  }) async {
    try {
      var value = await GameLobbyApi().makeOrderV2(
        amount: widget.amount,
        paymentChannelId: int.parse(widget.paymentChannelId),
        name: userName,
      );
      setState(() {
        redirectUrl = value;
        submitDepositSuccess = true;
        isFetching = 'complete';
      });
    } catch (e) {
      logger.e('name 交易失敗: $e');
      setState(() {
        submitDepositSuccess = false;
        isFetching = 'complete';
      });
    }
  }

  final borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: gameLobbyLoginFormBorderColor),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Image.asset(
            'packages/game/assets/images/game_deposit/deposit_confirm-$theme.webp',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          '存款金額：${widget.amount}',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: gameLobbyPrimaryTextColor),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Divider(
            color: gameLobbyDividerColor,
            thickness: 1,
          ),
        ),
        FormBuilder(
            key: _formKey,
            onChanged: () {
              _formKey.currentState!.save();
              setState(() {
                enableSubmit = _formKey.currentState?.validate() ?? false;
              });
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '請輸入真實姓名',
                    style: TextStyle(
                        fontSize: 16, color: gameLobbyPrimaryTextColor),
                  ),
                ),
                // 一個輸入框用來輸入姓名
                FormBuilderTextField(
                  name: 'name',
                  controller: textEditingController,
                  focusNode: enableSubmit ? null : _focusNode,
                  decoration: InputDecoration(
                    hintText: '請輸入真實姓名',
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: gameLobbyLoginPlaceholderColor),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: borderStyle,
                    focusedBorder: borderStyle,
                    enabledBorder: borderStyle,
                    disabledBorder: borderStyle,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: gameLobbyPrimaryTextColor,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: '請輸入真實姓名'),
                    FormBuilderValidators.match(r"^[a-zA-Z\u4e00-\u9fa5]+$",
                        errorText: '姓名格式錯誤'),
                  ]),
                  enabled: isFetching != 'complete',
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    enableSubmit && isFetching == 'start'
                        ? '取得充值連結...'
                        : submitDepositSuccess && isFetching == 'complete'
                            ? '充值連結取得成功！'
                            : !submitDepositSuccess && isFetching == 'complete'
                                ? '充值連結取得失敗\n請更換充值渠道或聯繫客服'
                                : '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: gameLobbyPrimaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildSubmitButton(),
              ],
            )),
      ]),
    );
  }

  Widget _buildSubmitButton() {
    if (isFetching != 'complete') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GameButton(
          text: I18n.confirm,
          onPressed: () {
            if (enableSubmit == true) {
              setState(() => isFetching = 'start');
              submitDepositOrderForName(
                context,
                amount: widget.amount,
                paymentChannelId: int.parse(widget.paymentChannelId),
                userName: textEditingController.text,
                activePayment: widget.activePayment,
              );
            }
          },
          disabled: !enableSubmit,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GameButton(
          text: submitDepositSuccess ? '開啟充值頁' : I18n.close,
          onPressed: () {
            if (submitDepositSuccess) {
              onLoading(context, status: false);
              Navigator.pop(context);
              launch(redirectUrl, webOnlyWindowName: '_blank');
              MyRouteDelegate.of(context).push(GameAppRoutes.paymentResult);
            } else {
              Navigator.pop(context);
            }
          },
          disabled: !enableSubmit,
        ),
      );
    }
  }
}
