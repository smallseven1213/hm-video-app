import 'dart:convert';

class ChatMessage<T> {
  final int timestamp;
  final ChatMessageObjChat<T> objChat;

  ChatMessage({required this.timestamp, required this.objChat});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      timestamp: json['timestamp'],
      objChat: ChatMessageObjChat<T>.fromJson(json['objChat']),
    );
  }
}

class ChatMessageObjChat<T> {
  final String uid;
  final String name;
  final MessageType ntype;
  final T data;
  final String avatar;

  ChatMessageObjChat({
    required this.uid,
    required this.name,
    required this.ntype,
    required this.data,
    this.avatar = '',
  });

  factory ChatMessageObjChat.fromJson(Map<String, dynamic> json) {
    return ChatMessageObjChat(
      uid: json['uid'],
      name: json['name'],
      ntype: _mapNtypeToMessageType(json['ntype']),
      data: _mapDataToType<T>(json['data']),
      avatar: json['avatar'],
    );
  }

  static MessageType _mapNtypeToMessageType(int ntype) {
    switch (ntype) {
      case 0:
        return MessageType.system;
      case 1:
        return MessageType.text;
      case 2:
        return MessageType.image;
      case 3:
        return MessageType.gift;
      case 4:
        return MessageType.command;
      case 5:
        return MessageType.auction;
      default:
        throw Exception('Unknown ntype: $ntype');
    }
  }

  static T _mapDataToType<T>(dynamic data) {
    if (T == ChatGiftMessageObjChatData) {
      // data是String要轉成json
      var jsonData = data is String ? jsonDecode(data) : data;
      return ChatGiftMessageObjChatData.fromJson(jsonData) as T;
    } else if (T == ChatMessageObjChatData) {
      var jsonData = data is String ? jsonDecode(data) : data;
      return ChatMessageObjChatData.fromJson(jsonData) as T;
    } else {
      return data as T;
    }
  }
}

enum MessageType {
  system, // 系統訊息
  text, // 文字訊息
  image, // 圖檔
  gift, // 禮物
  command, // 指令
  auction // 競標
}

class ChatGiftMessageObjChatData {
  final int gid;
  final int animationLayout;
  final int quantity;
  int? currentQuantity;

  ChatGiftMessageObjChatData({
    required this.gid,
    required this.animationLayout,
    required this.quantity,
  });

  factory ChatGiftMessageObjChatData.fromJson(Map<String, dynamic> json) {
    return ChatGiftMessageObjChatData(
      gid: json['gid'] ?? 0,
      animationLayout: json['animation_layout'] ?? 2,
      quantity: json['quantity'] ?? 0,
    );
  }
}

class ChatMessageObjChatData {
  final String src;
  final String trans;

  ChatMessageObjChatData({
    required this.src,
    required this.trans,
  });

  factory ChatMessageObjChatData.fromJson(Map<String, dynamic> json) {
    return ChatMessageObjChatData(
      src: json['src'] ?? "",
      trans: json['trans'] ?? "",
    );
  }
}
