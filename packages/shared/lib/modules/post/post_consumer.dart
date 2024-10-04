import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controller.dart';
import '../../models/post_detail.dart';

class PostConsumer extends StatefulWidget {
  final Widget Function(PostDetail?, {bool? isError}) child;
  final int id;
  final Widget loadingAnimation;
  const PostConsumer({
    Key? key,
    required this.child,
    required this.id,
    required this.loadingAnimation,
  }) : super(key: key);

  @override
  PostConsumerState createState() => PostConsumerState();
}

class PostConsumerState extends State<PostConsumer> {
  late PostController postController;

  @override
  void initState() {
    super.initState();
    Get.delete<PostController>(tag: 'postId-${widget.id}');
    postController =
        Get.put(PostController(postId: widget.id), tag: 'postId-${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      PostDetail? post = postController.postDetail.value;
      if (postController.isLoading.value) {
        return Center(
          child: widget.loadingAnimation,
        );
      }
      return widget.child(post, isError: postController.isError.value);
    });
  }
}
