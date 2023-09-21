import 'package:app_ra/utils/show_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/hm_api_response.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/controller_tag_genarator.dart';

final vodApi = VodApi();

void purchase(
  BuildContext context, {
  required int id,
  Function? onSuccess,
}) async {
  try {
    HMApiResponse results = await vodApi.purchase(id);
    bool coinNotEnough = results.code == '50508';
    if (results.code == '00') {
      onSuccess!();
    } else {
      if (context.mounted) {
        showConfirmDialog(
          context: context,
          title: coinNotEnough ? '金幣餘額不足' : '購買失敗',
          message: coinNotEnough ? '請立即前往充值已獲得最完整的體驗' : results.message,
          showCancelButton: coinNotEnough,
          confirmButtonText: '前往充值',
          cancelButtonText: '取消',
          onConfirm: () => coinNotEnough
              ? MyRouteDelegate.of(context).push(AppRoutes.coin)
              : null,
        );
      }
    }
  } catch (e) {
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
