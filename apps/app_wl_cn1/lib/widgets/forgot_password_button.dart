import 'package:app_wl_cn1/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../../utils/show_confirm_dialog.dart';
import '../localization/i18n.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showConfirmDialog(
            context: context,
            title: I18n.forgotPassword,
            message: I18n.contactCustomerService,
            showCancelButton: false,
            onConfirm: () {});
      },
      child: Column(children: [
        Text(I18n.forgotPassword,
            style: TextStyle(color: AppColors.colors[ColorKeys.textPrimary])),
      ]),
    );
  }
}
