import 'package:flutter/material.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/hm_api_response.dart';
import 'package:shared/navigator/delegate.dart';

import '../localization/shared_localization_delegate.dart';

final vodApi = VodApi();

void purchase(
  BuildContext context, {
  required int id,
  required Function onSuccess,
  required Function showConfirmDialog,
}) async {
  SharedLocalizations localizations = SharedLocalizations.of(context)!;

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
              ? localizations.translate('insufficient_gold_balance')
              : localizations.translate('purchase_failed'),
          message: coinNotEnough
              ? localizations.translate('go_to_top_up_now_for_full_exp')
              : results.message,
          showCancelButton: coinNotEnough,
          confirmButtonText: coinNotEnough
              ? localizations.translate('go_to_top_up')
              : localizations.translate('confirm'),
          cancelButtonText: localizations.translate('cancel'),
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
      title: localizations.translate('purchase_failed'),
      message: localizations.translate('purchase_failed'),
      showCancelButton: false,
      onConfirm: () {
        // Navigator.of(context).pop();
      },
    );
  }
}
