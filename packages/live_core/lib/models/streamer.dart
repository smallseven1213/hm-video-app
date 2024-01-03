class Streamer {
  final int id;
  final String nickname;
  final String? avatar;
  final String? createdAt;
  final int? fansCount;
  final String? account;

  Streamer({
    required this.id,
    required this.nickname,
    this.avatar,
    this.createdAt,
    this.fansCount,
    this.account,
  });

  factory Streamer.fromJson(Map<String, dynamic> json) {
    return Streamer(
      id: json['id'],
      nickname: json['nickname'],
      avatar: json['avatar'],
      createdAt: json['created_at'],
      fansCount: json['fans_count'],
      account: json['account'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account,
      'nickname': nickname,
      'avatar': avatar,
      'created_at': createdAt,
      'fans_count': fansCount,
    };
  }
}
