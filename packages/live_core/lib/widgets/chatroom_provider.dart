import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/chat_result_controller.dart';

import '../controllers/live_system_controller.dart';
import '../socket/live_web_socket_manager.dart';

class ChatroomProvider extends StatefulWidget {
  final String chatToken;
  final Widget child;

  const ChatroomProvider(
      {super.key, required this.chatToken, required this.child});

  @override
  ChatroomProviderState createState() => ChatroomProviderState();
}

class ChatroomProviderState extends State<ChatroomProvider> {
  late LiveSocketIOManager socketIOManager;

  @override
  void initState() {
    super.initState();
    final liveWsHostValue = Get.find<LiveSystemController>().liveWsHostValue;

    socketIOManager = LiveSocketIOManager();
    socketIOManager.connect('$liveWsHostValue/chat', widget.chatToken);
    Get.put(ChatResultController());
  }

  @override
  Widget build(BuildContext context) {
    return ChatroomSocketIOProvider(
      manager: socketIOManager,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    socketIOManager.close();
    Get.delete<ChatResultController>();
    super.dispose();
  }
}

class ChatroomSocketIOProvider extends InheritedWidget {
  final LiveSocketIOManager manager;

  const ChatroomSocketIOProvider(
      {super.key, required this.manager, required Widget child})
      : super(child: child);

  static ChatroomSocketIOProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ChatroomSocketIOProvider>();
  }

  @override
  bool updateShouldNotify(ChatroomSocketIOProvider oldWidget) {
    return manager != oldWidget.manager;
  }
}
