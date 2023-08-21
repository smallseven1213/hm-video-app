import 'package:app_tt/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../../utils/show_confirm_dialog.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          alignment: WrapAlignment.start,
          children: [
            Text('忘記了?',
                style: TextStyle(
                  color: AppColors.colors[ColorKeys.textSecondary],
                  fontSize: 12,
                )),
            GestureDetector(
              onTap: () {
                showConfirmDialog(
                    context: context,
                    title: '忘記密碼',
                    message: '請聯繫客服人員',
                    showCancelButton: false,
                    onConfirm: () {});
              },
              child: Text(
                '找回密碼',
                style: TextStyle(
                  color: AppColors.colors[ColorKeys.textLink],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
