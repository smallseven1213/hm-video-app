import 'package:flutter/material.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/widgets/comment/comment_section_base.dart';
import 'package:shared/widgets/comment/list.dart';

class CommentSection extends StatefulWidget {
  final int topicId;
  final TopicType topicType;
  final bool isScrollable;

  const CommentSection({
    Key? key,
    required this.topicId,
    required this.topicType,
    this.isScrollable = false,
  }) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends CommentSectionBase<CommentSection> {
  @override
  int get topicId => widget.topicId;

  @override
  int get topicType => widget.topicType.index;

  @override
  bool get showNoMoreComments => true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          widget.isScrollable
              ? Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: buildCommentList(),
                  ),
                )
              : buildCommentList(),
          buildCommentInput(),
        ],
      ),
    );
  }
}
