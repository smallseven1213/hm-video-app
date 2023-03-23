import 'package:flutter/material.dart';

import '../../utils/showConfirmDialog.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showConfirmDialog(
            context: context,
            title: '忘记密码',
            message: '请联系客服人员',
            onConfirm: () {});
      },
      child: Column(children: [
        Text('忘記密碼', style: TextStyle(color: Colors.white)),
      ]),
    );
  }
}
