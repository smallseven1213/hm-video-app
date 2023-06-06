import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/showConfirmDialog.dart';
import 'package:game/widgets/input.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/controllers/user_controller.dart';

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
  _GameLobbyRegisterFormState createState() => _GameLobbyRegisterFormState();
}

class _GameLobbyRegisterFormState extends State<GameLobbyRegisterForm> {
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

  @override
  void initState() {
    super.initState();
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    '註冊成功',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              widget.onSuccess(),
            },
          );
    } catch (e) {
      showConfirmDialog(
        context: context,
        title: '',
        content: e.toString(),
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      onChanged: () {
        _formKey.currentState!.save();
      },
      child: Column(
        children: [
          FormBuilderField<String?>(
            name: 'username',
            onChanged: (val) => {
              if (_formKey.currentState?.fields['username']?.validate() == true)
                {
                  setState(() {
                    enableUsername = true;
                  }),
                }
              else
                {
                  setState(() {
                    enableUsername = false;
                  }),
                },
              logger.i(val.toString())
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: '請輸入帳號',
              ),
              FormBuilderValidators.match(r'^[a-z0-9]{6,12}$',
                  errorText: '*帳號為 6~12 位字母及數字'),
            ]),
            builder: (FormFieldState field) {
              return GameInput(
                label: "帳號",
                hint: "6~12位字母及數字",
                controller: userNameController,
                hasIcon: Icon(
                  Icons.person,
                  color: gameLobbyIconColor,
                  size: 16,
                ),
                errorMessage: field.errorText,
              );
            },
          ),
          const SizedBox(height: 5),
          FormBuilderField<String?>(
            name: 'password',
            onChanged: (val) => {
              if (_formKey.currentState?.fields['password']?.validate() == true)
                {
                  setState(() {
                    enablePassword = true;
                  }),
                }
              else
                {
                  setState(() {
                    enablePassword = false;
                  }),
                },
              logger.i(val.toString())
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: '請輸入密碼',
              ),
              FormBuilderValidators.match(r'^[a-z0-9]{8,20}$',
                  errorText: '*密碼為 8-20 位字母及數字'),
            ]),
            builder: (FormFieldState field) {
              return GameInput(
                label: "密碼",
                hint: "請輸入密碼",
                isPassword: true,
                controller: passwordController,
                hasIcon: Icon(
                  Icons.lock,
                  color: gameLobbyIconColor,
                  size: 16,
                ),
                errorMessage: field.errorText,
              );
            },
          ),
          const SizedBox(height: 5),
          FormBuilderField<String?>(
            name: 'passwordCheck',
            onChanged: (val) => {
              if (_formKey.currentState?.fields['passwordCheck']?.validate() ==
                  true)
                {
                  setState(() {
                    enablePasswordCheck = true;
                  }),
                }
              else
                {
                  setState(() {
                    enablePasswordCheck = false;
                  }),
                },
              logger.i(val.toString())
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: '請輸入密碼',
              ),
              FormBuilderValidators.equal(passwordController.text,
                  errorText: '*二次密碼不正確'),
            ]),
            builder: (FormFieldState field) {
              return GameInput(
                label: "驗證密碼",
                hint: "請輸入密碼",
                isPassword: true,
                controller: passwordCheckController,
                hasIcon: Icon(
                  Icons.lock,
                  color: gameLobbyIconColor,
                  size: 16,
                ),
                errorMessage: field.errorText,
              );
            },
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
                child: Text("立即註冊",
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
