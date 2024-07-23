import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/post_controller.dart';

class PostsProvider extends StatelessWidget {
  final int postId;
  final Widget Function(PostController controller) child;
  final Widget? loadingWidget;

  const PostsProvider({
    Key? key,
    required this.postId,
    required this.child,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 檢查是否已存在具有特定標籤的控制器
    if (!Get.isRegistered<PostController>(tag: '$postId')) {
      // 如果不存在，則放置控制器
      Get.put(
        PostController(),
        tag: '$postId',
      );
    }

    return Obx(() {
      var postController = Get.find<PostController>(tag: '$postId');
      return postController.isLoading.value
          ? loadingWidget!
          : child(postController);
    });
  }
}
