import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/controllers/live_user_controller.dart';
import 'package:live_core/controllers/room_rank_controller.dart';
import 'package:live_ui_basic/libs/showLiveDialog.dart';

import '../../localization/live_localization_delegate.dart';
import '../../widgets/live_button.dart';

final liveApi = LiveApi();

class PaymentDialog extends StatefulWidget {
  final int pid;

  const PaymentDialog({super.key, required this.pid});

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  bool isPurchasing = false;
  late LiveRoomController liveroomController;
  late RoomRankController _rankController;
  late LiveLocalizations localizations;

  // initState
  @override
  void initState() {
    super.initState();
    liveroomController = Get.find(tag: widget.pid.toString());
    _rankController = Get.find(tag: widget.pid.toString());
    localizations = LiveLocalizations.of(context)!;
    ever(_rankController.shouldShowPaymentPrompt,
        _handleShouldShowPaymentPrompt);
  }

  void _handleShouldShowPaymentPrompt(bool shouldShowPaymentPrompt) {
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
                    } on Exception catch (e) {
                      print(e);
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
