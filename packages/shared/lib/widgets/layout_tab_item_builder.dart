import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';

final logger = Logger();

class LayoutTabBarItemBuilder extends StatefulWidget {
  final int layoutId;
  final int index;
  final String name;
  final Function({required bool isActive}) itemWidget;

  const LayoutTabBarItemBuilder({
    Key? key,
    required this.layoutId,
    required this.index,
    required this.name,
    required this.itemWidget,
  }) : super(key: key);

  @override
  LayoutTabBarItemBuilderState createState() => LayoutTabBarItemBuilderState();
}

class LayoutTabBarItemBuilderState extends State<LayoutTabBarItemBuilder> {
  late ChannelScreenTabController channelScreenTabController;

  @override
  void initState() {
    super.initState();
    channelScreenTabController = Get.find<ChannelScreenTabController>(
        tag: 'channel-screen-${widget.layoutId}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          channelScreenTabController.pageViewIndex.value = widget.index;
        },
        child: widget.itemWidget(
            isActive:
                channelScreenTabController.tabIndex.value == widget.index),
      );
    });
  }
}
