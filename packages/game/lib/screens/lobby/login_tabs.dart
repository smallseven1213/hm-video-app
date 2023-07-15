import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/lobby/login_tabs_form_login.dart';
import 'package:game/screens/lobby/login_tabs_form_register.dart';

enum Type { login, register }

class GameLobbyLoginTabs extends StatefulWidget {
  const GameLobbyLoginTabs({
    Key? key,
    required this.type,
    required this.onSuccess,
  }) : super(key: key);

  final Type type;
  final Function() onSuccess;

  @override
  GameLobbyLoginTabsState createState() => GameLobbyLoginTabsState();
}

class GameLobbyLoginTabsState extends State<GameLobbyLoginTabs> {
  Type tabsType = Type.login;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool enableUsername = false;
  bool enablePassword = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      tabsType = widget.type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    tabsType = Type.login;
                  });
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: kIsWeb
                      ? null
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            // 設定漸層的背景顏色
                            colors: tabsType == Type.login
                                ? [
                                    gamePrimaryButtonColor,
                                    gamePrimaryButtonColor
                                  ]
                                : [
                                    gameSecondButtonColor1,
                                    gameSecondButtonColor2
                                  ], // 漸層的顏色列表
                            begin: Alignment.topCenter, // 漸層的起點位置
                            end: Alignment.bottomCenter, // 漸層的終點位置
                          ),
                        ),
                  child: Text(
                    "登入",
                    style: TextStyle(
                        color: tabsType == Type.login
                            ? gamePrimaryButtonTextColor
                            : gameSecondButtonTextColor),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    tabsType = Type.register;
                  });
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: kIsWeb ? null : BorderRadius.circular(24),
                    gradient: kIsWeb
                        ? null
                        : LinearGradient(
                            // 設定漸層的背景顏色
                            colors: tabsType == Type.register
                                ? [
                                    gamePrimaryButtonColor,
                                    gamePrimaryButtonColor
                                  ]
                                : [
                                    gameSecondButtonColor1,
                                    gameSecondButtonColor2
                                  ], // 漸層的顏色列表
                            begin: Alignment.topCenter, // 漸層的起點位置
                            end: Alignment.bottomCenter, // 漸層的終點位置
                          ),
                  ),
                  child: Text(
                    "註冊",
                    style: TextStyle(
                        color: tabsType == Type.register
                            ? gamePrimaryButtonTextColor
                            : gameSecondButtonTextColor),
                  ),
                ),
              ),
            ],
          ),
          tabsType == Type.login
              // login form
              ? GameLobbyLoginForm(
                  onSuccess: widget.onSuccess,
                  onToggleTab: () {
                    setState(() {
                      tabsType = Type.register;
                    });
                  })
              // register form
              : GameLobbyRegisterForm(
                  onSuccess: widget.onSuccess,
                ),
        ],
      ),
    );
  }
}
