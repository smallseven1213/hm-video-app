import 'package:flutter/material.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/widgets/comment/comment_section_base.dart';
import 'package:shared/widgets/ui_bottom_safearea.dart';

class CommentSection extends StatefulWidget {
  final int topicId;
  final TopicType topicType;
  final bool isScrollable;
  final bool autoFocusInput;

  const CommentSection({
    Key? key,
    required this.topicId,
    required this.topicType,
    this.isScrollable = false,
    this.autoFocusInput = false,
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

  // @override
  // bool get autoFocusInput => widget.autoFocusInput; // Return the value here

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Expanded(child: buildCommentList()),
          buildCommentInput(),
        ],
      ),
    );
  }
}
