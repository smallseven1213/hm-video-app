import 'package:fluttertoast/fluttertoast.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/input.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/controllers/user_controller.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

enum Type { login, register }

class GameLobbyRegisterForm extends StatefulWidget {
  const GameLobbyRegisterForm({
    Key? key,
    required this.onSuccess,
    this.style,
  }) : super(key: key);

  final String? style;
  final Function() onSuccess;

  @override
  GameLobbyRegisterFormState createState() => GameLobbyRegisterFormState();
}

class GameLobbyRegisterFormState extends State<GameLobbyRegisterForm> {
  Type tabsType = Type.register;
  final authApi = AuthApi();
  final UserController userController = Get.find<UserController>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  bool enableUsername = false;
  bool enablePassword = false;
  bool enablePasswordCheck = false;
  String? _usernameError;
  String? _passwordError;
  String? _passwordCheckError;

  @override
  void initState() {
    super.initState();
  }

  void showRegisterFailDialog() {
    showConfirmDialog(
      context: context,
      title: GameLocalizations.of(context)!.translate('registration_error'),
      content: GameLocalizations.of(context)!
          .translate('incorrect_username_or_password'),
      onConfirm: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _onRegister() async {
    try {
      await authApi
          .register(
            username: userNameController.text,
            password: passwordController.text,
            uid: userController.info.value.uid,
          )
          .then(
            (value) => {
              Fluttertoast.showToast(
                msg: GameLocalizations.of(context)!
                    .translate('registration_successful'),
                gravity: ToastGravity.CENTER,
              ),
              widget.onSuccess(),
            },
          );
    } catch (e) {
      logger.i(e.toString());
      showRegisterFailDialog();
      return;
    }
  }

  void _checkFormValidity() {
    setState(() {
      enableUsername =
          _usernameError == null && userNameController.text.isNotEmpty;
      enablePassword =
          _passwordError == null && passwordController.text.isNotEmpty;
      enablePasswordCheck = _passwordCheckError == null &&
          passwordCheckController.text.isNotEmpty;
    });
  }

  void _validateUsername(String? value) {
    RegExp regString = RegExp(r'^[a-z0-9]{6,12}$');
    if (value!.isEmpty) {
      setState(() {
        _usernameError = GameLocalizations.of(context)!
            .translate('please_enter_your_username');
      });
    } else if (value.isNotEmpty) {
      if (value.length >= 6 && value.length <= 12) {
        setState(() {
          _usernameError = null;
        });
      } else if (value.length < 6 ||
          value.length > 12 ||
          !regString.hasMatch(value)) {
        setState(() {
          _usernameError = GameLocalizations.of(context)!
              .translate('account_is_digits_alphabetic_and_numeric');
        });
      }
    }
    _checkFormValidity();
  }

  void _validatePassword(String? value) {
    RegExp regString = RegExp(r'^[a-z0-9]{8,20}$');
    if (value!.isEmpty) {
      setState(() {
        _passwordError = GameLocalizations.of(context)!
            .translate('please_enter_your_password');
      });
    } else if (value.isNotEmpty) {
      if (value.length >= 8 && value.length <= 20) {
        setState(() {
          _passwordError = null;
        });
      } else if (value.length < 8 ||
          value.length > 20 ||
          !regString.hasMatch(value)) {
        setState(() {
          _passwordError = GameLocalizations.of(context)!
              .translate('password_is_letters_and_numbers');
        });
      }
    }
    _checkFormValidity();
  }

  void _validatePasswordCheck(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _passwordCheckError = GameLocalizations.of(context)!
            .translate('please_enter_your_password');
      });
    } else if (value.isNotEmpty) {
      if (value == passwordController.text) {
        setState(() {
          _passwordCheckError = null;
        });
      } else {
        setState(() {
          _passwordCheckError = GameLocalizations.of(context)!
              .translate('incorrect_secondary_password');
        });
      }
    }
    _checkFormValidity();
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return FormBuilder(
      key: _formKey,
      onChanged: () {
        _formKey.currentState!.save();
      },
      child: Column(
        children: [
          GameInput(
            label: localizations.translate('username'),
            hint: localizations.translate('letters_and_numbers'),
            controller: userNameController,
            onChanged: (value) => _validateUsername(value),
            onClear: () => {
              userNameController.clear(),
              setState(() {
                enableUsername = false;
              }),
            },
            hasIcon: Icon(
              Icons.person,
              color: gameLobbyIconColor,
              size: 16,
            ),
            errorMessage: _usernameError,
          ),
          const SizedBox(height: 5),
          GameInput(
            label: localizations.translate('password'),
            hint: localizations.translate('please_enter_your_password'),
            isPassword: true,
            controller: passwordController,
            onChanged: (value) => _validatePassword(value),
            onClear: () => {
              passwordController.clear(),
              setState(() {
                enablePassword = false;
              }),
            },
            hasIcon: Icon(
              Icons.lock,
              color: gameLobbyIconColor,
              size: 16,
            ),
            errorMessage: _passwordError,
          ),
          const SizedBox(height: 5),
          GameInput(
            label: localizations.translate('verify_password'),
            hint: localizations.translate('please_enter_your_password'),
            isPassword: true,
            controller: passwordCheckController,
            onChanged: (value) => _validatePasswordCheck(value),
            onClear: () => {
              passwordCheckController.clear(),
              setState(() {
                enablePasswordCheck = false;
              }),
            },
            hasIcon: Icon(
              Icons.lock,
              color: gameLobbyIconColor,
              size: 16,
            ),
            errorMessage: _passwordCheckError,
          ),
          const SizedBox(height: 30),
          // 這邊要放入一個確認按鈕，點擊後送出表單
          TextButton(
            onPressed: () {
              // 表單驗證ok才能點擊，否則按鈕不能點擊
              if (enableUsername && enablePassword) {
                // 送出表單
                _formKey.currentState!.save();
                logger.i(_formKey.currentState!.value.toString());
                _onRegister();
              } else {
                null;
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              decoration: BoxDecoration(
                // 表單驗證ok才能點擊，否則按鈕不能點擊，背景色要換成灰色
                color: enableUsername && enablePassword && enablePasswordCheck
                    ? gamePrimaryButtonColor
                    : gameLobbyButtonDisableColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(localizations.translate('register_now'),
                    style: TextStyle(
                        color: enableUsername &&
                                enablePassword &&
                                enablePasswordCheck
                            ? gamePrimaryButtonTextColor
                            : gameLobbyButtonDisableTextColor,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
