class Redemption {
  final String? name;
  final String? updatedAt;

  Redemption({this.name, this.updatedAt});

  factory Redemption.fromJson(Map<String, dynamic> json) {
    return Redemption(
      name: json['name'],
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] ?? '').add(const Duration(hours: 8)).toIso8601String()
    );
  }
}
