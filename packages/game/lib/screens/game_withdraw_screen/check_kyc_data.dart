import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:game/controllers/game_banner_controller.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/localization/game_localization_delegate.dart';
import 'package:game/models/user_withdrawal_data.dart';
import 'package:game/utils/show_confirm_dialog.dart';

import 'package:shared/navigator/delegate.dart';

final logger = Logger();

GameWithdrawController gameWithdrawController =
    Get.find<GameWithdrawController>();
GameBannerController gameBannerController = Get.find<GameBannerController>();

checkKycData({
  required BuildContext context,
  required Function handleUserWithdrawalData,
}) async {
  final GameLocalizations localizations = GameLocalizations.of(context)!;

  try {
    var res = await gameWithdrawController.getWithDrawalData();

    if (res.isEmpty || !context.mounted) {
      return;
    }

    // 前往绑定手机
    if (gameWithdrawController.cellPhoneIsBound.value == false) {
      logger.i(
          'cellPhoneIsBound: ${gameWithdrawController.cellPhoneIsBound.value}');
      showConfirmDialog(
        context: context,
        title: '綁定手機號',
        content: '請先完成手機號碼驗證',
        confirmText: '前往',
        onConfirm: () {
          MyRouteDelegate.of(context).push(GameAppRoutes.registerMobileBinding);
          Navigator.pop(context);
        },
      );
    }
    // 前往绑定身份证
    else if (gameWithdrawController.cellPhoneIsBound.value &&
        gameWithdrawController.idCardIsBound.value == false &&
        gameWithdrawController.idCardStatus.value == null) {
      logger.i('idCardIsBound: ${gameWithdrawController.idCardStatus.value}');
      showConfirmDialog(
        context: context,
        title: '綁定身分證',
        content: '請先完成身分證驗證',
        onConfirm: () {
          MyRouteDelegate.of(context).push(GameAppRoutes.registerIdCardBinding);
          Navigator.pop(context);
        },
      );
    }
    // 身份证審核中
    else if (gameWithdrawController.cellPhoneIsBound.value &&
        gameWithdrawController.idCardIsBound.value == false &&
        gameWithdrawController.idCardStatus.value ==
            idCardStatusEnum['REVIEWING']) {
      showConfirmDialog(
          context: context,
          title: '綁定身分證',
          content: '身分證審核中，請稍候。',
          confirmText: '聯繫客服',
          onConfirm: () => launchUrl(
              Uri.parse(gameBannerController.customerServiceUrl.value)),
          cancelText: localizations.translate('cancel'),
          onCancel: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
    }
    // 身份证審核已拒絕
    else if (gameWithdrawController.cellPhoneIsBound.value &&
        gameWithdrawController.idCardIsBound.value == false &&
        gameWithdrawController.idCardStatus.value ==
            idCardStatusEnum['REJECTED']) {
      showConfirmDialog(
        context: context,
        title: '綁定身分證',
        content: '身分證審核失敗，請重新綁定或聯繫客服。',
        confirmText: '重新綁定',
        onConfirm: () {
          MyRouteDelegate.of(context).push(GameAppRoutes.registerIdCardBinding);
          Navigator.pop(context);
        },
        cancelText: '聯繫客服',
        onCancel: () =>
            launchUrl(Uri.parse(gameBannerController.customerServiceUrl.value)),
      );
    }
    // 身份证審核通過
    else if (gameWithdrawController.cellPhoneIsBound.value &&
        gameWithdrawController.idCardIsBound.value) {
      handleUserWithdrawalData();
    }
  } catch (error) {
    logger.i('checkKycData error $error');

    if (context.mounted) {
      showConfirmDialog(
        context: context,
        title: '',
        content: error.toString(),
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    }
  }
  gameWithdrawController.setLoadingStatus(false);
}
