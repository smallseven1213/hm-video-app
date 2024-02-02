import 'package:app_ab/utils/show_confirm_dialog.dart';
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
          title: coinNotEnough ? '金币余额不足' : '购买失败',
          message: coinNotEnough ? '请立即前往充值已获得最完整的体验' : results.message,
          showCancelButton: coinNotEnough,
          confirmButtonText: coinNotEnough ? '前往充值' : '确认',
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
      title: '购买失败',
      message: '购买失败',
      showCancelButton: false,
      onConfirm: () {
        // Navigator.of(context).pop();
      },
    );
  }
}
