enum TopicType {
  none,
  video,
  shortVideo,
  post,
  comic,
}

class Comment {
  final int id;
  final int topicType;
  final int topicId;
  final int uid;
  final String userName;
  final String avatar;
  final String content;

  Comment({
    required this.id,
    required this.topicType,
    required this.topicId,
    required this.uid,
    required this.userName,
    required this.avatar,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      topicType: json['topicType'] ?? 0,
      topicId: json['topicId'] ?? 0,
      uid: json['uid'] ?? 0,
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicType': topicType,
      'topicId': topicId,
      'uid': uid,
      'userName': userName,
      'avatar': avatar,
      'content': content,
    };
  }
}

class InfinityComments {
  final List<Comment> comments;
  final int total;
  final bool hasMore;

  InfinityComments(this.comments, this.total, this.hasMore);
}

class Report {
  final String title;
  final List<String> options;

  Report({required this.title, required this.options});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      title: json['title'] ?? '',
      options:
          json['options'] != null ? List<String>.from(json['options']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
