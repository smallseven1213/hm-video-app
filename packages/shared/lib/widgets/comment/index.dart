import 'package:flutter/material.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/modules/comment/comment_consumer.dart';
import 'package:shared/widgets/comment/input.dart';
import 'package:shared/widgets/comment/list.dart';
import 'package:shared/widgets/comment/no_data.dart';


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

class _CommentSectionState extends State<CommentSection> {
  bool _isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    // Comment list widget
    Widget commentListWidget = CommentConsumer(
      topicId: 1,
      topicType: widget.topicType.index,
      child: (List<Comment> comments) {
        return Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              '評論',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            comments.isEmpty
                ? NoDataWidget()
                : Column(
                    children: comments
                        .map((comment) => CommentItem(item: comment))
                        .toList(),
                  ),
            const SizedBox(height: 8),
          ],
        );
      },
    );

    return GestureDetector(
      onTap: () {
        // Hide the keyboard when the user taps outside the TextField
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          // Comment List
          widget.isScrollable
              ? Expanded(
                  child: SingleChildScrollView(
                    child: commentListWidget,
                  ),
                )
              : commentListWidget,
          // Comment Input
          CommentInput(
            onSend: (String text) {
              // Handle send action
              // TODO: Implement comment sending logic
              setState(() {
                // Update state if needed
              });
            },
            onFocusChange: (bool hasFocus) {
              setState(() {
                _isKeyboardVisible = hasFocus;
              });
            },
          ),
        ],
      ),
    );
  }
}
