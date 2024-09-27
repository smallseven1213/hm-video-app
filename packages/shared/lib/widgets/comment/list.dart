import 'package:flutter/material.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/modules/comment/comment_consumer.dart';
import 'package:shared/widgets/avatar.dart';

class CommentList extends StatelessWidget {
  final int topicId;
  final TopicType topicType;
  final bool showNoMoreComments;

  const CommentList({
    super.key,
    required this.topicId,
    required this.topicType,
    this.showNoMoreComments = false,
  });

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return CommentConsumer(
      topicId: topicId,
      topicType: topicType.index,
      child: (List<Comment> comments) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                localizations.translate('comment'),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentItem(item: comments[index]);
              },
            ),
            if (comments.length < 5 && showNoMoreComments)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  localizations.translate('nothing_more'),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CommentItem extends StatefulWidget {
  final Comment item;

  const CommentItem({Key? key, required this.item}) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isExpanded = false;
  bool showExpandButton = false;

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return ListTile(
      leading: AvatarWidget(
        photoSid: widget.item.avatar,
        width: 36,
        height: 36,
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        widget.item.userName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final span = TextSpan(
                text: widget.item.content,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              );
              final tp = TextPainter(
                text: span,
                maxLines: 5,
                textDirection: TextDirection.ltr,
              );
              tp.layout(maxWidth: constraints.maxWidth);

              if (tp.didExceedMaxLines) {
                showExpandButton = true;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.content,
                    maxLines: isExpanded ? null : 5,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  if (showExpandButton)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded
                            ? localizations.translate('collapse')
                            : localizations.translate('expand'),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
