class LiveUserDetail {
  String account;
  String avatar;
  DateTime createdAt;
  int device;
  int id;
  bool isActive;
  DateTime loggedAt;
  String loggedIp;
  String nickname;
  String registerIp;
  String remark;
  int siteId;
  double tradingAmount;
  int tradingCount;
  int viewingTimes;
  double wallet;

  LiveUserDetail({
    required this.account,
    required this.avatar,
    required this.createdAt,
    required this.device,
    required this.id,
    required this.isActive,
    required this.loggedAt,
    required this.loggedIp,
    required this.nickname,
    required this.registerIp,
    required this.remark,
    required this.siteId,
    required this.tradingAmount,
    required this.tradingCount,
    required this.viewingTimes,
    required this.wallet,
  });

  factory LiveUserDetail.fromJson(Map<String, dynamic> json) {
    try {
      return LiveUserDetail(
        account: json['account'],
        avatar: json['avatar'] ?? '',
        createdAt: DateTime.parse(json['created_at']),
        device: json['device'],
        id: json['id'],
        isActive: json['is_active'] == 1,
        loggedAt: DateTime.parse(json['logged_at']),
        loggedIp: json['logged_ip'],
        nickname: json['nickname'],
        registerIp: json['register_ip'],
        remark: json['remark'] ?? '',
        siteId: json['site_id'],
        tradingAmount: double.parse(json['trading_amount']),
        tradingCount: json['trading_count'],
        viewingTimes: json['viewing_times'],
        wallet: double.parse(json['wallet']),
      );
    } catch (e) {
      print('LiveUserDetail.fromJson: $e');
      rethrow;
    }
  }
}
