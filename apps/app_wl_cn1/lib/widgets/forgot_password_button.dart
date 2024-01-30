import 'package:app_wl_cn1/config/colors.dart';
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
            title: '忘记密码',
            message: '请联系客服人员',
            showCancelButton: false,
            onConfirm: () {});
      },
      child: Column(children: [
        Text('忘记密码',
            style: TextStyle(color: AppColors.colors[ColorKeys.textPrimary])),
      ]),
    );
  }
}
