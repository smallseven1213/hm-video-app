import 'package:flutter/material.dart';
import 'package:game/controllers/game_banner_controller.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/localization/game_localization_delegate.dart';
import 'package:game/models/user_withdrawal_data.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

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
    if (gameWithdrawController.userKyc.isNotEmpty &&
        gameWithdrawController.cellPhoneIsBound.value == false) {
      logger.i(
          'cellPhoneIsBound: ${gameWithdrawController.cellPhoneIsBound.value}');
      showConfirmDialog(
        context: context,
        title: localizations.translate('binding_mobile'),
        content: localizations.translate('complete_phone_verification_first'),
        confirmText: localizations.translate('go_to_binding'),
        onConfirm: () {
          MyRouteDelegate.of(context).push(GameAppRoutes.registerMobileBinding);
          Navigator.pop(context);
        },
        cancelText: localizations.translate('back'),
        onCancel: () =>
            Get.find<GameStartupController>().goBackToAppHome(context),
      );
    }
    // 前往绑定身份证
    else if (gameWithdrawController.userKyc.isNotEmpty &&
        gameWithdrawController.cellPhoneIsBound.value &&
        gameWithdrawController.idCardIsBound.value == false &&
        gameWithdrawController.idCardStatus.value == null) {
      logger.i('idCardIsBound: ${gameWithdrawController.idCardStatus.value}');
      showConfirmDialog(
        context: context,
        title: localizations.translate('bind_id_card'),
        content: localizations.translate('complete_id_verification_first'),
        onConfirm: () {
          MyRouteDelegate.of(context).push(GameAppRoutes.registerIdCardBinding);
          Navigator.pop(context);
        },
        cancelText: localizations.translate('back'),
        onCancel: () =>
            Get.find<GameStartupController>().goBackToAppHome(context),
      );
    }
    // 身份证審核中
    else if (gameWithdrawController.userKyc.isNotEmpty &&
        gameWithdrawController.cellPhoneIsBound.value &&
        gameWithdrawController.idCardIsBound.value == false &&
        gameWithdrawController.idCardStatus.value ==
            idCardStatusEnum['REVIEWING']) {
      showConfirmDialog(
        context: context,
        title: localizations.translate('bind_id_card'),
        content: localizations.translate('id_verification_pending'),
        confirmText: localizations.translate('contact_customer_service'),
        onConfirm: () =>
            launchUrl(Uri.parse(gameBannerController.customerServiceUrl.value)),
        cancelText: localizations.translate('cancel'),
        onCancel: () =>
            Get.find<GameStartupController>().goBackToAppHome(context),
      );
    }
    // 身份证審核已拒絕
    else if (gameWithdrawController.userKyc.isNotEmpty &&
        gameWithdrawController.cellPhoneIsBound.value &&
        gameWithdrawController.idCardIsBound.value == false &&
        gameWithdrawController.idCardStatus.value ==
            idCardStatusEnum['REJECTED']) {
      showConfirmDialog(
        context: context,
        title: localizations.translate('bind_id_card'),
        content: localizations.translate('id_verification_failed'),
        confirmText: localizations.translate('rebind'),
        onConfirm: () {
          MyRouteDelegate.of(context).push(GameAppRoutes.registerIdCardBinding);
          Navigator.pop(context);
        },
        cancelText: localizations.translate('contact_customer_service'),
        onCancel: () =>
            launchUrl(Uri.parse(gameBannerController.customerServiceUrl.value)),
      );
    }
    // 身份证審核通過
    else if (gameWithdrawController.userKyc.isNotEmpty &&
        gameWithdrawController.cellPhoneIsBound.value &&
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
