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
            title: '忘記密碼',
            message: '請聯係客服人員',
            showCancelButton: false,
            onConfirm: () {});
      },
      child: Column(children: [
        Text('忘記密碼', style: TextStyle(color: Colors.white)),
      ]),
    );
  }
}
