import 'package:game/apis/auth_api.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/showConfirmDialog.dart';
import 'package:game/widgets/input.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

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
  _GameLobbyLoginFormState createState() => _GameLobbyLoginFormState();
}

class _GameLobbyLoginFormState extends State<GameLobbyLoginForm> {
  Type tabsType = Type.login;
  final authApi = AuthApi();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  bool enableUsername = false;
  bool enablePassword = false;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'error: ${e.toString()}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always, // 设置为始终即时验证
      child: Column(
        children: [
          FormBuilderTextField(
            key: const ValueKey('username_field'), // 设置稳定的键
            name: 'username',
            decoration: const InputDecoration(labelText: 'Username'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6),
              FormBuilderValidators.maxLength(12),
              FormBuilderValidators.match(r'^[a-z0-9]{6,12}$'),
            ]),
          ),
          const SizedBox(height: 20),
          FormBuilderField<String?>(
            name: 'password',
            onChanged: (val) => {
              logger.i('val: $val'),
              logger.i(
                  '_formKey password ${_formKey.currentState?.fields['password']?.validate()}'),
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
              logger.i('password:', val.toString())
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
                onClear: () {
                  passwordController.clear();
                  setState(() {
                    enablePassword = false;
                  });
                },
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
            // 這邊要放兩個Inkwell，分別是還沒有帳號和忘記密碼，中間有一個divider
            // 還沒有帳號的文字顏色要換成gamePrimaryButtonColor
            // 還沒有帳號要跳轉到註冊tab
            // 忘記密碼要show一個dialog，顯示忘記密碼的文字
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
      ),
    );
  }
}
