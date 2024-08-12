import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/handel_submit_amount.dart';
import 'package:game/widgets/button.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../localization/game_localization_delegate.dart';

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
  final bool requireName;
  final bool requirePhone;

  const AmountForm(
      {Key? key,
      required this.formKey,
      required this.controller,
      required this.max,
      required this.min,
      required this.activePayment,
      required this.paymentChannelId,
      required this.focusNode,
      required this.requireName,
      required this.requirePhone,
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
    final GameLocalizations localizations = GameLocalizations.of(context)!;
    var parseMaxText = widget.max ?? 0;
    var parseMinText = widget.min ?? 0;

    logger.i('max: ${widget.max.toString()}, min: ${widget.min.toString()}');

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
                    errorStyle: const TextStyle(
                      fontSize: 11,
                      overflow: TextOverflow.visible, // 自動換行
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
                    suffix: Text(
                      localizations.translate('dollar'),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: gameLobbyPrimaryTextColor,
                      ),
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
                  onChanged: (val) => logger.i(val.toString()),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: localizations
                          .translate('please_enter_the_deposit_amount'),
                    ),
                    FormBuilderValidators.match(
                      r'^[0-9]+(\.[0-9]{1,2})?$',
                      errorText: localizations
                          .translate('input_amount_is_in_wrong_format'),
                    ),
                    if (widget.min != null)
                      FormBuilderValidators.min(
                        widget.min ?? 0,
                        errorText: localizations.translate(
                            'the_entered_amount_is_less_than_the_available_deposit_amount'),
                      ),
                    if (widget.max != null)
                      FormBuilderValidators.max(
                        widget.max ?? 0,
                        errorText: localizations.translate(
                            'the_entered_amount_exceeds_the_available_deposit_amount'),
                      ),
                  ]),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 80,
                height: 40,
                child: GameButton(
                  text: localizations.translate('confirm'),
                  fontSize: 12.0,
                  onPressed: () {
                    gameWithdrawController
                        .setDepositAmount(widget.controller.text);

                    if (widget.formKey.currentState?.validate() == true) {
                      handleSubmitAmount(
                        context,
                        enableSubmit: _enableSubmit,
                        controller: widget.controller,
                        activePayment: widget.activePayment,
                        paymentChannelId: widget.paymentChannelId,
                        requireName: widget.requireName,
                        focusNode: widget.focusNode,
                        requirePhone: widget.requirePhone,
                      );
                    }
                  },
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
