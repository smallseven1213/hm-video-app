import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_response_controller.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/widgets/button.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/lobby/show_register_fail_dialog.dart';
import 'package:game/screens/game_register_mobile_binding_screen/mobile_number_form_field.dart';

import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class GameRegisterMobileBinding extends StatefulWidget {
  const GameRegisterMobileBinding({Key? key}) : super(key: key);

  @override
  GameRegisterMobileBindingState createState() =>
      GameRegisterMobileBindingState();
}

class GameRegisterMobileBindingState extends State<GameRegisterMobileBinding> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  TextEditingController controller = TextEditingController();
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();
  GameApiResponseErrorCatchController responseController =
      Get.find<GameApiResponseErrorCatchController>();

  bool enableSubmit = false;
  String phoneRegExp = '^(09|9)\\d{8}\$';

  String get parsePhoneNumber => controller.text.startsWith('0')
      ? controller.text.substring(1)
      : controller.text;

  handleNextStep() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      GameLobbyApi gameLobbyApi = GameLobbyApi();

      try {
        var res = await gameLobbyApi.registerMobileBinding(
          countryCode: gameConfigController.countryCode.value!,
          phoneNumber: parsePhoneNumber,
        );

        if (res.code == '00' && mounted) {
          logger.i('parsePhoneNumber: $parsePhoneNumber');
          Fluttertoast.showToast(
            msg: '驗證碼已發送',
            gravity: ToastGravity.CENTER,
          );
          // 等待一秒後跳轉到手機驗證碼輸入頁面
          Future.delayed(const Duration(seconds: 1), () {
            MyRouteDelegate.of(context)
                .push(GameAppRoutes.registerMobileConfirm, args: {
              'parsePhoneNumber': parsePhoneNumber,
            });
          });
        }
      } catch (e) {
        logger.e('handleNextStep error: $e');
        if (mounted) {
          showRegisterFailDialog(
              context, responseController.responseMessage.value);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: gameLobbyBgColor,
          centerTitle: true,
          title: Text(
            '手機驗證 - 輸入手機號碼',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: gameLobbyAppBarTextColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: gameLobbyAppBarIconColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 40,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            color: gameLobbyBgColor,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child:
                    // 請幫我產生一個表單
                    // 表單有一個輸入框，用來輸入手機號碼
                    // 輸入框的label文字是「手機號」
                    // 輸入框的placeholder文字是「請輸入手機號碼」
                    // 輸入框的鍵盤類型是數字鍵盤
                    // 輸入框的驗證規則是必填
                    // 輸入框的驗證規則格式：僅可輸入數字、開頭只可為 09 或 9 +{任意八位數字}
                    // 輸入框有一個x的icon，點擊後可以清空輸入框
                    // 表單下方有一個按鈕，按鈕文字是「下一步」
                    FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: FormBuilderField<String?>(
                      name: 'phoneNumber',
                      builder: (FormFieldState field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '綁定手機號後將會寄送驗證碼，請於五分鐘內進行驗證。',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: gameLobbyPrimaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              '手機號',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: gameLobbyPrimaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            MobileNumberFormField(
                              controller: controller,
                              field: field,
                              handleButtonEnable: (bool value) {
                                setState(() {
                                  enableSubmit = value;
                                });
                              },
                            ),
                            const SizedBox(height: 30),
                            GameButton(
                              text: '下一步',
                              disabled: !enableSubmit,
                              onPressed: () => handleNextStep(),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ),
          ),
        ));
  }
}
