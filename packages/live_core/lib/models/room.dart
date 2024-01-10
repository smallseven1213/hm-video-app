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
  final String chargeAmount;
  final int chargeType; // 1: 免費 2: 一次性 3: 每n分鐘
  final String hostEnter; // 主播建立時間
  final int id;
  final String nickname; // 主播暱稱
  final String? playerCover; // 播放器封面
  final String? reserveAt; // 預約開播時間
  final int status; // 1: 未開始 2: 直播中 3: 已結束
  final int streamerId; // 主播id
  final List<Tag> tags;
  final String title;
  final String userCost; // 當前場次收益
  final int userLive; // 當前場次實際人數

  Room({
    required this.chargeAmount,
    required this.chargeType,
    required this.hostEnter,
    required this.id,
    required this.nickname,
    this.playerCover,
    this.reserveAt,
    required this.status,
    required this.streamerId,
    required this.tags,
    required this.title,
    required this.userCost,
    required this.userLive,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    try {
      var tagsList = json['tags'] as List;
      List<Tag> tags = tagsList.map((i) => Tag.fromJson(i)).toList();
      return Room(
        chargeAmount: getField<String>(json, 'charge_amount', defaultValue: ''),
        chargeType: getField<int>(json, 'charge_type', defaultValue: 0),
        hostEnter:
            getField<String>(json['streamer'], 'created_at', defaultValue: ''),
        id: getField<int>(json, 'id', defaultValue: 0),
        nickname:
            getField<String>(json['streamer'], 'nickname', defaultValue: ''),
        playerCover: getField<String>(json['streamer'], 'avatar',
            defaultValue: ''), // 暫時拿主播頭像當封面
        reserveAt: getField<String>(json, 'reserve_at', defaultValue: ''),
        status: getField<int>(json, 'status', defaultValue: 0),
        streamerId: getField<int>(json['streamer'], 'id', defaultValue: 0),
        tags: tags,
        title: getField<String>(json, 'title', defaultValue: ''),
        userCost: getField<String>(json['statistic'], 'total_income',
            defaultValue: ''),
        userLive:
            getField<int>(json['statistic'], 'watch_count', defaultValue: 0),
      );
    } catch (e) {
      print(e);
      return Room(
        id: 0,
        title: '',
        tags: [],
        playerCover: '',
        status: 0,
        chargeType: 0,
        chargeAmount: '0',
        reserveAt: '',
        streamerId: 0,
        hostEnter: '',
        nickname: '',
        userLive: 0,
        userCost: '',
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
