import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/models/color_keys.dart';

import '../../config/colors.dart';

final logger = Logger();

class LayoutTabBarItem extends StatefulWidget {
  const LayoutTabBarItem({
    Key? key,
    required this.layoutId,
    required this.index,
    required this.name,
  }) : super(key: key);

  final int layoutId;
  final int index;
  final String name;

  @override
  _LayoutTabBarItemState createState() => _LayoutTabBarItemState();
}

class _LayoutTabBarItemState extends State<LayoutTabBarItem> {
  late ChannelScreenTabController channelScreenTabController;

  @override
  void initState() {
    super.initState();
    channelScreenTabController = Get.find<ChannelScreenTabController>(
        tag: 'channel-screen-${widget.layoutId}');
  }

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Obx(() {
        return Text(
          widget.name,
          style: TextStyle(
            color: channelScreenTabController.tabIndex.value == widget.index
                ? AppColors.colors[ColorKeys.primary]
                : const Color(0xffCFCECE),
          ),
        );
      }),
    );
  }
}
