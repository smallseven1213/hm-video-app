import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/controllers/live_user_controller.dart';
import 'package:live_core/controllers/room_rank_controller.dart';
import 'package:live_ui_basic/libs/show_live_dialog.dart';

import '../../libs/goto_deposit.dart';
import '../../localization/live_localization_delegate.dart';
import '../../widgets/live_button.dart';

final liveApi = LiveApi();

class PaymentDialog extends StatefulWidget {
  final int pid;

  const PaymentDialog({super.key, required this.pid});

  @override
  PaymentDialogState createState() => PaymentDialogState();
}

class PaymentDialogState extends State<PaymentDialog> {
  bool isPurchasing = false;
  late LiveRoomController liveroomController;
  late RoomRankController _rankController;

  // initState
  @override
  void initState() {
    super.initState();
    liveroomController = Get.find(tag: widget.pid.toString());
    _rankController = Get.find(tag: widget.pid.toString());
    ever(_rankController.shouldShowPaymentPrompt,
        _handleShouldShowPaymentPrompt);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _handleShouldShowPaymentPrompt(bool shouldShowPaymentPrompt) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;
    if (shouldShowPaymentPrompt && !_rankController.userClosedDialog) {
      showLiveDialog(
        context,
        title: localizations.translate('timed_payment'),
        content: Center(
          child: Text(
              localizations
                  .translate('whether_to_continue_after_paid_time_expires'),
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ),
        actions: [
          LiveButton(
              text: localizations.translate('cancel'),
              type: ButtonType.secondary,
              onTap: () {
                _rankController.setUserClosedDialog();
                Navigator.of(context).pop();
              }),
          LiveButton(
              text: localizations.translate('confirm'),
              type: ButtonType.primary,
              onTap: () async {
                var price = liveroomController.displayAmount.value;
                var userAmount = Get.find<LiveUserController>().getAmount;
                if (userAmount < price) {
                  Navigator.of(context).pop();
                  showLiveDialog(
                    context,
                    title: localizations.translate('not_enough_diamonds'),
                    content: Center(
                      child: Text(
                          localizations.translate(
                              'insufficient_diamonds_please_recharge'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11)),
                    ),
                    actions: [
                      LiveButton(
                          text: localizations.translate('cancel'),
                          type: ButtonType.secondary,
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                      LiveButton(
                          text: localizations.translate('confirm'),
                          type: ButtonType.primary,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            gotoDeposit();
                          })
                    ],
                  );
                } else {
                  if (!isPurchasing) {
                    setState(() {
                      isPurchasing = true;
                    });
                    try {
                      var userIsAutoRenew =
                          Get.find<LiveUserController>().isAutoRenew.value;
                      var result =
                          await liveApi.buyWatch(widget.pid, userIsAutoRenew);
                      if (result.code == 200) {
                        await liveroomController.fetchData();
                        Navigator.of(context).pop();
                      } else {}
                    } finally {
                      Get.find<LiveUserController>().getUserDetail();
                      setState(() {
                        isPurchasing = false;
                      });
                    }
                  }
                }
              })
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
