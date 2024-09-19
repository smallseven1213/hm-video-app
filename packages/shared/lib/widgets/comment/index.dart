import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/comment_controller.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/widgets/comment/input.dart';
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

class _CommentSectionState extends State<CommentSection> {
  bool _isKeyboardVisible = false;
  late CommentController _commentController;

  @override
  void initState() {
    super.initState();
    // Register the CommentController here
    _commentController = Get.put(
      CommentController(
        topicId: widget.topicId,
        topicType: widget.topicType.index,
      ),
      tag: 'comment-${widget.topicId}',
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    if (Get.isRegistered<CommentController>(tag: 'comment-${widget.topicId}')) {
      Get.delete<CommentController>(tag: 'comment-${widget.topicId}');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Comment list widget
    Widget commentListWidget = CommentList(
      topicId: widget.topicId,
      topicType: widget.topicType,
    );
    // Modify the CommentInput widget
    return GestureDetector(
      onTap: () {
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
            onSend: (String text) async {
              await _commentController.createComment(text);
              // No need to setState or update the UI manually
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
