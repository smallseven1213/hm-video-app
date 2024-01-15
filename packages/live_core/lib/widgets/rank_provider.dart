import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../controllers/room_rank_controller.dart';

class RankProvider extends StatefulWidget {
  final int pid;
  final Widget child;

  const RankProvider({Key? key, required this.pid, required this.child})
      : super(key: key);

  @override
  _RankProviderState createState() => _RankProviderState();
}

class _RankProviderState extends State<RankProvider> {
  late RoomRankController _rankController;

  @override
  void initState() {
    super.initState();
    _rankController =
        Get.put(RoomRankController(widget.pid), tag: widget.pid.toString());

    ever(_rankController.shouldShowPaymentPrompt,
        _handleShouldShowPaymentPrompt);
  }

  // _handleShouldShowPaymentPrompt
  void _handleShouldShowPaymentPrompt(bool shouldShowPaymentPrompt) {
    if (shouldShowPaymentPrompt) {
      // 顯示對話框
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: const Text('您的餘額不足，請儲值'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('確認'),
              ),
            ],
          );
        },
      ).then((value) {
        // 重置 shouldShowPaymentPrompt
        _rankController.shouldShowPaymentPrompt.value = false;
      });
    }
  }

  @override
  void dispose() {
    // 删除控制器
    Get.delete<RoomRankController>(tag: widget.pid.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
