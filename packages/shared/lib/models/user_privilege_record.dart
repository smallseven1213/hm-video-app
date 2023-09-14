import '../utils/datetime_formatter.dart';

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
      DateTime? previous = formatTimeWithTimeZone(json['previousExpiredAt']);
      DateTime? expires = formatTimeWithTimeZone(json['expiredAt']);
      DateTime now = DateTime.now();
      bool isAvailable = true;
      if (previous != null && expires != null) {
        isAvailable = now.isAfter(previous) && now.isBefore(expires);
      }

      return UserPrivilegeRecord(
        createdAt: formatDateTime(json['previousExpiredAt']),
        name: json['typeName'],
        remark: json['remark'],
        vipExpiredAt: formatDateTime(json['expiredAt']),
        isAvailable: isAvailable,
      );
    } catch (e) {
      print(e);
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
