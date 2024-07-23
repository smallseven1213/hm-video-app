import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/banner_controller.dart';
import '../../models/banner_photo.dart';
import '../../models/supplier.dart';

final Map<String, dynamic> post = {
  "id": 3,
  "avatarSid": "avatar32",
  "supplier": Supplier(
    id: 6,
    aliasName: "\u912d\u8208A",
    name: "\u912d\u8208A",
    photoSid: "ebce8cec-765a-4536-afc8-f1e10ec18854",
    coverVertical: null,
    collectTotal: null,
    followTotal: null,
  ),
  "upName": "Creator C",
  "postContent": "Here's a third post, but this time from Creator B.",
  "article": {
    "title": 'Article Title',
    "content": 'Article Content',
    "photos": [
      BannerPhoto(
        id: 1,
        url: 'https://picsum.photos/250?image=9',
      ),
      BannerPhoto(
        id: 2,
        url: 'https://picsum.photos/250?image=10',
      ),
      BannerPhoto(
        id: 3,
        url: 'https://picsum.photos/250?image=11',
      ),
    ],
  }
};

class PostConsumer extends StatefulWidget {
  final Widget Function(Map) child;
  const PostConsumer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  PostConsumerState createState() => PostConsumerState();
}

class PostConsumerState extends State<PostConsumer> {
  final BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    // bannerController.fetchBanner(widget.position);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(post);

    // return Obx(() {
    //   var banners = bannerController.banners[widget.position];
    //   if (banners == null || banners.isEmpty) {
    //     return const SizedBox.shrink();
    //   }

    //   return widget.child(post);
    // });
  }
}
