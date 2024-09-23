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
        return ListView.builder(
          shrinkWrap: true, // 保證根據內容大小自適應
          physics: const NeverScrollableScrollPhysics(), // 禁止內部滾動，讓外部處理滾動
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return CommentItem(item: comments[index]);
          },
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  final Comment item;
  CommentItem({
    Key? key,
    required this.item,
  }) : super(key: ValueKey(item.id));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AvatarWidget(
        photoSid: item.avatar,
        width: 36,
        height: 36,
        backgroundColor: Colors.transparent,
      ),
      title: Row(
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              item.userName,
              style: const TextStyle(color: Colors.white, fontSize: 12),
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
      subtitle: Text(
        item.content,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
