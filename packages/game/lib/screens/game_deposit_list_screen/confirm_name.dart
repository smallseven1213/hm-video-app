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

import '../../localization/game_localization_delegate.dart';

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
    final GameLocalizations localizations = GameLocalizations.of(context)!;

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
          '${localizations.translate('deposit_amount')}：${widget.amount}',
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
                    localizations.translate('please_enter_your_real_name'),
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
                    hintText:
                        localizations.translate('please_enter_your_real_name'),
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
                    FormBuilderValidators.required(
                      errorText: localizations
                          .translate('please_enter_your_real_name'),
                    ),
                    FormBuilderValidators.match(r"^[a-zA-Z\u4e00-\u9fa5]+$",
                        errorText: GameLocalizations.of(context)!
                            .translate('wrong_name_format')),
                  ]),
                  enabled: isFetching != 'complete',
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    enableSubmit && isFetching == 'start'
                        ? localizations.translate('get_the_link_to_reload')
                        : submitDepositSuccess && isFetching == 'complete'
                            ? localizations.translate('the_link_was_successful')
                            : !submitDepositSuccess && isFetching == 'complete'
                                ? localizations.translate(
                                    'failed_to_get_the_link_to_recharge_please_change_the_recharge_channel_or_contact_customer_service')
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
          text: GameLocalizations.of(context)!.translate('confirm'),
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
          text: submitDepositSuccess
              ? GameLocalizations.of(context)!.translate('open_top_up_page')
              : GameLocalizations.of(context)!.translate('close'),
          onPressed: () {
            if (submitDepositSuccess) {
              onLoading(context, status: false);
              Navigator.pop(context);
              launchUrl(Uri.parse(redirectUrl), webOnlyWindowName: '_blank');
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
