import 'package:app_wl_id1/localization/i18n.dart';
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
            title: I18n.forgotPassword,
            message: I18n.contactCustomerService,
            showCancelButton: false,
            onConfirm: () {});
      },
      child: Column(children: [
        Text(I18n.forgotPassword, style: const TextStyle(color: Colors.white)),
      ]),
    );
  }
}
