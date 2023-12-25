class ChatMessage {
  final int timestamp;
  final ChatUser objChat;

  ChatMessage({required this.timestamp, required this.objChat});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      timestamp: json['timestamp'],
      objChat: ChatUser.fromJson(json['objChat']),
    );
  }
}

class ChatUser {
  final String uid;
  final String name;
  final MessageType ntype;
  final String data;
  final String avatar;

  ChatUser({
    required this.uid,
    required this.name,
    required this.ntype,
    required this.data,
    this.avatar = '',
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      uid: json['uid'],
      name: json['name'],
      ntype: _mapNtypeToMessageType(json['ntype']),
      data: json['data'],
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
}

enum MessageType {
  system, // 系統訊息
  text, // 文字訊息
  image, // 圖檔
  gift, // 禮物
  command, // 指令
  auction // 競標
}
