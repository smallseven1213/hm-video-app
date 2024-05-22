import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/widgets/ui_bottom_safearea.dart';

import '../../localization/live_localization_delegate.dart';

class MessageInput extends StatelessWidget {
  final int pid;

  const MessageInput({super.key, required this.pid});

  @override
  Widget build(BuildContext context) {
    final liveRoomController =
        Get.find<LiveRoomController>(tag: pid.toString());
    return Obx(() {
      if (!liveRoomController.displayChatInput.value) {
        return const SizedBox();
      }
      return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
              onTap: () {},
              child: Container(
                  height: 64,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      bottom: kIsWeb
                          ? 0
                          : MediaQuery.of(context).viewInsets.bottom),
                  child: MessageInputWidget(pid: pid))));
    });
  }
}

class MessageInputWidget extends StatefulWidget {
  final int pid;
  const MessageInputWidget({
    super.key,
    required this.pid,
  });

  @override
  MessageInputWidgetState createState() => MessageInputWidgetState();
}

class MessageInputWidgetState extends State<MessageInputWidget> {
  late LiveSocketIOManager socketManager;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    socketManager = LiveSocketIOManager();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    // keyboardSubscription.cancel();
    super.dispose();
  }

  void sendMessage() {
    final liveRoomController =
        Get.find<LiveRoomController>(tag: widget.pid.toString());
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      dynamic jsonData = {
        'msg': message,
        'ntype': 1,
      };

      socketManager.send('chat', jsonData);
      _messageController.clear();
      // liveRoomController.displayChatInput.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiController = Get.find<UIController>();
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return UIBottomSafeArea(
      child: Container(
        height: 54,
        padding: EdgeInsets.only(
          left: 5,
          right: 5,
          top: 5,
          bottom: 5 +
              MediaQuery.of(context).padding.bottom +
              (uiController.isIphoneSafari.value ? 20 : 0),
        ),
        color: const Color(0xFF242a3d),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autofocus: true,
                  controller: _messageController,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF242A3D)),
                  decoration: InputDecoration(
                    hintText:
                        localizations.translate('say_something_to_the_host'),
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Color(0xFF7b7b7b)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  onSubmitted: (_) {
                    sendMessage(); // 當按下Enter鍵時調用
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () {
                sendMessage();
              },
              child: SizedBox(
                width: 60,
                child: Center(
                  child: Text(
                    localizations.translate('send'),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
