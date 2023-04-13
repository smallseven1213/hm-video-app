class Event {
  late int id;
  late String title;
  late String content;
  late String createdAt;

  Event(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['createdAt'] = createdAt;
    return data;
  }
}
