import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/controllers/live_user_controller.dart';
import 'package:live_core/widgets/loading.dart';

import '../libs/show_live_dialog.dart';
import '../localization/live_localization_delegate.dart';
import 'live_button.dart';
import 'payment_check_box.dart';

final liveApi = LiveApi();

class RoomPaymentButton extends StatefulWidget {
  final int pid;

  const RoomPaymentButton({Key? key, required this.pid}) : super(key: key);

  @override
  RoomPaymentButtonState createState() => RoomPaymentButtonState();
}

class RoomPaymentButtonState extends State<RoomPaymentButton> {
  late LiveRoomController liveroomController;
  bool isPurchasing = false;

  @override
  void initState() {
    super.initState();
    liveroomController = Get.find(tag: widget.pid.toString());
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Obx(() {
      if (liveroomController.liveRoom.value == null ||
          liveroomController.liveRoomInfo.value?.chargeType == 1 ||
          liveroomController.displayAmount.value <= 0) {
        return Container();
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (liveroomController.liveRoomInfo.value?.chargeType == 3)
              const PaymentCheckbox(),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                var price = liveroomController.displayAmount.value;
                var userAmount = Get.find<LiveUserController>().getAmount;
                if (userAmount < price) {
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
                  if (liveroomController.liveRoomInfo.value?.chargeType == 3) {
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
                      } else {
                        // show alert
                      }
                    } finally {
                      Get.find<LiveUserController>().getUserDetail();
                      setState(() {
                        isPurchasing = false;
                      });
                    }
                  } else if (liveroomController
                          .liveRoomInfo.value?.chargeType ==
                      2) {
                    setState(() {
                      isPurchasing = true;
                    });
                    try {
                      // 付費直播
                      var result = await liveApi.buyTicket(widget.pid);
                      if (result.code == 200) {
                        liveroomController.fetchData();
                      } else {
                        // show alert
                      }
                    } finally {
                      Get.find<LiveUserController>().getUserDetail();
                      setState(() {
                        isPurchasing = false;
                      });
                    }
                  }
                }
              },
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFae57ff),
                  borderRadius: BorderRadius.circular(23.0),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isPurchasing)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: LoadingWidget(),
                        )
                      else ...[
                        Text(
                          localizations.translate('enter_paid_live'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 14),
                        Image.asset(
                          "packages/live_ui_basic/assets/images/rank_diamond.webp",
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 5),
                        if (liveroomController.displayAmount.value > 0)
                          Text(
                              liveroomController.displayAmount.value.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        if (liveroomController.liveRoomInfo.value?.chargeType ==
                            3)
                          Text(' /10${localizations.translate('point')}',
                              style: const TextStyle(
                                  color: Color(0xFFc8c8c8), fontSize: 12)),
                      ],
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }
    });
  }
}
