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
      topicType: json['topicType'] ?? 0,
      topicId: json['topicId'] ?? 0,
      userUid: json['userUid'] ?? 0,
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicType': topicType,
      'topicId': topicId,
      'userUid': userUid,
      'userName': userName,
      'userAvatar': userAvatar,
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
