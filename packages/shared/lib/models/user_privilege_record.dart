class UserPrivilegeRecord {
  final String? createdAt;
  final String? name;
  final String? remark;
  final String? vipExpiredAt;

  UserPrivilegeRecord({this.createdAt, this.name, this.remark, this.vipExpiredAt});

  factory UserPrivilegeRecord.fromJson(Map<String, dynamic> json) {
    try {
      return UserPrivilegeRecord(
        createdAt: json['previousExpiredAt'] == null
            ? null
            : DateTime.parse(json['previousExpiredAt'] ?? '')
                .add(const Duration(hours: 8))
                .toIso8601String(),
        name: json['typeName'],
        remark: json['remark'],
        vipExpiredAt: json['expiredAt'] == null
            ? null
            : DateTime.parse(json['expiredAt'] ?? '')
                .add(const Duration(hours: 8))
                .toIso8601String(),
      );
    } catch (e) {
      print(e);
      return UserPrivilegeRecord();
    }
  }
}
