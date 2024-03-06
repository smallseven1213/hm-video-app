import '../utils/datetime_formatter.dart';

class UserPurchaseRecord {
  final String? createdAt;
  final String? name;
  final String? changedPoints;
  final String? usedPoints;

  UserPurchaseRecord(
      {this.createdAt, this.name, this.changedPoints, this.usedPoints});

  factory UserPurchaseRecord.fromJson(Map<String, dynamic> json) {
    try {
      return UserPurchaseRecord(
        createdAt: formatDateTime(json['createdAt']),
        name: json['video'] == null ? '' : (json['video']['title'] ?? ''),
        changedPoints: json['changedPoints'],
        usedPoints: json['usedPoints'],
      );
    } catch (e) {
      return UserPurchaseRecord();
    }
  }
}
