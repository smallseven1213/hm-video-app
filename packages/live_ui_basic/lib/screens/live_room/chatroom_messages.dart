import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/chat_result_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';

import '../../widgets/fade_on_scroll_item.dart';
import 'messages/message_item.dart';

class ChatroomMessages extends StatefulWidget {
  final int pid;
  const ChatroomMessages({Key? key, required this.pid}) : super(key: key);
  @override
  ChatroomMessagesState createState() => ChatroomMessagesState();
}

class ChatroomMessagesState extends State<ChatroomMessages>
    with SingleTickerProviderStateMixin {
  final GiftsController giftsController = Get.find<GiftsController>();
  final LiveSocketIOManager socketManager = LiveSocketIOManager();
  final ChatResultController chatResultController =
      Get.find<ChatResultController>();
  final ScrollController _scrollController = ScrollController();
  int _topItemIndex = 0;

  @override
  void initState() {
    super.initState();
    // 監聽滾動事件
    _scrollController.addListener(() {
      var currentItemIndex = (_scrollController.offset /
              _scrollController.position.maxScrollExtent *
              20) // 假設有20項
          .floor();
      if (_topItemIndex != currentItemIndex) {
        setState(() {
          _topItemIndex = currentItemIndex;
        });
      }
    });
  }

  double _getOpacityForItem(double itemOffset, double viewportHeight) {
    const double visibleThreshold = 50.0;
    // 計算項目底部距離視圖頂部的距離
    double distanceFromTop = viewportHeight - itemOffset;
    // 當項目在視圖頂部0~50px範圍內時，調整透明度
    if (distanceFromTop > 0 && distanceFromTop <= visibleThreshold) {
      return distanceFromTop / visibleThreshold;
    }
    // 超出範圍，透明度設為1
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            // 這裡用於觸發重建，以更新透明度，但實際上不做任何處理
            setState(() {});
            return true;
          },
          child: ListView.builder(
            reverse: true,
            controller: _scrollController,
            itemCount: chatResultController.commonMessages.length,
            itemBuilder: (context, index) {
              int reversedIndex =
                  chatResultController.commonMessages.length - 1 - index;

              final topPosition = index * 36.0;
              return FadeOnScrollItem(
                topPosition: topPosition,
                scrollController: _scrollController,
                child: MessageItem(
                    pid: widget.pid,
                    message: chatResultController
                        .commonMessages.value[reversedIndex]),
              );
            },
          ),
        ));
    // return Obx(() => ListView.builder(
    //       reverse: true,
    //       // padding 0
    //       padding: EdgeInsets.zero,
    //       itemCount: chatResultController.commonMessages.length,
    //       itemBuilder: (context, index) {
    // int reversedIndex =
    //     chatResultController.commonMessages.length - 1 - index;
    // return MessageItem(
    //     pid: widget.pid,
    //     message:
    //         chatResultController.commonMessages.value[reversedIndex]);
    //       },
    //     ));
  }
}
