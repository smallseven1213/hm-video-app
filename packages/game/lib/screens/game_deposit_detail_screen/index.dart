import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/showConfirmDialog.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GameDepositDetail extends StatefulWidget {
  const GameDepositDetail({Key? key}) : super(key: key);

  @override
  _GameDepositDetailState createState() => _GameDepositDetailState();
}

class _GameDepositDetailState extends State<GameDepositDetail> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDepositChannel();
  }

  void _getDepositChannel() async {
    try {
      var res = await GameLobbyApi().getDepositChannel();
      if (res['code'] != '00') {
        // ignore: use_build_context_synchronously
        showConfirmDialog(
          context: context,
          title: '',
          content: '你已被登出，請重新登入',
          onConfirm: () async {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
        return;
      } else {}
    } catch (error) {
      logger.i('_getDepositChannel $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: gameLobbyBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '銀行轉帳 / USDT',
            style: TextStyle(
              color: gameLobbyAppBarTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: gameLobbyBgColor,
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: gameLobbyBgColor,
          child: const SingleChildScrollView(child: Text('usdt / debit')),
        ),
      ),
    );
  }
}
