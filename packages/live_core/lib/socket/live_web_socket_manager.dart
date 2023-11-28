import 'package:socket_io_client/socket_io_client.dart' as io;

class LiveSocketIOManager {
  static final LiveSocketIOManager _instance = LiveSocketIOManager._internal();
  io.Socket? _socket;

  factory LiveSocketIOManager() {
    return _instance;
  }

  LiveSocketIOManager._internal();

  void connect(String url, String chatToken) {
    _socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.onConnect((_) {
      print('connected');
      _login(chatToken); // 调用登录方法
    });

    _socket!.on('event', (data) {
      _onMessageReceived(data);
    });

    _socket!.onError((data) {
      _onError(data);
    });

    _socket!.onDisconnect((_) => _onDone());

    _socket!.connect();
  }

  void _login(String chatToken) {
    var loginData = {
      'cmd': 'login',
      'data': {
        'token': chatToken,
      },
    };
    _socket!.emit('event', loginData); // 发送登录请求
  }

  void _onMessageReceived(data) {
    // 处理接收到的消息
  }

  void _onError(data) {
    // 处理错误
  }

  void _onDone() {
    // 处理连接关闭
  }

  void send(String message) {
    _socket?.emit('message', message);
  }

  void close() {
    _socket?.disconnect();
  }
}
