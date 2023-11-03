import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/button.dart';
import 'package:game/widgets/input2.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/game_localization_deletate.dart';

final logger = Logger();

class GameSetFundPassword extends StatefulWidget {
  const GameSetFundPassword({Key? key}) : super(key: key);

  @override
  GameSetFundPasswordState createState() => GameSetFundPasswordState();
}

class GameSetFundPasswordState extends State<GameSetFundPassword> {
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  bool isConfirmButtonEnabled = false;
  Map errors = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final gameWithdrawController = Get.put(GameWithdrawController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  updateFundPassword() async {
    if (!isConfirmButtonEnabled) return;
    try {
      await Get.find<GameLobbyApi>().updatePaymentPin(passwordController.text);
      // ignore: use_build_context_synchronously
      showConfirmDialog(
        context: context,
        title: "",
        content: "設置成功",
        barrierDismissible: false,
        confirmText: GameLocalizations.of(context)!.translate('confirm'),
        onConfirm: () => {
          gameWithdrawController.mutate(),
          gameWithdrawController.setLoadingStatus(false),
          Navigator.pop(context),
          MyRouteDelegate.of(context).popRoute(),
        },
      );
    } catch (e) {
      logger.i('res: $e');
      // 設置失敗
      showConfirmDialog(
        context: context,
        title: "",
        content: "設置失敗",
        barrierDismissible: false,
        confirmText: "確定",
        onConfirm: () => Navigator.pop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gameLobbyBgColor,
        centerTitle: true,
        title: Text(
          '設置資金密碼',
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
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 28,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: gameItemMainColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .15),
                      offset: Offset(0, 0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  onChanged: () {
                    logger.i('_formKey.currentState ${_formKey.currentState}');
                    logger.i(
                        '_formKey.currentState.validate() ${_formKey.currentState?.validate()}');
                    setState(() {
                      isConfirmButtonEnabled =
                          _formKey.currentState?.validate() ?? false;
                    });
                  },
                  child: Column(
                    children: [
                      FormField(
                        validator: (value) {
                          if (value.toString().length != 6) {
                            return '* 密碼長度應為6位數';
                          }
                          return null;
                        },
                        builder: (FormFieldState field) {
                          return GameInput2(
                            label: '輸入資金密碼',
                            hint: '請輸入6位數字',
                            controller: passwordController,
                            field: field,
                            isPassword: true,
                          );
                        },
                      ),
                      FormField(
                        validator: (value) {
                          if (value.toString().length != 6) {
                            return '* 密碼長度應為6位數';
                          }
                          if (value != passwordController.text) {
                            return '* 二次驗證密碼輸入應相同';
                          }
                          return null;
                        },
                        builder: (FormFieldState field) {
                          return GameInput2(
                            label: '再次確認密碼',
                            hint: '請再次確認密碼',
                            controller: passwordConfirmController,
                            field: field,
                            isPassword: true,
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      GameButton(
                        text: '確認送出',
                        onPressed: () => updateFundPassword(),
                        disabled: !isConfirmButtonEnabled,
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

// class FormController extends StatefulWidget {
//   const FormController({
//     Key? key,
//     required this.builder,
//     required this.validator,
//     required this.controller,
//   }) : super(key: key);
//   final Function builder;
//   final Function validator;
//   final TextEditingController controller;

//   @override
//   State<FormController> createState() => _FormControllerState();
// }

// class _FormControllerState extends State<FormController> {
//   String errorText = '';

//   @override
//   void initState() {
//     // TODO: implement initState
//     // 執行一次驗證
//     setState(() {
//       errorText = widget.validator();
//     });
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     setState(() {
//       errorText = widget.validator();
//     });
//     logger.i('object: ${widget.controller.text}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: widget.builder(errorText),
//     );
//   }
// }
