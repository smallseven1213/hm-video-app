import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/controllers/live_user_controller.dart';
import 'package:live_core/controllers/room_rank_controller.dart';
import 'package:live_ui_basic/libs/showLiveDialog.dart';

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

  // initState
  @override
  void initState() {
    super.initState();
    liveroomController = Get.find(tag: widget.pid.toString());
    _rankController = Get.find(tag: widget.pid.toString());

    ever(_rankController.shouldShowPaymentPrompt,
        _handleShouldShowPaymentPrompt);
  }

  void _handleShouldShowPaymentPrompt(bool shouldShowPaymentPrompt) {
    if (shouldShowPaymentPrompt && !_rankController.userClosedDialog) {
      showLiveDialog(
        context,
        title: '計時付費',
        content: const Center(
          child: Text('付費時間已到，是否續費',
              style: TextStyle(color: Colors.white, fontSize: 11)),
        ),
        actions: [
          LiveButton(
              text: '取消',
              type: ButtonType.secondary,
              onTap: () {
                _rankController.setUserClosedDialog();
                Navigator.of(context).pop();
              }),
          LiveButton(
              text: '確定',
              type: ButtonType.primary,
              onTap: () async {
                var price = liveroomController.displayAmount.value;
                var userAmount = Get.find<LiveUserController>().getAmount;
                if (userAmount < price) {
                  Navigator.of(context).pop();
                  showLiveDialog(
                    context,
                    title: '鑽石不足',
                    content: const Center(
                      child: Text('鑽石不足，請前往充值',
                          style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                    actions: [
                      LiveButton(
                          text: '取消',
                          type: ButtonType.secondary,
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                      LiveButton(
                          text: '確定',
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
