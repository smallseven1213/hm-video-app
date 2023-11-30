class Room {
  final int pid;
  final String title;
  final List<Tag> tags;
  final int status;
  final int isPorn;
  final int chargeType;
  final String chargeAmount;
  final String? reserveAt;
  final int hid;
  final String hostenter;
  final String nickname;
  final int userlive;
  final int usercost;

  Room({
    required this.pid,
    required this.title,
    required this.tags,
    required this.status,
    required this.isPorn,
    required this.chargeType,
    required this.chargeAmount,
    this.reserveAt,
    required this.hid,
    required this.hostenter,
    required this.nickname,
    required this.userlive,
    required this.usercost,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    var tagsList = json['tags'] as List;
    List<Tag> tags = tagsList.map((i) => Tag.fromJson(i)).toList();
    return Room(
      pid: json['pid'],
      title: json['title'],
      tags: tags,
      status: json['status'],
      isPorn: json['is_porn'],
      chargeType: json['charge_type'],
      chargeAmount: json['charge_amount'],
      reserveAt: json['reserve_at'],
      hid: json['hid'],
      hostenter: json['hostenter'],
      nickname: json['nickname'],
      userlive: json['userlive'],
      usercost: json['usercost'],
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
