import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_deposit_list_screen/confirm_name.dart';
import 'package:game/screens/game_deposit_list_screen/confirm_pin.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_model.dart';
import 'package:game/widgets/button.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/i18n.dart';

final logger = Logger();

class AmountForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  final double? max;
  final double? min;
  final Function? onChanged;
  final String activePayment;
  final String paymentChannelId;
  final FocusNode focusNode;

  const AmountForm(
      {Key? key,
      required this.formKey,
      required this.controller,
      required this.max,
      required this.min,
      required this.activePayment,
      required this.paymentChannelId,
      required this.focusNode,
      this.onChanged})
      : super(key: key);

  @override
  State<AmountForm> createState() => _AmountFormState();
}

class _AmountFormState extends State<AmountForm> {
  bool _enableSubmit = false;
  final gameWithdrawController = Get.put(GameWithdrawController());

  @override
  void initState() {
    super.initState();

    if (widget.controller.text.isNotEmpty) {
      setState(() {
        _enableSubmit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 放入一個Row,有一個input跟一個確認按鈕
    // input有validator,確認按鈕有onPressed和disabledColor
    // input的max和min根據_channels[_channelActiveIndex]['maxAmount']和_channels[_channelActiveIndex]['minAmount']來做驗證，並且只能輸入數字
    // 如果驗證失敗會顯示"輸入金額小於或大於可存款金額"，並且按鈕disabled
    // input的onChanged要把值傳到amountController.text

    var parseMaxText = widget.max?.toStringAsFixed(0);
    var parseMinText = widget.min?.toStringAsFixed(0);

    logger.i('max: ${widget.max.toString()}, min: ${widget.min.toString()}');

    handleAmount() {
      gameWithdrawController.setDepositAmount(widget.controller.text);
      if (widget.formKey.currentState?.validate() == true) {
        if (widget.activePayment == 'debit') {
          logger.i('銀行卡');
          showModel(
            context,
            title: I18n.orderConfirmation,
            content: ConfirmName(
              amount: widget.controller.text,
              paymentChannelId: widget.paymentChannelId,
              activePayment: widget.activePayment,
            ),
            onClosed: () => Navigator.pop(context),
          );
          setState(() {
            _enableSubmit = false;
          });
        } else if (widget.activePayment == 'selfdebit' ||
            widget.activePayment == 'selfusdt') {
          setState(() {
            _enableSubmit = true;
          });
          MyRouteDelegate.of(context).push(
            GameAppRoutes.depositDetail,
            args: {
              'payment': widget.activePayment,
              'paymentChannelId': int.parse(widget.paymentChannelId),
            },
          );
        } else {
          showModel(
            context,
            title: I18n.orderConfirmation,
            content: ConfirmPin(
              amount: widget.controller.text,
              paymentChannelId: widget.paymentChannelId,
              activePayment: widget.activePayment,
            ),
            onClosed: () => Navigator.pop(context),
          );
          setState(() {
            _enableSubmit = false;
          });
        }
      }
      FocusScope.of(context).unfocus();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: FormBuilder(
        key: widget.formKey,
        onChanged: () {
          widget.formKey.currentState!.save();
          setState(() {
            _enableSubmit = widget.formKey.currentState?.validate() ?? false;
          });
          logger.i('驗證表單: ${widget.formKey.currentState?.validate()}');
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 0,
                ),
                child: FormBuilderTextField(
                  controller: widget.controller,
                  name: 'amount',
                  focusNode: widget.focusNode,
                  decoration: InputDecoration(
                    hintText: '$parseMinText ~ $parseMaxText',
                    hintStyle: TextStyle(color: gameLobbyLoginPlaceholderColor),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: gameLobbyLoginFormBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: gameLobbyLoginFormBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: gameLobbyLoginFormBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: gameLobbyIconColor,
                        size: 16,
                      ),
                      onPressed: () {
                        widget.controller.clear();
                      },
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(
                    fontSize: 12.0,
                    color: gameLobbyPrimaryTextColor,
                  ),
                  onChanged: (val) => {
                    logger.i('val: $val'),
                    logger.i(val.toString()),
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: '請輸入存款金額',
                    ),
                    FormBuilderValidators.match(
                      r'^[0-9]+(\.[0-9]{1,2})?$',
                      errorText: '輸入金額格式錯誤',
                    ),
                    if (widget.min != null)
                      FormBuilderValidators.min(widget.min ?? 0,
                          errorText: '輸入金額小於可存款金額'),
                    if (widget.max != null)
                      FormBuilderValidators.max(widget.max ?? 0,
                          errorText: '輸入金額大於可存款金額'),
                  ]),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 按鈕初始是disabled,當input驗證成功時才會變成enabled
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 70,
                height: 40,
                child: GameButton(
                  text: I18n.confirm,
                  onPressed: () => handleAmount(),
                  disabled: !_enableSubmit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
