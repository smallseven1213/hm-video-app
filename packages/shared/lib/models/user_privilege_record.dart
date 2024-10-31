class UserPrivilegeRecord {
  final String? createdAt;
  final String? name;
  final String? remark;
  final String? vipExpiredAt;
  final bool? isAvailable;

  UserPrivilegeRecord({
    this.createdAt,
    this.name,
    this.remark,
    this.vipExpiredAt,
    this.isAvailable,
  });

  factory UserPrivilegeRecord.fromJson(Map<String, dynamic> json) {
    try {
      DateTime? previous = json['previousExpiredAt'] != null
          ? DateTime.parse(json['previousExpiredAt'])
          : null;
      DateTime? expires =
          json['expiredAt'] != null ? DateTime.parse(json['expiredAt']) : null;
      DateTime now = DateTime.now();
      bool isAvailable = true;
      if (previous != null && expires != null) {
        isAvailable = now.isBefore(expires);
      }

      return UserPrivilegeRecord(
        createdAt: json['previousExpiredAt'],
        name: json['typeName'],
        remark: json['remark'],
        vipExpiredAt: json['expiredAt'],
        isAvailable: isAvailable,
      );
    } catch (e) {
      return UserPrivilegeRecord(
        createdAt: '',
        name: '',
        remark: '',
        vipExpiredAt: '',
        isAvailable: true,
      );
    }
  }
}
