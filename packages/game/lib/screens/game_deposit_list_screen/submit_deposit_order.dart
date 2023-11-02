// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/on_loading.dart';
import 'package:game/utils/show_form_dialog.dart';
import 'package:get/get.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/i18n.dart';

submitDepositOrder(
  context, {
  required String amount,
  required int paymentChannelId,
  required String? userName,
  required String activePayment,
}) async {
  onLoading(context, status: true);

  try {
    var value = await GameLobbyApi().makeOrderV2(
      amount: amount,
      paymentChannelId: paymentChannelId,
      name: userName ?? '',
    );
    if (value.isNotEmpty && value.startsWith('http')) {
      if (GetPlatform.isWeb) {
        await Future.delayed(const Duration(milliseconds: 500));
        onLoading(context, status: false);
        Navigator.pop(context);
        launch(value, webOnlyWindowName: '_blank');
        MyRouteDelegate.of(context).push(GameAppRoutes.paymentResult);
      } else {
        // ignore: deprecated_member_use
        await launch(value, webOnlyWindowName: '_blank');
        onLoading(context, status: false);
        Navigator.pop(context);
        MyRouteDelegate.of(context).push(GameAppRoutes.paymentResult);
      }
    } else {
      onLoading(context, status: false);
      showFormDialog(
        context,
        title: I18n.transactionFailed,
        content: SizedBox(
          height: 24,
          child: Center(
            child: Text(
              value == '51728'
                  ? I18n.thereAreManyPeoplePayingAtTheMomentPleaseTryAgainLater
                  : I18n.orderCreationFailedPleaseContactOurCustomerService,
              style: TextStyle(color: gameLobbyPrimaryTextColor),
            ),
          ),
        ),
        confirmText: I18n.confirm,
        onConfirm: () => {
          Navigator.pop(context),
          Navigator.pop(context),
        },
      );
    }
  } catch (e) {
    onLoading(context, status: false);
    showFormDialog(
      context,
      title: I18n.transactionFailed,
      content: SizedBox(
        height: 60,
        child: Center(
          child: Text(
            I18n.orderCreationFailedPleaseContactOurCustomerService,
            style: TextStyle(color: gameLobbyPrimaryTextColor),
          ),
        ),
      ),
      confirmText: I18n.confirm,
      onConfirm: () => {
        Navigator.pop(context),
        Navigator.pop(context),
      },
    );
  }
}
