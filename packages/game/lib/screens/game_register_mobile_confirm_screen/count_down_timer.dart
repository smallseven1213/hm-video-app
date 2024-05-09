import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game/apis/game_api.dart';

import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/lobby/show_register_fail_dialog.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class CountdownTimer extends StatefulWidget {
  final String parsePhoneNumber;
  const CountdownTimer({super.key, required this.parsePhoneNumber});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  int _secondsRemaining = 300; // 5 minutes in seconds
  bool _isButtonDisabled = true;
  int _buttonCountdown = 60; // 1 minute in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel(); // Stop timer when countdown reaches 0
        }
        if (_buttonCountdown > 0 && _secondsRemaining > 0) {
          _buttonCountdown--;
        } else if (_buttonCountdown == 0) {
          _isButtonDisabled =
              false; // Enable button when button countdown reaches 0
        }
      });
    });
  }

  void restartTimer() {
    setState(() {
      _secondsRemaining = 300; // Reset remaining time to 5 minutes
      _buttonCountdown = 60; // Reset button countdown duration to 60 seconds
      _isButtonDisabled = true; // Disable button after clicking for re-sending
    });
    _timer.cancel(); // Cancel current timer
    startTimer(); // Start a new timer
  }

  void mutateMobileBinding() async {
    GameLobbyApi gameLobbyApi = GameLobbyApi();

    try {
      var res = await gameLobbyApi.registerMobileBinding(
        countryCode: gameConfigController.countryCode.value!,
        phoneNumber: widget.parsePhoneNumber,
      );

      if (res.code == '00' && mounted) {
        Fluttertoast.showToast(
          msg: '驗證碼已重新發送',
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      logger.e('mutateMobileBinding error: $e');
      if (mounted) {
        showRegisterFailDialog(
            context, responseController.responseMessage.value);
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '有效時間: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        InkWell(
          onTap: () {
            if (_isButtonDisabled) return; // 如果按钮不可点击则直接返回
            restartTimer(); // 点击重新倒计时的按钮时调用重新倒计时方法
            mutateMobileBinding(); // 调用父组件传递的方法
          },
          child: Text(
            '重寄$_buttonCountdown s',
            style: TextStyle(
              fontSize: 12,
              color: _isButtonDisabled ? Colors.grey : gamePrimaryButtonColor,
            ),
          ),
        ),
      ],
    );
  }
}
