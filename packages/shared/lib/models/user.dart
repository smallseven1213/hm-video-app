class User {
  final String id;
  final int uid;
  final List<String> roles;
  final String? username;
  final String? phoneNumber;
  final dynamic agentId;
  final dynamic superiorId;
  String? nickname;
  String? avatar;
  final String? invitationCode;
  final String? vipExpiredAt;
  final String? points;
  final String? usedPoints;
  final int? broughtTimes;
  final String? depositedAmount;
  final String? lastLoginAt;
  final String? registerDeviceType;
  final String? registerDeviceGuid;
  final String? registerIp;
  final String? remark;
  final bool? isFree;

  User(
    this.id,
    this.uid,
    this.roles, {
    this.username,
    this.phoneNumber,
    this.agentId,
    this.superiorId,
    this.nickname,
    this.avatar,
    this.invitationCode,
    this.vipExpiredAt,
    this.points,
    this.usedPoints,
    this.broughtTimes,
    this.depositedAmount,
    this.lastLoginAt,
    this.registerDeviceType,
    this.registerDeviceGuid,
    this.registerIp,
    this.remark,
    this.isFree,
  });

  bool isGuest() {
    return roles.contains('guest');
  }

  bool isVip() {
    return vipExpiredAt == null
        ? false
        : (DateTime.parse(vipExpiredAt ?? DateTime.now().toIso8601String())
                .difference(DateTime.now())
                .inSeconds >
            0);
  }

  bool isForeverFree() {
    return isFree == true;
  }

  DateTime? getVipExpiredAt() {
    return vipExpiredAt == null ? null : DateTime.parse(vipExpiredAt ?? '');
  }

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        json['id'],
        json['uid'],
        List.from(
            (json['roles'] as List<dynamic>).map((e) => e.toString()).toList()),
        username: json['username'],
        phoneNumber: json['phoneNumber'],
        agentId: json['agentId'],
        superiorId: json['superiorId'],
        nickname: json['nickname'],
        avatar: json['avatar'],
        invitationCode: json['invitationCode'],
        vipExpiredAt: json['vipExpiredAt'] == null
            ? null
            : DateTime.parse(json['vipExpiredAt'] ?? '')
                .add(const Duration(hours: 8))
                .toIso8601String(),
        points: json['points'],
        usedPoints: json['usedPoints'],
        broughtTimes: json['broughtTimes'],
        depositedAmount: json['depositedAmount'],
        lastLoginAt: json['lastLoginAt'],
        registerDeviceType: json['registerDeviceType'],
        registerDeviceGuid: json['registerDeviceGuid'],
        registerIp: json['registerIp'],
        remark: json['remark'],
        isFree: json['isFree'],
      );
    } catch (e) {
      return User('', 0, ['guest']);
    }
  }
}
