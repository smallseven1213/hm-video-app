import 'package:app_51ss/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

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
      child: Column(children: [
        Text('忘記密碼',
            style: TextStyle(color: AppColors.colors[ColorKeys.textPrimary])),
      ]),
    );
  }
}
