import 'dart:async';

class EventBus {
  final _controller = StreamController<String>.broadcast();
  String? _lastEvent;

  void fireEvent(String key) {
    _lastEvent = key;
    _controller.sink.add(key);
  }

  Stream<String> get onEvent => _controller.stream;

  // 新增方法：主動獲取最後一次的事件
  String? getLatestEvent() {
    final lastEvent = _lastEvent;
    _lastEvent = null; // 獲取後清空，根據需求調整這個行為
    return lastEvent;
  }

  void dispose() {
    _controller.close();
  }
}

// 創建全局的EventBus實例
final eventBus = EventBus();
