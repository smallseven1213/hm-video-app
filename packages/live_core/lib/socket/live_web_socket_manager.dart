import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:convert';

class LiveSocketIOManager {
  static final LiveSocketIOManager _instance = LiveSocketIOManager._internal();
  io.Socket? _socket;
  io.Socket? get socket => _socket;
  String chatToken = '';

  final _messageController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get messages => _messageController.stream;

  factory LiveSocketIOManager() {
    return _instance;
  }

  LiveSocketIOManager._internal() {
    print("LiveSocketIOManager singleton instance created");
    // 初始化操作
  }

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

    // on 'loginresult
    _socket!.on('loginresult', (data) {
      // 解析 JSON 字符串
      var decodedData = jsonDecode(data);

      // 提取 'code' 和 'token' 值
      var code = decodedData['code'];
      var token = decodedData['token'];
      this.chatToken = token;

      print('Code: $code, Token: $token');
    });

    _socket!.on('chatresult', (data) {
      // // 解析 JSON 字符串
      // var decodedData = jsonDecode(data);

      // // 提取 'code' 和 'token' 值
      // var code = decodedData['code'];
      // var token = decodedData['token'];
      // this.chatToken = token;

      print(data);
    });

    _socket!.onError((data) {
      _onError(data);
    });

    _socket!.onDisconnect((_) => _onDone());

    _socket!.connect();
  }

  void _login(String chatToken) {
    var loginData = {
      'token': chatToken,
    };
    var dataString = jsonEncode(loginData);
    _socket!.emit('login', dataString); // 发送登录请求
  }

  void _onMessageReceived(data) {
    // 处理接收到的消息
    print('IO-Message received: $data');
    _messageController.add(data); // Broadcast the message
  }

  void _onError(data) {
    // 处理错误
    print('IO-Error: $data');
  }

  void _onDone() {
    // 处理连接关闭
    print('IO-Connection closed');
  }

  void send(String key, dynamic message) {
    message['token'] = chatToken;
    String jsonData = jsonEncode(message);
    _socket?.emit(key, jsonData);
  }

  void close() {
    // _socket?.disconnect();
    _messageController.close();
    _socket?.close();
  }
}
