class UserPromoteRecord {
  final String nickname; // 邀請碼
  final String createdAt; // 連結
  final List<String> roles;

  UserPromoteRecord(this.nickname, this.createdAt, this.roles );

  factory UserPromoteRecord.fromJson(Map<String, dynamic> json) {
      return UserPromoteRecord(
        json['nickname'],
        DateTime.parse(json['createdAt'] ?? '').add(const Duration(hours: 8)).toIso8601String(),
        List.from(
            (json['roles'] as List<dynamic>).map((e) => e.toString()).toList()),
      );
  }
}

class BlockUserPromoteRecord {
  final int total;
  final List<UserPromoteRecord> record;
  BlockUserPromoteRecord(this.record, this.total);
}