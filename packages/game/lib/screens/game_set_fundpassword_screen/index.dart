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

import '../../localization/game_localization_delegate.dart';

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

  void showSuccessDialog() {
    showConfirmDialog(
      context: context,
      title: "",
      content: GameLocalizations.of(context)!.translate('setup_successful'),
      barrierDismissible: false,
      confirmText: GameLocalizations.of(context)!.translate('confirm'),
      onConfirm: () => {
        // gameWithdrawController.mutate(),
        gameWithdrawController.setLoadingStatus(false),
        Navigator.pop(context),
        MyRouteDelegate.of(context).popRoute(),
      },
    );
  }

  void showFailDialog() {
    showConfirmDialog(
      context: context,
      title: "",
      content: GameLocalizations.of(context)!.translate('setting_failed'),
      barrierDismissible: false,
      confirmText: GameLocalizations.of(context)!.translate('confirm'),
      onConfirm: () => Navigator.pop(context),
    );
  }

  updateFundPassword() async {
    if (!isConfirmButtonEnabled) return;
    try {
      await Get.find<GameLobbyApi>().updatePaymentPin(passwordController.text);
      showSuccessDialog();
    } catch (e) {
      logger.i('res: $e');
      // 設置失敗
      showFailDialog();
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
          localizations.translate('set_a_funds_pin'),
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
                            return localizations
                                .translate('password_length_should_be_digits');
                          }
                          return null;
                        },
                        builder: (FormFieldState field) {
                          return GameInput2(
                            label: localizations.translate('input_funds_pin'),
                            hint:
                                localizations.translate('please_enter_digits'),
                            controller: passwordController,
                            field: field,
                            isPassword: true,
                          );
                        },
                      ),
                      FormField(
                        validator: (value) {
                          if (value.toString().length != 6) {
                            return localizations
                                .translate('password_length_should_be_digits');
                          }
                          if (value != passwordController.text) {
                            return localizations.translate(
                                'the_password_should_be_the_same_for_the_second_time');
                          }
                          return null;
                        },
                        builder: (FormFieldState field) {
                          return GameInput2(
                            label: localizations
                                .translate('confirm_password_again'),
                            hint: localizations
                                .translate('please_confirm_the_password_again'),
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
