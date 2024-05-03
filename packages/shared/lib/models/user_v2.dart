class UserV2 {
  final int uid;
  final List<String> roles;
  final String nickname;
  final String? avatar;
  final DateTime? vipExpiredAt;
  late final double points;
  final bool isFree;

  UserV2({
    required this.uid,
    required this.roles,
    required this.nickname,
    this.avatar,
    this.vipExpiredAt,
    required this.points,
    required this.isFree,
  });

  factory UserV2.fromJson(Map<String, dynamic> json) {
    return UserV2(
      uid: json['uid'],
      roles: List<String>.from(json['roles']),
      nickname: json['nickname'],
      avatar: json['avatar'],
      vipExpiredAt: json['vipExpiredAt'] != null
          ? DateTime.parse(json['vipExpiredAt'])
          : null,
      points: double.parse(json['points']),
      isFree: json['isFree'],
    );
  }
}
