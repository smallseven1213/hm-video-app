import 'package:shared/helpers/getField.dart';

enum RoomStatus {
  none,
  notStarted,
  live,
  ended,
}

enum RoomChargeType {
  none,
  free,
  oneTime,
  perMinute,
}

class Room {
  final int pid;
  final String title;
  final List<Tag> tags;
  final String? playerCover; // 播放器封面
  final int status; // 1: 未開始 2: 直播中 3: 已結束
  final int chargeType; // 1: 免費 2: 一次性 3: 每n分鐘
  final double chargeAmount;
  final String? reserveAt; // 預約開播時間
  final int hid; // 主播id
  final String hostEnter; // 主播建立時間
  final String nickname; // 主播暱稱
  final int userLive; // 當前場次實際人數
  final double userCost; // 當前場次收益
  final int fans;

  Room({
    required this.pid,
    required this.title,
    required this.tags,
    required this.status,
    required this.chargeType,
    required this.chargeAmount,
    this.playerCover,
    this.reserveAt,
    required this.hid,
    required this.hostEnter,
    required this.nickname,
    required this.userLive,
    required this.userCost,
    required this.fans,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    var tagsList = json['tags'] as List;
    List<Tag> tags = tagsList.map((i) => Tag.fromJson(i)).toList();
    var changeAmount = double.parse(json['charge_amount']);
    try {
      return Room(
        pid: getField<int>(json, 'pid', defaultValue: 0),
        title: getField<String>(json, 'title', defaultValue: ''),
        tags: tags,
        playerCover: getField<String>(json, 'player_cover', defaultValue: ''),
        status: getField<int>(json, 'status', defaultValue: 0),
        chargeType: getField<int>(json, 'charge_type', defaultValue: 0),
        chargeAmount: changeAmount,
        reserveAt: getField<String>(json, 'reserve_at', defaultValue: ''),
        hid: getField<int>(json, 'hid', defaultValue: 0),
        hostEnter: getField<String>(json, 'hostenter', defaultValue: ''),
        nickname: getField<String>(json, 'nickname', defaultValue: ''),
        userLive: getField<int>(json, 'userlive', defaultValue: 0),
        userCost: getField<double>(json, 'usercost', defaultValue: 0),
        fans: getField<int>(json, 'fans', defaultValue: 0),
        // pid: json['pid'],
        // title: json['title'],
        // tags: tags,
        // playerCover: json['player_cover'] ?? '',
        // status: json['status'] as int,
        // chargeType: json['charge_type'],
        // chargeAmount: json['charge_amount'],
        // reserveAt: json['reserve_at'],
        // hid: json['hid'],
        // hostEnter: json['hostenter'],
        // nickname: json['nickname'],
        // userLive: json['userlive'],
        // userCost: json['usercost'],
        // fans: json['fans'],
      );
    } catch (e) {
      print(e);
      return Room(
        pid: 0,
        title: '',
        tags: [],
        playerCover: '',
        status: 0,
        chargeType: 0,
        chargeAmount: 0,
        reserveAt: '',
        hid: 0,
        hostEnter: '',
        nickname: '',
        userLive: 0,
        userCost: 0,
        fans: 0,
      );
    }
  }
}

class Tag {
  final String id;
  final String name;

  Tag({required this.id, required this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
    );
  }
}
