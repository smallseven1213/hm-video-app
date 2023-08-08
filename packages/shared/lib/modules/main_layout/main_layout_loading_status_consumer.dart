import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/layout_controller.dart';

class MainLayoutLoadingStatusConsumer extends StatefulWidget {
  final int layoutId;
  final Widget Function(bool isLoading) child;

  const MainLayoutLoadingStatusConsumer(
      {Key? key, required this.layoutId, required this.child})
      : super(key: key);

  @override
  MainLayoutLoadingStatusConsumerState createState() =>
      MainLayoutLoadingStatusConsumerState();
}

class MainLayoutLoadingStatusConsumerState
    extends State<MainLayoutLoadingStatusConsumer> {
  late LayoutController layoutController;

  @override
  void initState() {
    layoutController =
        Get.find<LayoutController>(tag: 'layout${widget.layoutId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(layoutController.isLoading.value));
  }
}
