// paymentPage:3 transfer bank / mobile deposit
import 'package:flutter/material.dart';
import 'package:game/controllers/game_payment_type.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_deposit_list_screen/channel_empty.dart';
import 'package:game/screens/game_deposit_list_screen/tips.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_deposit.dart';
import 'package:game/screens/user_info/game_user_info_deposit_history.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:game/screens/user_info/game_user_info_withdraw.dart';
import 'package:game/utils/loading.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/pay_switch_button.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/game_localization_delegate.dart';
import 'payment_items.dart';

class GameDepositBankMobile extends StatelessWidget {
  GameDepositBankMobile({Key? key}) : super(key: key);

  final DepositPaymentsTypeController controller =
      Get.put(DepositPaymentsTypeController());
  final GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();

  void showConfirmDialogWrapper(BuildContext context) {
    showConfirmDialog(
      context: context,
      title: '',
      content: GameLocalizations.of(context)!
          .translate('you_have_been_logged_out_please_log_in_again'),
      onConfirm: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: gameLobbyBgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            localizations.translate('deposit'),
            style: TextStyle(
              color: gameLobbyAppBarTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: gameLobbyBgColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: gameLobbyAppBarIconColor),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: GameLoading());
          }

          if (!controller.isSuccess.value ||
              controller.paymentTypeList.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showConfirmDialogWrapper(context);
            });
            return const SizedBox.shrink();
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: gameLobbyBgColor,
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        PaySwitchButton(
                          leftChild: UserInfoDeposit(
                            onTap: () {
                              MyRouteDelegate.of(context).push(
                                gameConfigController.depositRoute.value,
                                removeSamePath: true,
                              );
                            },
                          ),
                          rightChild: UserInfoWithdraw(
                            onTap: () {
                              MyRouteDelegate.of(context).push(
                                  GameAppRoutes.withdraw,
                                  removeSamePath: true);
                            },
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          child: GameUserInfo(
                            child: Wrap(
                              spacing: 20,
                              children: [
                                UserInfoDepositHistory(),
                                UserInfoService(),
                              ],
                            ),
                          ),
                        ),
                        controller.paymentTypeList.isNotEmpty
                            ? DepositPaymentItems(
                                paymentList: controller.paymentTypeList,
                                initialIndex:
                                    controller.paymentTypeList[0].code,
                              )
                            : const DepositChannelEmpty(),
                        const SizedBox(height: 36),
                        const Tips(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
