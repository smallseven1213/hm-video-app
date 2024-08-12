import 'package:flutter/material.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/localization/game_localization_delegate.dart';
import 'package:game/screens/game_deposit_list_screen/confirm_name.dart';
import 'package:game/screens/game_deposit_list_screen/confirm_pin.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/utils/show_model.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/navigator/delegate.dart';

final logger = Logger();
UserController userController = Get.find<UserController>();

handleSubmitAmount(
  BuildContext context, {
  required bool enableSubmit,
  required TextEditingController controller,
  required String activePayment,
  required String paymentChannelId,
  required bool requireName,
  required bool requirePhone,
  required FocusNode focusNode,
}) {
  final GameLocalizations localizations = GameLocalizations.of(context)!;

  logger.i(
      'active 支付方式: $activePayment, 支付渠道id: $paymentChannelId, 提交金額: ${controller.text}, 需要確認姓名: $requireName, 需要確認手機綁定狀況: $requirePhone, 有無手機號碼: ${userController.info.value.phoneNumber}');
  if (requirePhone && userController.info.value.phoneNumber == null) {
    logger.i('確認手機號碼');
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
    enableSubmit = false;
  } else if (requireName) {
    logger.i('確認真實姓名');
    showModel(
      context,
      title: GameLocalizations.of(context)!.translate('order_confirmation'),
      content: ConfirmName(
        amount: controller.text,
        paymentChannelId: paymentChannelId,
        activePayment: activePayment,
      ),
      onClosed: () => Navigator.pop(context),
    );
    enableSubmit = false;
  } else if (activePayment == 'selfdebit' || activePayment == 'selfusdt') {
    enableSubmit = true;
    MyRouteDelegate.of(context).push(
      GameAppRoutes.depositDetail,
      args: {
        'payment': activePayment,
        'paymentChannelId': int.parse(paymentChannelId),
      },
    );
  } else {
    logger.i('確認pin');
    showModel(
      context,
      title: GameLocalizations.of(context)!.translate('order_confirmation'),
      content: ConfirmPin(
        amount: controller.text,
        paymentChannelId: paymentChannelId,
        activePayment: activePayment,
      ),
      onClosed: () => Navigator.pop(context),
    );
    enableSubmit = false;
  }

  FocusScope.of(context).unfocus();
}
