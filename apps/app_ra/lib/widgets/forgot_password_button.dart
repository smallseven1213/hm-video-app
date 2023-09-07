import 'package:flutter/material.dart';
import '../../utils/show_confirm_dialog.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showConfirmDialog(
            context: context,
            title: '忘記密碼',
            message: '請聯繫客服人員',
            showCancelButton: false,
            onConfirm: () {});
      },
      child: const Text(
        '找回密碼',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
