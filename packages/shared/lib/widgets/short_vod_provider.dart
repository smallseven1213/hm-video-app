import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/short_video_detail_controller.dart';
import '../utils/controller_tag_genarator.dart';

class ShortVodProvider extends StatelessWidget {
  final int vodId;
  final Widget child;

  const ShortVodProvider({Key? key, required this.child, required this.vodId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ShortVideoDetailController>(
        () => ShortVideoDetailController(vodId),
        tag: genaratorShortVideoDetailTag(vodId.toString()));
    return child;
  }
}
