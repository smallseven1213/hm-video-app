import 'package:flutter/material.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/modules/comment/comment_consumer.dart';
import 'package:shared/widgets/avatar.dart';

import 'no_data.dart';

class CommentList extends StatelessWidget {
  final int topicId;
  final TopicType topicType;

  const CommentList({
    super.key,
    required this.topicId,
    required this.topicType,
  });

  @override
  Widget build(BuildContext context) {
    return CommentConsumer(
      topicId: topicId,
      topicType: topicType.index,
      child: (List<Comment> comments) {
        if (comments.isEmpty) {
          return const NoDataWidget();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return CommentItem(item: comments[index]);
            },
          ),
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  final Comment item;
  const CommentItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // minVerticalPadding: 2,
      leading: AvatarWidget(
        photoSid: item.userAvatar,
        width: 36,
        height: 36,
        backgroundColor: Colors.transparent,
      ),
      title: Row(
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.start, // 確保垂直居中對齊
        children: [
          Expanded(
            child: Text(
              item.userUid.toString(),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const Row(
            children: [
              Text('0', style: TextStyle(color: Colors.grey, fontSize: 11)),
              SizedBox(width: 4),
              Icon(Icons.favorite_border, color: Colors.grey, size: 13),
            ],
          ),
        ],
      ),
      subtitle: Text(item.content,
          style: const TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}
