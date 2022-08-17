class Event {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  Event(
    this.id,
    this.title,
    this.content,
    this.createdAt,
  );

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      json['id'],
      json['title'],
      json['content'],
      DateTime.parse(json['createdAt'] ?? '').add(const Duration(hours: 8)).toIso8601String()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
