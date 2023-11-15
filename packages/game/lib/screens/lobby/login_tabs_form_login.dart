import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:shared/apis/auth_api.dart';
import 'package:shared/controllers/auth_controller.dart';

import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/input.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

enum Type { login, register }

class GameLobbyLoginForm extends StatefulWidget {
  const GameLobbyLoginForm({
    Key? key,
    required this.onSuccess,
    required this.onToggleTab,
    this.style,
  }) : super(key: key);

  final String? style;
  final Function() onSuccess;
  final Function() onToggleTab;

  @override
  GameLobbyLoginFormState createState() => GameLobbyLoginFormState();
}

class GameLobbyLoginFormState extends State<GameLobbyLoginForm> {
  Type tabsType = Type.login;
  final authApi = AuthApi();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool enableUsername = false;
  bool enablePassword = false;
  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
  }

  void _onLogin(context) async {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    try {
      var authToken = await authApi.login(
        username: userNameController.text,
        password: passwordController.text,
      );
      if (authToken == null) {
        showConfirmDialog(
          context: context,
          title: localizations.translate('login_error'),
          content: localizations.translate('incorrect_username_or_password'),
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
        return;
      } else {
        Get.find<AuthController>().setToken(authToken);
        widget.onSuccess();
        Fluttertoast.showToast(
          msg: localizations.translate('login_successful'),
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      showConfirmDialog(
        context: context,
        title: localizations.translate('login_error'),
        content: localizations.translate('incorrect_username_or_password'),
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
      logger.i(e);
      return;
    }
  }

  void _checkFormValidity() {
    setState(() {
      enableUsername =
          _usernameError == null && userNameController.text.isNotEmpty;
      enablePassword =
          _passwordError == null && passwordController.text.isNotEmpty;
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

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Column(
      children: [
        GameInput(
          label: localizations.translate('username'),
          hint: localizations.translate('letters_and_numbers'),
          controller: userNameController,
          onChanged: (value) => _validateUsername(value),
          onClear: () {
            userNameController.clear();
            setState(() {
              enableUsername = false;
            });
          },
          hasIcon: Icon(
            Icons.person,
            color: gameLobbyIconColor,
            size: 16,
          ),
          errorMessage: _usernameError,
        ),
        const SizedBox(height: 20),
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
            })
          },
          hasIcon: Icon(
            Icons.lock,
            color: gameLobbyIconColor,
            size: 16,
          ),
          errorMessage: _passwordError,
        ),
        const SizedBox(height: 30),
        TextButton(
          onPressed: () {
            // 表單驗證ok才能點擊，否則按鈕不能點擊
            if (enableUsername && enablePassword) {
              _onLogin(context);
            } else {
              null;
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            decoration: BoxDecoration(
              // 表單驗證ok才能點擊，否則按鈕不能點擊，背景色要換成灰色
              color: enableUsername && enablePassword
                  ? gamePrimaryButtonColor
                  : gameLobbyButtonDisableColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(localizations.translate('login_now'),
                  style: TextStyle(
                      color: enableUsername && enablePassword
                          ? gamePrimaryButtonTextColor
                          : gameLobbyButtonDisableTextColor,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          children: [
            InkWell(
              onTap: () {
                widget.onToggleTab();
              },
              child: Text(
                localizations.translate('no_account_yet'),
                style: TextStyle(color: gamePrimaryButtonColor, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                color: gameSecondButtonColor,
                width: 1,
                height: 15,
              ),
            ),
            InkWell(
              onTap: () {
                showConfirmDialog(
                  context: context,
                  title: localizations.translate('forgot_your_password'),
                  content: localizations.translate(
                      'please_contact_customer_service_or_log_in_with_your_id_card'),
                  onConfirm: () {
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Text(
                localizations.translate('forgot_your_password'),
                style: TextStyle(
                  color: gameLobbyButtonDisableTextColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
