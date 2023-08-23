import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../controllers/short_video_detail_controller.dart';

final logger = Logger();

class ShortVideoProvider extends StatefulWidget {
  final int vodId;
  final Widget child;
  final Widget? loading;
  final String tag;

  const ShortVideoProvider({
    Key? key,
    required this.child,
    required this.vodId,
    required this.tag,
    this.loading,
  }) : super(key: key);

  @override
  ShortVideoProviderState createState() => ShortVideoProviderState();
}

class ShortVideoProviderState extends State<ShortVideoProvider> {
  late final ShortVideoDetailController controller;

  @override
  void initState() {
    super.initState();

    controller =
        Get.put(ShortVideoDetailController(widget.vodId), tag: widget.tag);
  }

  @override
  void dispose() {
    if (Get.isRegistered<ShortVideoDetailController>(tag: widget.tag)) {
      try {
        Get.delete(tag: widget.tag);
      } catch (e) {
        logger.e(e);
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
