import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/banner_controller.dart';
import '../../controllers/post_controller.dart';
import '../../models/banner_photo.dart';
import '../../models/post_detail.dart';
import '../../models/supplier.dart';

class PostConsumer extends StatefulWidget {
  final Widget Function(PostDetail?) child;
  final int id;
  const PostConsumer({
    Key? key,
    required this.child,
    required this.id,
  }) : super(key: key);

  @override
  PostConsumerState createState() => PostConsumerState();
}

class PostConsumerState extends State<PostConsumer> {
  late PostController postController;

  @override
  void initState() {
    super.initState();
    postController =
        Get.put(PostController(postId: widget.id), tag: 'postId-${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    // return widget.child(post);

    return Obx(() {
      PostDetail? post = postController.postDetail;

      return widget.child(post);
    });
  }
}
