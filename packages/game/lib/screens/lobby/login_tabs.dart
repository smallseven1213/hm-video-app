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
                  color: tabsType == Type.login
                      ? gamePrimaryButtonColor
                      : gameSecondButtonColor2,
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
                  color: tabsType == Type.register
                      ? gamePrimaryButtonColor
                      : gameSecondButtonColor1,
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
