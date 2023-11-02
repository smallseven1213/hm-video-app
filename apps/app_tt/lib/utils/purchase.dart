import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/hm_api_response.dart';
import 'package:shared/navigator/delegate.dart';

import 'show_confirm_dialog.dart';

final vodApi = VodApi();

void purchase(
  BuildContext context, {
  required int id,
  required Function onSuccess,
}) async {
  try {
    HMApiResponse results = await vodApi.purchase(id);
    bool coinNotEnough = results.code == '50508';
    if (results.code == '00') {
      onSuccess();
    } else {
      if (context.mounted) {
        showConfirmDialog(
          context: context,
          title: coinNotEnough
              ? I18n.insufficientGoldBalance
              : I18n.purchaseFailed,
          message:
              coinNotEnough ? I18n.goToTopUpNowForFullExp : results.message,
          showCancelButton: coinNotEnough,
          confirmButtonText: coinNotEnough ? I18n.goToTopUp : I18n.confirm,
          cancelButtonText: I18n.cancel,
          onConfirm: () => coinNotEnough
              ? MyRouteDelegate.of(context).push(AppRoutes.coin)
              : null,
        );
      }
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    showConfirmDialog(
      context: context,
      title: I18n.purchaseFailed,
      message: I18n.purchaseFailed,
      showCancelButton: false,
      onConfirm: () {
        // Navigator.of(context).pop();
      },
    );
  }
}
