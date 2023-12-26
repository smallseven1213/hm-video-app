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
  final int isPorn;
  final int chargeType; // 1: 免費 2: 一次性 3: 每n分鐘
  final String chargeAmount;
  final String? reserveAt; // 預約開播時間
  final int hid; // 主播id
  final String hostEnter; // 主播建立時間
  final String nickname; // 主播暱稱
  final int userLive; // 當前場次實際人數
  final double userCost; // 當前場次收益

  Room({
    required this.pid,
    required this.title,
    required this.tags,
    required this.status,
    required this.isPorn,
    required this.chargeType,
    required this.chargeAmount,
    this.playerCover,
    this.reserveAt,
    required this.hid,
    required this.hostEnter,
    required this.nickname,
    required this.userLive,
    required this.userCost,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    var tagsList = json['tags'] as List;
    List<Tag> tags = tagsList.map((i) => Tag.fromJson(i)).toList();
    return Room(
      pid: json['pid'],
      title: json['title'],
      tags: tags,
      playerCover: json['player_cover'] ?? '',
      status: json['status'],
      isPorn: json['is_porn'],
      chargeType: json['charge_type'],
      chargeAmount: json['charge_amount'],
      reserveAt: json['reserve_at'],
      hid: json['hid'],
      hostEnter: json['hostenter'],
      nickname: json['nickname'],
      userLive: json['userlive'],
      userCost: json['usercost'],
    );
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
