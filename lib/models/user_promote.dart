class UserPromote {
  final String invitationCode; // 邀請碼
  final String promoteLink; // 連結
  final int promotedMembers; // 已推廣人數
  final int changed; // 免費看天數

  UserPromote(this.invitationCode, this.promoteLink, this.promotedMembers, this.changed );

  factory UserPromote.fromJson(Map<String, dynamic> json) {
      return UserPromote(
        json['invitationCode'],
        json['promoteLink'],
        json['promotedMembers'],
        json['changed'],
      );
  }
}
