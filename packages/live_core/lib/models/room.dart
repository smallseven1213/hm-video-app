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
  final double userCost; // 當前場次收益
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
        chargeAmount: json['charge_amount'],
        chargeType: json['charge_type'],
        hostEnter: json['streamer']['created_at'],
        id: json['id'],
        nickname: json['streamer']['nickname'],
        playerCover: json['streamer']['avatar'], // 暫時拿主播頭像當封面
        reserveAt: json['reserve_at'],
        status: json['status'],
        streamerId: json['streamer']['id'],
        tags: tags,
        title: json['title'],
        userCost: double.parse(json['statistic']['total_income']),
        userLive: json['statistic']['watch_count'],
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
        userCost: 0,
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
