import 'package:flutter/material.dart';
import 'package:game/localization/game_localization_delegate.dart';
import 'package:game/utils/show_confirm_dialog.dart';

void showRegisterFailDialog(BuildContext context, [String? message]) {
  showConfirmDialog(
    context: context,
    title: GameLocalizations.of(context)!.translate('registration_error'),
    content: message ??
        GameLocalizations.of(context)!
            .translate('incorrect_username_or_password'),
    onConfirm: () {
      Navigator.of(context).pop();
    },
  );
}
