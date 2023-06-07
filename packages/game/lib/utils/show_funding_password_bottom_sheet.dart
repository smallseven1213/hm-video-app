import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/widgets/button.dart';
import 'package:game/widgets/input.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';

final logger = Logger();

void showFundingPasswordBottomSheet(BuildContext context,
    {required Function(String? pin) onSuccess, Function()? onClose}) {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormBuilderState>();
  final gameWithdrawController = Get.put(GameWithdrawController());
  final GlobalKey globalKey = GlobalKey();

  void onSubmit(context) async {
    gameWithdrawController.setSubmitButtonDisable(true);
    final response =
        await Get.put(GameLobbyApi()).checkPaymentPin(passwordController.text);

    if (response.data == true) {
      onSuccess(passwordController.text);
      MyRouteDelegate.of(context).popRoute();
    } else {
      ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text(
            '密碼錯誤',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.0),
      ),
    ),
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: gameLobbyBgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          height: GetPlatform.isWeb ? 220 : 250,
          child: Obx(
            () => Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xff979797),
                        ),
                        onPressed: () {
                          gameWithdrawController.setSubmitButtonDisable(true);
                          Navigator.pop(context);
                          onClose!();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          '輸入資金密碼',
                          style: TextStyle(
                            color: gameLobbyAppBarTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // create a TextField and that's margin vertical is 20

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FormBuilder(
                    key: formKey,
                    onChanged: () {
                      formKey.currentState!.save();
                    },
                    child: FormBuilderField<String?>(
                      name: 'password',
                      onChanged: (val) => logger.i(val.toString()),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: '請輸入資金密碼',
                        ),
                        FormBuilderValidators.minLength(6, errorText: '密碼長度不足'),
                      ]),
                      builder: (FormFieldState field) {
                        return GameInput(
                          label: '資金密碼',
                          hint: '請輸入資金密碼',
                          controller: passwordController,
                          isPassword: true,
                          onChanged: (value) => {
                            field.didChange(value),
                            gameWithdrawController.setSubmitButtonDisable(
                              passwordController.text.length >= 6
                                  ? false
                                  : true,
                            )
                          },
                          errorMessage: formKey
                              .currentState!.fields['password']!.errorText,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                // create a confirm button, that's margin vertical is 30, and it' height is 44, text is center
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  height: 44,
                  child: GameButton(
                    text: "確認送出",
                    onPressed: () => onSubmit(context),
                    disabled: gameWithdrawController.enableSubmit.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
