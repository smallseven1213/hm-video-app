import 'package:flutter/material.dart';

import '../socket/live_web_socket_manager.dart';

class ChatroomProvider extends StatefulWidget {
  final String chatToken;
  final Widget child;

  const ChatroomProvider(
      {super.key, required this.chatToken, required this.child});

  @override
  _ChatroomProviderState createState() => _ChatroomProviderState();
}

class _ChatroomProviderState extends State<ChatroomProvider> {
  late LiveSocketIOManager socketIOManager;

  @override
  void initState() {
    super.initState();
    socketIOManager = LiveSocketIOManager();
    socketIOManager.connect(
        'wss://dev-live-chat.hmtech-dev.com:443/', widget.chatToken);
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
    super.dispose();
  }
}

class ChatroomSocketIOProvider extends InheritedWidget {
  final LiveSocketIOManager manager;

  ChatroomSocketIOProvider({required this.manager, required Widget child})
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
