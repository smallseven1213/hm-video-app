import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/live_system_controller.dart';
import '../socket/live_web_socket_manager.dart';

class RoomListProvider extends StatefulWidget {
  final Widget child;

  const RoomListProvider({
    super.key,
    required this.child,
  });

  @override
  RoomListProviderState createState() => RoomListProviderState();
}

class RoomListProviderState extends State<RoomListProvider> {
  late LiveSocketIOManager socketIOManager;
  String? latestMessage;
  late StreamSubscription _messageSubscription;

  @override
  void initState() {
    super.initState();
    final token = GetStorage().read('live-token');
    final locale = GetStorage('locale').read('locale');
    final liveWsHostValue = Get.find<LiveSystemController>().liveWsHostValue;

    socketIOManager = LiveSocketIOManager();
    socketIOManager.connect(
      '$liveWsHostValue:443/user?token=$token&locale=$locale',
      token,
    );

    _messageSubscription = socketIOManager.messages.listen((message) {
      setState(() {
        latestMessage = message.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MessageProvider(
      message: latestMessage,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    socketIOManager.close();
    _messageSubscription.cancel();
    super.dispose();
  }
}

class MessageProvider extends InheritedWidget {
  final String? message;

  const MessageProvider({
    Key? key,
    required this.message,
    required Widget child,
  }) : super(key: key, child: child);

  static MessageProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MessageProvider>();
  }

  @override
  bool updateShouldNotify(MessageProvider oldWidget) {
    return message != oldWidget.message;
  }
}
