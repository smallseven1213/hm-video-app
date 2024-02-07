import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import '../socket/live_web_socket_manager.dart';

class RoomListProvider extends StatefulWidget {
  // final String chatToken;
  final Widget child;

  const RoomListProvider({
    super.key,
    // required this.chatToken,
    required this.child,
  });

  @override
  _RoomListProviderState createState() => _RoomListProviderState();
}

class _RoomListProviderState extends State<RoomListProvider> {
  late LiveSocketIOManager socketIOManager;

  @override
  void initState() {
    super.initState();
    final token = GetStorage().read('live-token');
    socketIOManager = LiveSocketIOManager();
    socketIOManager.connect(
        'wss://dev-live-ext-ws.hmtech-dev.com:443/user?token=$token', token);
  }

  @override
  Widget build(BuildContext context) {
    return RoomListSocketIOProvider(
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

class RoomListSocketIOProvider extends InheritedWidget {
  final LiveSocketIOManager manager;

  RoomListSocketIOProvider({required this.manager, required Widget child})
      : super(child: child);

  static RoomListSocketIOProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RoomListSocketIOProvider>();
  }

  @override
  bool updateShouldNotify(RoomListSocketIOProvider oldWidget) {
    print('### oldWidget : ${oldWidget.manager}');
    return manager != oldWidget.manager;
  }
}
