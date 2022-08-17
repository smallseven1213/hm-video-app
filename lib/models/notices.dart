class Notice {
  final int id;
  final String title;
  final int? type;
  final String? content;
  final String? leftButton;
  final String? leftButtonUrl;
  final String? rightButton;
  final String? rightButtonUrl;
  final String? startedAt;
  final String? endedAt;
  // bool marquee;
  // bool bounce;

  Notice(
    this.id,
    this.title, {
    this.type,
    this.content,
    this.leftButton,
    this.leftButtonUrl,
    this.rightButton,
    this.rightButtonUrl,
    this.startedAt,
    this.endedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      json['id'],
      json['title'],
      content: json['content'],
      leftButton: json['leftButton'],
      leftButtonUrl: json['leftButtonUrl'],
      rightButton: json['rightButton'],
      rightButtonUrl: json['rightButtonUrl'],
      startedAt: json['startedAt'] == null ? null : DateTime.parse(json['startedAt'] ?? '').add(const Duration(hours: 8)).toIso8601String(),
      endedAt: json['endedAt'],
    );
  }
}
