import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/comment.dart';
import '../../controllers/comment_controller.dart';

class CommentConsumer extends StatefulWidget {
  final Widget Function(
    List<Comment>,
  ) child;
  final int topicId;
  final int topicType;

  const CommentConsumer({
    Key? key,
    required this.child,
    required this.topicId,
    required this.topicType,
  }) : super(key: key);

  @override
  CommentConsumerState createState() => CommentConsumerState();
}

class CommentConsumerState extends State<CommentConsumer> {
  late CommentController commentController;

  @override
  void initState() {
    super.initState();
    commentController =
        Get.find<CommentController>(tag: 'comment-${widget.topicId}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (commentController.isLoading.value) {
        return const SizedBox.shrink();
      }
      return widget.child(
        commentController.comments,
      );
    });
  }
}
