import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game/screens/game_deposit_list_screen/submit_deposit_order.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/widgets/button.dart';
import 'package:get_storage/get_storage.dart';

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
  bool isUnfocus = false;
  final theme = themeMode[GetStorage().hasData('pageColor')
          ? GetStorage().read('pageColor')
          : 1]
      .toString();

  @override
  void dispose() {
    textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      await submitDepositOrder(
        context,
        amount: widget.amount,
        paymentChannelId: int.parse(widget.paymentChannelId),
        userName: textEditingController.text,
        activePayment: widget.activePayment,
      );
    }

    textEditingController.clear();
    setState(() {
      enableSubmit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Image.asset(
            'packages/game/assets/images/game_deposit/deposit_confirm-$theme.webp',
            width: 65,
            height: 65,
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
          padding: const EdgeInsets.only(top: 16),
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
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
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: gameLobbyLoginFormBorderColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: gameLobbyLoginFormBorderColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: gameLobbyLoginFormBorderColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
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
                ),
                // 一個確認按鈕用來送出表單
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GameButton(
                    text: '確認',
                    onPressed: () {
                      _focusNode.unfocus();
                      _focusNode.requestFocus(FocusNode()); //remove focus
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      setState(() {
                        isUnfocus = true;
                      });

                      if (!_focusNode.hasFocus && enableSubmit && isUnfocus) {
                        // 當焦點失去時，執行 submit 的動作
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _submitForm();
                          setState(() {
                            isUnfocus = false;
                          });
                        });
                      }
                    },
                    disabled: !enableSubmit,
                  ),
                ),
              ],
            )),
      ]),
    );
  }
}
