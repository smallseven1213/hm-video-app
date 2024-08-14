import 'package:app_wl_tw1/utils/show_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/purchase_type.dart';
import 'package:shared/navigator/delegate.dart';

final vodApi = VodApi();
final userApi = UserApi();

void purchase(
  BuildContext context, {
  PurchaseType type = PurchaseType.video,
  required int id,
  required Function onSuccess,
}) async {
  try {
    Map results = await userApi.purchase(type.index, id);
    bool coinNotEnough = results['code'] == '50508';
    if (results['code'] == '00') {
      onSuccess();
    } else {
      if (context.mounted) {
        showConfirmDialog(
          context: context,
          title: coinNotEnough ? '金幣餘額不足' : '購買失敗',
          message: coinNotEnough ? '請立即前往充值已獲得最完整的體驗' : results['message'],
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
    if (context.mounted) {
      showConfirmDialog(
        context: context,
        title: '購買失敗',
        message: '購買失敗',
        showCancelButton: false,
        onConfirm: () {},
      );
    }
  }
}
