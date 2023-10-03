import '../utils/datetime_formatter.dart';

class Redemption {
  final String? name;
  final String? updatedAt;

  Redemption({this.name, this.updatedAt});

  factory Redemption.fromJson(Map<String, dynamic> json) {
    return Redemption(
      name: json['name'],
      updatedAt: formatDateTime(json['updatedAt']),
    );
  }
}
