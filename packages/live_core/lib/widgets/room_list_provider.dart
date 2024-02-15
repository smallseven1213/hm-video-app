import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../socket/live_web_socket_manager.dart';

class RoomListProvider extends StatefulWidget {
  final Widget child;

  const RoomListProvider({
    super.key,
    required this.child,
  });

  @override
  _RoomListProviderState createState() => _RoomListProviderState();
}

class _RoomListProviderState extends State<RoomListProvider> {
  late LiveSocketIOManager socketIOManager;
  String? latestMessage;
  late StreamSubscription _messageSubscription;

  @override
  void initState() {
    super.initState();
    final token = GetStorage().read('live-token');
    socketIOManager = LiveSocketIOManager();

    socketIOManager.connect(
      'wss://dev-live-ext-ws.hmtech-dev.com:443/user?token=$token',
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
    print('### latestMessage: ${socketIOManager.messages}');
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
