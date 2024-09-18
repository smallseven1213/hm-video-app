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
  final int userUid;
  final String userName;
  final String userAvatar;
  final String content;

  Comment({
    required this.id,
    required this.topicType,
    required this.topicId,
    required this.userUid,
    required this.userName,
    required this.userAvatar,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      topicType: json['topic_type'] ?? 0,
      topicId: json['topic_id'] ?? 0,
      userUid: json['user_uid'] ?? 0,
      userName: json['user_name'] ?? '',
      userAvatar: json['user_avatar'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic_type': topicType,
      'topic_id': topicId,
      'user_uid': userUid,
      'user_name': userName,
      'user_avatar': userAvatar,
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
