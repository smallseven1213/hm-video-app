class UserPointRecord {
  final String? createdAt;
  final String? name;
  final String? changedPoints;
  final String? usedPoints;

  UserPointRecord(
      {this.createdAt, this.name, this.changedPoints, this.usedPoints});

  factory UserPointRecord.fromJson(Map<String, dynamic> json) {
    try {
      return UserPointRecord(
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] ?? '').add(const Duration(hours: 8)).toIso8601String(),
        name: json['video'] == null ? '' : (json['video']['title'] ?? ''),
        changedPoints: json['changedPoints'],
        usedPoints: json['usedPoints'],
      );
    } catch (e) {
      print(e);
      return UserPointRecord();
    }
  }
}
