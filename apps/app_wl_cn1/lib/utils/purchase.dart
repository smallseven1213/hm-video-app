import 'package:app_wl_cn1/utils/show_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/hm_api_response.dart';
import 'package:shared/navigator/delegate.dart';

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
          title: coinNotEnough ? '金幣餘額不足' : '購買失敗',
          message: coinNotEnough ? '請立即前往充值已獲得最完整的體驗' : results.message,
          showCancelButton: coinNotEnough,
          confirmButtonText: coinNotEnough ? '前往充值' : '確認',
          cancelButtonText: '取消',
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
      title: '購買失敗',
      message: '購買失敗',
      showCancelButton: false,
      onConfirm: () {
        // Navigator.of(context).pop();
      },
    );
  }
}
