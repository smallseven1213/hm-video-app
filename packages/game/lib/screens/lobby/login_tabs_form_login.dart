import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:shared/apis/auth_api.dart';
import 'package:shared/controllers/auth_controller.dart';

import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/showConfirmDialog.dart';
import 'package:game/widgets/input.dart';

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
    try {
      var authToken = await authApi.login(
        username: userNameController.text,
        password: passwordController.text,
      );
      if (authToken == null) {
        showConfirmDialog(
          context: context,
          title: '登入錯誤',
          content: '帳號或密碼不正確',
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
        return;
      } else {
        Get.find<AuthController>().setToken(authToken);
        widget.onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '登入成功',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      showConfirmDialog(
        context: context,
        title: '登入錯誤',
        content: '帳號或密碼不正確',
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
        _usernameError = '請輸入帳號';
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
          _usernameError = '帳號為 6~12 位字母及數字';
        });
      }
    }
    _checkFormValidity();
  }

  void _validatePassword(String? value) {
    RegExp regString = RegExp(r'^[a-z0-9]{8,20}$');
    if (value!.isEmpty) {
      setState(() {
        _passwordError = '請輸入密碼';
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
          _passwordError = '*密碼為 8-20 位字母及數字';
        });
      }
    }
    _checkFormValidity();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameInput(
          label: "帳號",
          hint: "6~12位字母及數字",
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
          label: "密碼",
          hint: "請輸入密碼",
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
              child: Text("立即登錄",
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
                "還沒有帳號",
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
                  title: '忘記密碼',
                  content: '請聯繫客服，或用身份卡登入',
                  onConfirm: () {
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Text(
                "忘記密碼",
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
